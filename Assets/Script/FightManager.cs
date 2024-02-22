using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class FightManager : MonoBehaviour
{
    [Header("Enemy detection")]

    [Tooltip("the tolerence for the enemy selection when the joystick is used")]
    [SerializeField]
    float sphereCastR = 5;

    [Tooltip("distance at which the far can no longer touch")]
    [SerializeField]
    float farMax = 5;

    [Tooltip("distance at which the close can no longer touch")]
    [SerializeField]
    float closeMax = 5;

    [Tooltip("the layers that can be considered by the fight system")]
    [SerializeField]
    LayerMask enemyLayer;

    //----------------------
    [Space (5)]
    [Header ("Dash")]

    [Tooltip("the force given to the player for the dash")]
    [SerializeField]
    AnimationCurve dashStrength;

    [Tooltip("the duration of the dash")]
    [SerializeField]
    float dashDuration = 0.25f;

    //-----------------
    [Space(5)]
    [Header("Counter")]

    [Tooltip("Time in which the player is in counter state")]
    [SerializeField]
    float counterTime = 0.2f;

    //-----------------
    [Space(5)]
    [Header("attackSpeed")]

    [Tooltip("the force given to the player for the dash")]
    [SerializeField]
    float baseFightMoveSpeed = 2;

    [Tooltip("the max speed that the player will reach when combo")]
    [SerializeField]
    float maxFightMoveSpeed = 5;

    [Tooltip("the amount of speed added for each new point in the combo")]
    [SerializeField]
    float moveSpeedAdded = 0.1f;

    //-----------------
    [Space(5)]
    [Header("Other Attack Related")]

    [Tooltip("Combo Text")]
    [SerializeField]
    TextMeshProUGUI comboText;

    [Tooltip("Max time whithout attacking before the combo is lost")]
    [SerializeField]
    float maxTimeFight;

    [Space(5)]
    [Header("Other")]

    [SerializeField]
    GameObject pivotCam;

    //private variable
    GameInputManager inputPlayer;

    PlayerMovement playerMovement;

    GameObject focusedEnemy, closeEnemy, farEnemy;

    float timerC = 0;

    bool isDash = false;
    float dashTimer =0;
    Vector2 dashDir;

    int currentCombo;

    float fightMoveSpeed;

    float LerpPos;
    bool doLerp;
    Vector3 startLerpPos, endLerpPos;

    #region InputSetUP
    private void Awake()
    {
        inputPlayer = new();
        inputPlayer.Enable();
    }

    void InitializeInput()
    {
        inputPlayer.Fight.Attack.performed += ctx => AttackClose();

        inputPlayer.Fight.DistAttack.performed += ctx => AttackDist();

        inputPlayer.Fight.Counter.performed += ctx => timerC = 0;
        inputPlayer.Fight.Dash.performed += ctx => CallOnDash();
    }

    #endregion

    void Start()
    {
        InitializeInput();

        playerMovement = GetComponent<PlayerMovement>();

        fightMoveSpeed = baseFightMoveSpeed;
    }

    // Update is called once per frame
    void Update()
    {
        EnemySelection();

        GoToEnemy();

        Dash();

        CounterStateControl();
        CounterAct();
    }

    void EnemySelection()
    {
        Vector3 direction = playerMovement.movementVector;

        if (direction != Vector3.zero)
        {
            RaycastHit hit;
            if(Physics.SphereCast(transform.position, sphereCastR, direction, out hit, farMax, enemyLayer))
            {
                if (hit.collider.gameObject != null)
                {
                    if (Vector3.Distance(hit.transform.position, transform.position) < closeMax)
                    {
                        closeEnemy = hit.collider.gameObject;
                    }
                    else farEnemy = hit.collider.gameObject;
                }
            }
        }

        if (closeEnemy != null) return;

        float closestEnemy = Mathf.Infinity;
        float enemy = Mathf.Infinity;

        Collider[] enemyList = Physics.OverlapSphere(transform.position, closeMax/2, enemyLayer);

        for(int i = 0; i < enemyList.Length; i++)
        {
            float tempD = Vector3.Distance(enemyList[i].transform.position, transform.position);

            if (tempD < closestEnemy)
            {
                closestEnemy = tempD;
                enemy = i;
            }
        }

        if (enemy < enemyList.Length) closeEnemy = enemyList[(int)enemy].gameObject;
    }

    void GoToEnemy()
    {
        if (!doLerp) return;

        if (LerpPos >= 1)
        {
            doLerp = false;
            LerpPos = 0;

            playerMovement.enabled = true;

            focusedEnemy = closeEnemy;

            //call again to hit
            AttackClose();

            return;
        }

        if (LerpPos == 0)
        {
            if (focusedEnemy != null) focusedEnemy.GetComponent<Enemy>().IsCurrentFight(false);
            focusedEnemy = null;

            closeEnemy.GetComponent<Enemy>().IsCurrentFight(true);

            startLerpPos = transform.position;
            endLerpPos = closeEnemy.transform.position + ((closeEnemy.transform.position - transform.position).normalized);

            playerMovement.enabled = false;
        }

        transform.position = Vector3.Lerp(startLerpPos, endLerpPos, LerpPos);

        LerpPos += Time.deltaTime * fightMoveSpeed;
    }

    void AttackClose()
    {
        if (!VerifyCanAct()) return;

        if (focusedEnemy != closeEnemy)
        {
            doLerp = true;
            return;
        }

        if(focusedEnemy != null) focusedEnemy.GetComponent<Enemy>().EnemyDamage();
    }

    void AttackDist()
    {
        if (!VerifyCanAct()) return;

        if (farEnemy != null) farEnemy.GetComponent<Enemy>().EnemyDamage();
        else if (closeEnemy != null) closeEnemy.GetComponent<Enemy>().EnemyDamage();
    }

    void CounterStateControl()
    {
        if (timerC < counterTime)
        {
            timerC += Time.deltaTime;
        }
        else
        {
            
        }
    }

    void CounterAct()
    {

    }

    void CallOnDash()
    {
        if (!VerifyCanAct()) return;

        if (!isDash)
        {
            isDash = true;
            dashTimer = 0;
            dashDir = GetDashDir();
            playerMovement.canMove = false;
        }
    }

    Vector2 GetDashDir()
    {
        if (playerMovement.movementVector != Vector3.zero)
        {
            return playerMovement.movementVector;
        }
        else if (closeEnemy != null)
        {
            Vector3 dir = transform.position - closeEnemy.transform.position;
            dir = -dir.normalized;
            return dir;
        }
        else
        {
            return playerMovement.pivotCam.transform.forward;
        }
    }

    void Dash()
    {
        if (dashTimer >= dashDuration)
        {
            playerMovement.canMove = true;
            isDash = false;
            return;
        }

        dashTimer += Time.deltaTime;

        GetComponent<Rigidbody>().velocity = dashDir * dashStrength.Evaluate(dashTimer/dashDuration);
    }

    bool VerifyCanAct()
    {
        if (isDash || doLerp) return false;
        else return true;
    }

    public void EnemyDied()
    {
        focusedEnemy = null;
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.DrawWireSphere(transform.position, closeMax/2);
    }
}

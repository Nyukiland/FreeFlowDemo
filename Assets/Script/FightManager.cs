using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FightManager : MonoBehaviour
{
    [Header("variable that needs to be set")]

    [Tooltip("Time in which the player is in counter state")]
    [SerializeField]
    float counterTime = 0.2f;

    [Tooltip("how long the player should hold for a hard attack")]
    [SerializeField]
    float hardAttackTime = 0.1f;

    [Tooltip("the force given to the player for the dash")]
    [SerializeField]
    AnimationCurve dashStrength;

    [Tooltip("the duration of the dash")]
    [SerializeField]
    float dashDuration = 0.25f;

    [Tooltip("the force given to the player for the dash")]
    [SerializeField]
    float moveAttackSpeed = 5;

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

    //private variable
    GameInputManager inputPlayer;

    PlayerMovement playerMovement;

    GameObject closeEnemy, farEnemy;

    float timerC = 0;

    bool isDash;
    float dashTimer;
    Vector2 dashDir;

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
    }

    // Update is called once per frame
    void Update()
    {
        EnemySelection();

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

        Collider[] enemyList = Physics.OverlapSphere(transform.position, closeMax);

        for(int i = 0; i < enemyList.Length; i++)
        {
            float tempD = Vector3.Distance(enemyList[i].transform.position, transform.position);

            if (tempD < closestEnemy)
            {
                closestEnemy = tempD;
                enemy = i;
            }
        }

        closeEnemy = enemyList[(int)enemy].gameObject;
    }

    void AttackClose()
    {
        closeEnemy.GetComponent<Enemy>().EnemyDamage(transform.position + closeEnemy.transform.position, false);
    }

    void AttackDist()
    {
        if (farEnemy != null) farEnemy.GetComponent<Enemy>().EnemyDamage(transform.position + closeEnemy.transform.position, false);
    }

    void GrabAttackDist()
    {

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
}

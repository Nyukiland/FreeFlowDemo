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
    float dashStrength = 10;

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

    [Header("public variable do not touch")]

    public List<GameObject> enemyList;

    //private variable
    GameInputManager inputPlayer;

    PlayerMovement playerMovement;

    GameObject closeEnemy, farEnemy;

    float timerC = 0;

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
        inputPlayer.Fight.Dash.performed += ctx => StartCoroutine(DashAction());
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
                    if (closeEnemy == null && Vector3.Distance(hit.transform.position, transform.position) < closeMax) closeEnemy = hit.collider.gameObject;
                    else farEnemy = hit.collider.gameObject;
                }
            }
        }


        float closestEnemy = Mathf.Infinity;
        float enemy = Mathf.Infinity;

        for(int i = 0; i < enemyList.Count; i++)
        {
            float tempD = Vector3.Distance(enemyList[i].transform.position, transform.position);

            if (tempD < closestEnemy)
            {
                closestEnemy = tempD;
                enemy = i;
            }
        }
    }

    void AttackClose()
    {
        closeEnemy.GetComponent<Enemy>().EnemyDamage(transform.position + closeEnemy.transform.position, false);
    }

    void AttackDist()
    {

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

    IEnumerator DashAction()
    {
        //remove the player movement during dash
        playerMovement.canMove = false;

        //actual dash
        if (playerMovement.movementVector != Vector3.zero)
        {
            //dash in the direction of the stick
            GetComponent<Rigidbody>().AddForce(playerMovement.movementVector * dashStrength, ForceMode.Impulse);
        }
        else if (closeEnemy != null)
        {
            //dash in the opposite direction of the enemy
            Vector3 dir = transform.position - closeEnemy.transform.position;
            dir = -dir.normalized;

            GetComponent<Rigidbody>().AddForce(dir * dashStrength, ForceMode.Impulse);
        }
        else
        {
            //dash forward
            GetComponent<Rigidbody>().AddForce(playerMovement.pivotCam.transform.forward * dashStrength, ForceMode.Impulse);
        }

        yield return new WaitForSeconds(1f);

        //restore dash
        playerMovement.canMove = true;
    }
}

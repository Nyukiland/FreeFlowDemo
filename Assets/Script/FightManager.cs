using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FightManager : MonoBehaviour
{
    [Header("variable that needs to be set")]

    [Tooltip("Proximity needed to attack the enemy")]
    [SerializeField]
    float proximityAttack = 2f;

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

    [Header("public variable do not touch")]

    public List<GameObject> enemyList;


    //private variable
    GameInputManager inputPlayer;

    PlayerMovement playerMovement;

    GameObject currentEnemy;
    public GameObject currentActiveEnemy;

    bool startAttackC, stopAttackC;
    bool startAttackD, stopAttackD;
    bool counter;

    float timerC = 0, timerAC = 0, timerAD = 0;

    #region InputSetUP
    private void Awake()
    {
        inputPlayer = new();
        inputPlayer.Enable();
    }

    void InitializeInput()
    {
        inputPlayer.Fight.Attack.performed += ctx => startAttackC = true;
        inputPlayer.Fight.Attack.canceled += ctx => stopAttackC = true;

        inputPlayer.Fight.DistAttack.performed += ctx => startAttackD = true;
        inputPlayer.Fight.DistAttack.canceled += ctx => stopAttackD = true;

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
        EnemyProximity();

        CounterStateControl();
        CounterAct();

        TimerAttackC();
        TimerAttackD();
    }

    void EnemyProximity()
    {
        if (currentEnemy == null) return;
        if (Vector3.Distance(transform.position, currentEnemy.transform.position) < proximityAttack)
        {
            currentActiveEnemy = currentEnemy;
        }
    }

    void EnemySelection()
    {
        currentActiveEnemy = null;
        currentEnemy = null;
        float closestEnnemi = Mathf.Infinity;
        Vector3 direction = playerMovement.movementVector;

        for(int i = 0; i < enemyList.Count; i++)
        {
            float tempD = Vector3.Distance(enemyList[i].transform.position, transform.position);

            if (tempD < closestEnnemi)
            {
                closestEnnemi = tempD;
                currentEnemy = enemyList[i];
            }
        }
    }

    void TimerAttackC()
    {
        if (!startAttackC || startAttackD || counter) return;

        if (stopAttackC)
        {
            startAttackC = false;
            if (timerAC > hardAttackTime) HardAttackClose();
            else AttackClose();

            timerAC = 0;
            stopAttackC = false;
        }

        if (startAttackC)
        {
            stopAttackC = false;
            timerAC += Time.deltaTime;
        }
    }

    void AttackClose()
    {
        if (currentActiveEnemy != null) currentActiveEnemy.GetComponent<Enemy>().EnemyDamage(transform.position + currentActiveEnemy.transform.position, false);
    }

    void HardAttackClose()
    {
        if (currentActiveEnemy !=null) currentActiveEnemy.GetComponent<Enemy>().EnemyDamage(transform.position + currentActiveEnemy.transform.position, true);
    }

    void TimerAttackD()
    {
        if (!startAttackD || startAttackC || counter) return;

        if (stopAttackD)
        {
            startAttackD = false;
            if (timerAD < hardAttackTime) AttackDist();

            timerAD = 0;
            stopAttackD = false;
        }

        if (startAttackD)
        {
            stopAttackD = false;
            timerAD += Time.deltaTime;
            if (timerAD > hardAttackTime) GrabAttackDist();
        }
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
            counter = true;
        }
        else
        {
            counter = false;
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
        else if (currentEnemy != null)
        {
            //dash in the opposite direction of the enemy
            Vector3 dir = transform.position - currentEnemy.transform.position;
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

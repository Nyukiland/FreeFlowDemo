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

    [Header("public variable do not touch")]

    public List<GameObject> enemyList;


    //private variable
    GameInputManager inputPlayer;

    PlayerMovement playerMovement;

    GameObject currentEnemy;

    bool startAttackC, stopAttackC;
    bool startAttackD, stopAttackD;
    bool counter;

    float timerC = Mathf.Infinity, timerAC = Mathf.Infinity, timerAD = Mathf.Infinity;

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
        inputPlayer.Fight.Dash.performed += ctx => Dash();
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
        CounterStateControl();
        CounterAct();
        TimerAttackC();
        TimerAttackD();
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
        }

        if (startAttackC)
        {
            stopAttackC = false;
            timerAC += Time.deltaTime;
        }
    }

    void AttackClose()
    {

    }

    void HardAttackClose()
    {

    }

    void TimerAttackD()
    {
        if (!startAttackD || startAttackC || counter) return;

        if (stopAttackD)
        {
            startAttackD = false;
            if (timerAD > hardAttackTime) HardAttackDist();
            else AttackDist();

            timerAD = 0;
        }

        if (startAttackD)
        {
            stopAttackD = false;
            timerAD += Time.deltaTime;
        }
    }

    void AttackDist()
    {

    }

    void HardAttackDist()
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

    void Dash()
    {
        if (playerMovement.movementVector != Vector3.zero)
        {
            //dash in the direction of the stick
            GetComponent<Rigidbody>().AddForce(playerMovement.movementVector * dashStrength, ForceMode.Impulse);
        }
        else if (currentEnemy != null)
        {
            //dash in the opposite direction of the enemy
            Vector3 dir = transform.position - currentEnemy.transform.position;
            dir = - dir.normalized;

            GetComponent<Rigidbody>().AddForce(dir * dashStrength, ForceMode.Impulse);
        }
        else
        {
            //dash forward
            GetComponent<Rigidbody>().AddForce(playerMovement.pivotCam.transform.forward * dashStrength, ForceMode.Impulse);
        }
    }
}

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
    float hardAttackTime = 0.2f;

    [Header("public variable do not touch")]

    public List<GameObject> enemyList;


    //private variable
    GameInputManager inputPlayer;

    GameObject currentEnemy;

    float directionX, directionZ;

    bool startAttack, attack, chargedAttack, counter;

    float timerC = Mathf.Infinity, timerA = Mathf.Infinity;

    #region InputSetUP
    private void Awake()
    {
        inputPlayer = new();
        inputPlayer.Enable();
    }

    void InitializeInput()
    {
        inputPlayer.Movement.ForwardBack.performed += ctx => directionZ = ctx.ReadValue<float>();
        inputPlayer.Movement.ForwardBack.canceled += ctx => directionZ = 0;

        inputPlayer.Movement.LeftRight.performed += ctx => directionX = ctx.ReadValue<float>();
        inputPlayer.Movement.LeftRight.canceled += ctx => directionX = 0;

        inputPlayer.Fight.Attack.performed += ctx => startAttack = true;
        inputPlayer.Fight.Attack.canceled += ctx => startAttack = false;

        inputPlayer.Fight.Counter.performed += ctx => timerC = 0;
        inputPlayer.Fight.Dash.performed += ctx => Dash();
    }

    #endregion

    void Start()
    {
        InitializeInput();
    }

    // Update is called once per frame
    void Update()
    {
        CounterStateControl();
        CounterAct();
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
        if (GetDirection() != Vector3.zero)
        {
            //dash in the direction of the stick
        }
        else if (currentEnemy != null)
        {
            //dash in the opposite direction of the enemy
        }
        else
        {
            //dash forward
        }
    }

    Vector3 GetDirection()
    {
        if (directionX != 0 && directionZ != 0) return (transform.forward * directionZ) + (transform.right * directionX);

        return Vector3.zero;
    }
}

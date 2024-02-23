using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerProceduralAnim : MonoBehaviour
{
    [Header("General Setting")]

    [SerializeField]
    GameObject visu;

    [Space (5)]
    [Header ("Foot Related")]

    [SerializeField]
    Rigidbody rightFoot;

    [SerializeField]
    Rigidbody leftFoot;

    [SerializeField]
    Transform rightFootAnchor, leftFootAnchor;

    [Space (5)]
    [Header ("Hand Related")]

    [SerializeField]
    Rigidbody rightHand;
    
    [SerializeField]
    Rigidbody leftHand;

    PlayerMovement movementScript;
    FightManager fightScript;

    // Start is called before the first frame update
    void Start()
    {
        movementScript = GetComponent<PlayerMovement>();
        fightScript = GetComponent<FightManager>();
    }

    // Update is called once per frame
    void Update()
    {
        VisuRotation();

        rightFoot.transform.position = rightFootAnchor.position;
        leftFoot.transform.position = leftFootAnchor.position;
    }

    void VisuRotation()
    {
        if (fightScript.focusedEnemy != null && fightScript.timerFighting <= 0)
        {
            visu.transform.LookAt(new Vector3(fightScript.focusedEnemy.transform.position.x, visu.transform.position.y, fightScript.focusedEnemy.transform.position.z));
        }

        if (movementScript.movementVector != Vector3.zero)
        {
            visu.transform.LookAt(visu.transform.position + movementScript.movementVector);
        }
    }
}
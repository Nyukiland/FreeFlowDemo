using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    //private serialize variable
    [Header("variable that need to be set")]

    [Tooltip("speed multiplier used to move the character")]
    [SerializeField]
    float speed;

    [Tooltip("speed of the jump of the player")]
    [SerializeField]
    float JumpStrenght;

    [Tooltip("speed multiplier when sprinting")]
    [SerializeField]
    float sprintMultiplier;

    [Tooltip("camera for players direction, if the camera is not fix")]
    [SerializeField]
    GameObject pivotCam;

    //public variable
    //[Space(2)]
    //[Header("public varible (no need to touch)")]  

    //private variable
    Rigidbody character;

    GameInputManager inputPlayer;

    float moveX, moveY, moveZ;
    float isSprint = 1;

    #region InputSetUP
    private void Awake()
    {
        inputPlayer = new();
        inputPlayer.Enable();
    }

    void InitializeInput()
    {
        inputPlayer.Movement.ForwardBack.performed += ctx => moveX = ctx.ReadValue<float>();
        inputPlayer.Movement.ForwardBack.canceled += ctx => moveX = 0;

        inputPlayer.Movement.LeftRight.performed += ctx => moveZ = ctx.ReadValue<float>();
        inputPlayer.Movement.LeftRight.canceled += ctx => moveZ = 0;

        inputPlayer.Movement.sprintInput.performed += ctx => isSprint = 1 + (sprintMultiplier * ctx.ReadValue<float>());
        inputPlayer.Movement.sprintInput.canceled += ctx => isSprint = 1;

        inputPlayer.Movement.Jump.performed += ctx => Jump();
    }

    #endregion

    void Start()
    {
        character = GetComponent<Rigidbody>();

        InitializeInput();
    }

    void Update()
    {
        Movement();
    }

    //store the current y velocity
    //create a vector 3 with the input variable for the X and Z axis
    //clamp the magnitude of those input in order to make sure the player doesn't go faster in diagonal
    //set the velocity of the object to the new vector + the y velocity
    void Movement()
    {
        float vetVelo = character.velocity.y;

        Vector3 movement = (pivotCam.transform.forward * moveX) + (pivotCam.transform.right * moveZ);

        movement = Vector3.ClampMagnitude(movement, 1) * speed * isSprint;

        character.velocity = movement + (transform.up * vetVelo);
    }

    //verify if the player is grounded based on a raycast that check the distance between the lowest point of the player and the grounds
    bool Grounded()
    {
        if (Physics.Raycast(transform.position, -transform.up, out RaycastHit hit, Mathf.Infinity))
        {
            if (Vector3.Distance(hit.point, transform.position - transform.localScale / 2) <= 0.9f) return true;
        }

        return false;
    }

    //directly called by the input
    //if the player is grounded add an impulse forse upward
    void Jump()
    {
        if (!Grounded()) return;

        character.AddForce(transform.up * JumpStrenght, ForceMode.Impulse);
    }
}

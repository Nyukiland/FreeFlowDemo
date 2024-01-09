using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BallRollState : MonoBehaviour
{
    [SerializeField]
    GameObject visu;

    [SerializeField]
    float maxSpeed;

    [SerializeField]
    float acceleration;

    [SerializeField]
    float deceleration;

    [SerializeField]
    GameObject camPivot;

    [SerializeField]
    LineRenderer line;

    Rigidbody rb;
    GameInputManager inputs;

    Vector2 movementXY;
    Vector3 currentMovement = Vector3.zero;

    GameObject grappleOBJ;
    SpringJoint spring;

    private void Awake()
    {
        inputs = new();
        inputs.Enable();
    }

    void SetInput()
    {
        inputs.BallInput.Move.performed += ctx => movementXY = ctx.ReadValue<Vector2>();
        inputs.BallInput.Move.canceled += ctx => movementXY = Vector2.zero;

        inputs.BallInput.Jump.performed += ctx => Jump();

        inputs.BallInput.Grapple.performed += ctx => GappleAction();
        inputs.BallInput.Grapple.canceled += ctx => GrappleCancel();
    }

    // Start is called before the first frame update
    void Start()
    {
        SetInput();
        rb = GetComponent<Rigidbody>();

        PresetLine();
    }

    void PresetLine()
    {
        line.gameObject.transform.position = Vector3.zero;
        line.gameObject.transform.eulerAngles = Vector3.zero;
        line.gameObject.transform.localScale = Vector3.zero;
        line.gameObject.transform.parent = null;

        line.gameObject.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        MoveControl();
        VisuRotationControl();
        IsGrapple();
    }

    void MoveControl()
    {
        float ySpeed = rb.velocity.y;
        ySpeed += FallState();

        Vector3 movementSpeed = (camPivot.transform.forward * movementXY.y) + (camPivot.transform.right * movementXY.x);
        movementSpeed = SpeedControl(movementSpeed) + (Vector3.up * ySpeed);

        rb.velocity = movementSpeed;
    }

    float FallState()
    {
        LayerMask layerToIgnore = gameObject.layer;
        if (Physics.Raycast(transform.position, Vector3.down, GetComponent<SphereCollider>().radius + 0.1f, ~layerToIgnore))
        {
            return 0f;
        }
        return -20f * Time.deltaTime;
    }

    Vector3 SpeedControl(Vector3 direction)
    {
        Vector3 targetSpeed = direction * maxSpeed;

        if (targetSpeed.magnitude > currentMovement.magnitude)
        {
            currentMovement += direction.normalized * acceleration * Time.deltaTime;
        }
        else if (targetSpeed.magnitude < currentMovement.magnitude)
        {
            currentMovement -= currentMovement.normalized * deceleration * Time.deltaTime;
        }

        return currentMovement;
    }

    void Jump()
    {
        LayerMask layerToIgnore = gameObject.layer;
        if (Physics.Raycast(transform.position, Vector3.down, 1.1f, ~layerToIgnore))
        {
            rb.AddForce(Vector3.up * 20, ForceMode.Impulse);
        }
    }

    void VisuRotationControl()
    {
        Vector3 rotationAmount = new Vector3(rb.velocity.z, rb.velocity.y, -rb.velocity.x);

        visu.transform.Rotate(rotationAmount * rb.velocity.magnitude * 2 * Time.deltaTime, Space.World);
    }

    void GappleAction()
    {
        if (grappleOBJ == null) return;
        line.gameObject.SetActive(true);

        spring = gameObject.AddComponent<SpringJoint>();
        spring.autoConfigureConnectedAnchor = false;
        spring.connectedAnchor = grappleOBJ.transform.position;
    }

    void IsGrapple()
    {
        if (line.gameObject.activeSelf == true)
        {
            line.SetPosition(0, transform.position);
            line.SetPosition(1, grappleOBJ.transform.position);
        }
    }

    void GrappleCancel()
    {
        line.gameObject.SetActive(false);
        Destroy(spring);
        grappleOBJ = null;
    }

    private void OnTriggerStay(Collider other)
    {
        if (other.CompareTag("Grapple"))
        {
            if (grappleOBJ == null || Vector3.Distance(other.transform.position, transform.position) < Vector3.Distance(grappleOBJ.transform.position, transform.position))
            {
                grappleOBJ = other.gameObject;
            }
        }
    }

    private void OnEnable()
    {
        inputs.Enable();
    }

    private void OnDisable()
    {
        inputs.Disable();
        if (spring != null) Destroy(spring);
        if (line != null) line.gameObject.SetActive(false);
        currentMovement = Vector3.zero;
    }
}
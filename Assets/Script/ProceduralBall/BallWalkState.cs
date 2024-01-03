using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BallWalkState : MonoBehaviour
{
    GameInputManager inputs;

    [SerializeField]
    GameObject camDir;

    [SerializeField]
    float moveSpeed = 5f;

    Vector2 movementXY;
    float movementUp;

    Rigidbody rb;

    [SerializeField]
    LayerMask layerToIgnore;

    private void Awake()
    {
        inputs = new();
        inputs.Enable();
    }

    void SetInput()
    {
        inputs.BallInput.Move.performed += ctx => movementXY = ctx.ReadValue<Vector2>();
        inputs.BallInput.Move.canceled += ctx => movementXY = Vector2.zero;

        inputs.BallInput.UpDown.performed += ctx => movementUp = ctx.ReadValue<float>();
        inputs.BallInput.UpDown.canceled += ctx => movementUp = 0;
    }

    // Start is called before the first frame update
    void Start()
    {
        SetInput();

        rb = GetComponent<Rigidbody>();
    }

    // Update is called once per frame
    void Update()
    {
        Collider[] listCol = Physics.OverlapSphere(transform.position, GetComponent<SphereCollider>().radius * 4, ~layerToIgnore);

        Move(listCol);
    }

    void Move(Collider[] cols)
    {
        if (cols.Length != 0)
        {
            Vector3 movement = (camDir.transform.forward * movementXY.y) + (camDir.transform.right * movementXY.x) + (Vector3.up * movementUp);
            rb.velocity = movement * moveSpeed;
        }
        else
        {
            rb.velocity += (camDir.transform.forward * movementXY.y) + (camDir.transform.right * movementXY.x);
            rb.velocity = Vector3.ClampMagnitude(rb.velocity, moveSpeed/2);
            rb.velocity += Vector3.down * 10 * Time.deltaTime;
        }
    }

    private void OnEnable()
    {
        inputs.Enable();
    }

    private void OnDisable()
    {
        inputs.Disable();
    }
}

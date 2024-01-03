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

    [SerializeField]
    LayerMask layerToIgnore;

    [SerializeField]
    LineRenderer[] tentacleLines;

    [SerializeField]
    float maxTentacleDistance = 10f;

    [SerializeField]
    int numberOfTentacules = 4;

    [SerializeField]
    Material tentaculeMat;

    Vector2 movementXY;
    float movementUp;

    Rigidbody rb;

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

        TentaculesSetUp();
    }

    void TentaculesSetUp()
    {
        tentacleLines = new LineRenderer[numberOfTentacules];
        for (int i = 0; i < numberOfTentacules; i++)
        {
            GameObject lineObject = new GameObject("TentacleLine" + i);
            tentacleLines[i] = lineObject.AddComponent<LineRenderer>();
            tentacleLines[i].positionCount = 2;
            tentacleLines[i].startWidth = 0.5f;
            tentacleLines[i].endWidth = 0.5f;
            tentacleLines[i].material = tentaculeMat;
        }
    }

    // Update is called once per frame
    void Update()
    {
        Collider[] listCol = Physics.OverlapSphere(transform.position, GetComponent<SphereCollider>().radius * 8, ~layerToIgnore);

        Move(listCol);

        AllTentaculesUpdate(listCol);
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
            rb.velocity += ((camDir.transform.forward * movementXY.y) + (camDir.transform.right * movementXY.x)) * Time.deltaTime;
            rb.velocity += Vector3.down * 20 * Time.deltaTime;
        }
    }

    void AllTentaculesUpdate(Collider[] cols)
    {
        if (cols.Length == 0)
        {
            for (int h = 0; h < numberOfTentacules; h++)
            {
                tentacleLines[h].gameObject.SetActive(false);
            }
            return;
        }

        int nonColl = numberOfTentacules - cols.Length;

        for (int i = 0; i < cols.Length; i++)
        {
            tentacleLines[i].gameObject.SetActive(true);
            TentaculeUpdate(cols[i].ClosestPoint(transform.position), tentacleLines[i]);
        }

        for (int j = 0; j < nonColl+1; j++)
        {
            tentacleLines[j].gameObject.SetActive(true);
            TentaculeUpdate(TentaculePos(cols), tentacleLines[j]);
        }
    }

    Vector3 TentaculePos(Collider[] cols)
    {
        Vector3 direction = Vector3.zero;
        foreach (Collider col in cols)
        {
            direction += col.transform.position;
        }
        direction /= cols.Length;

        Vector3 randomPos2D = new Vector3(Random.insideUnitCircle.x, 0, Random.insideUnitCircle.y) * maxTentacleDistance;
        Vector3 pos = transform.position + randomPos2D;

        float rotationAngle = Vector3.Angle(pos - transform.position, direction - transform.position);
        pos = Quaternion.Euler(0, rotationAngle, 0) * pos;

        int attempts = 0;
        while (attempts < 20)
        {
            Vector3 rayDirection = (pos - transform.position).normalized;

            RaycastHit hit;
            if (Physics.Raycast(transform.position, rayDirection, out hit, maxTentacleDistance, ~layerToIgnore))
            {
                return hit.point;
            }
            else
            {
                pos = transform.position + (Random.onUnitSphere * maxTentacleDistance);
                attempts++;
            }
        }

        return transform.position;
    }

    void TentaculeUpdate(Vector3 pos, LineRenderer line)
    {
        line.SetPosition(0, transform.position);

        if (Vector3.Distance(transform.position, line.GetPosition(1)) < maxTentacleDistance + 1 && Vector3.Distance(transform.position, line.GetPosition(1)) > 0.5f) return;

        line.SetPosition(1, pos);
    }

    private void OnEnable()
    {
        inputs.Enable();
    }

    private void OnDisable()
    {
        inputs.Disable();

        for (int k = 0; k < numberOfTentacules; k++)
        {
            tentacleLines[k].gameObject.SetActive(false);
        }
    }
}

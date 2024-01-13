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

    public float maxTentacleDistance = 10f;

    [SerializeField]
    int numberOfTentacules = 4;

    [SerializeField]
    Material tentaculeMat;

    [SerializeField]
    Vector2 rngTentaculeLerpSpeed;

    bool hasCollider;
    bool wasTentacule;

    Vector2 movementXY;
    float movementUp;
    Vector3 movementInput;

    Rigidbody rb;

    Vector3 previousPos;
    int staticReposOnce;
    float smallTimer;

    Vector3[] tentaculePosToGo;
    Vector3[] tentaculeStartPos;
    Vector2[] tentaculeLerpValues;

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
        tentaculePosToGo = new Vector3[numberOfTentacules];
        tentaculeStartPos = new Vector3[numberOfTentacules];
        tentaculeLerpValues = new Vector2[numberOfTentacules];

        tentacleLines = new LineRenderer[numberOfTentacules];
        for (int i = 0; i < numberOfTentacules; i++)
        {
            GameObject lineObject = new GameObject("TentacleLine" + i);
            tentacleLines[i] = lineObject.AddComponent<LineRenderer>();
            tentacleLines[i].positionCount = 2;
            tentacleLines[i].startWidth = 0.5f;
            tentacleLines[i].endWidth = 0.5f;
            tentacleLines[i].material = tentaculeMat;

            tentaculeStartPos[i] = transform.position;
            tentaculePosToGo[i] = transform.position;
            tentaculeLerpValues[i] = new(1, Random.Range(rngTentaculeLerpSpeed.x, rngTentaculeLerpSpeed.y));
        }
    }

    // Update is called once per frame
    void Update()
    {
        Collider[] listCol = Physics.OverlapSphere(transform.position, GetComponent<SphereCollider>().radius * (maxTentacleDistance - 4), ~layerToIgnore);

        hasCollider = listCol.Length != 0;

        Move();

        AllTentaculesUpdate(listCol);

        for (int i = 0; i < numberOfTentacules; i++)
        {
            SmoothTentacule(i);
        }

        //this should always be at the end of the update
        if (previousPos != transform.position)
        {
            staticReposOnce = numberOfTentacules;
        }

        if (smallTimer <= 0)
        {
            previousPos = transform.position;
            smallTimer = 1;
        }
        else smallTimer -= Time.deltaTime;
    }

    void Move()
    {
        movementInput = (camDir.transform.forward * movementXY.y) + (camDir.transform.right * movementXY.x) + (Vector3.up * movementUp);

        if (hasCollider)
        {
            Vector3 movement = movementInput * moveSpeed;

            if (movement == Vector3.zero && wasTentacule) movement = rb.velocity * 0.95f;

            rb.velocity = movement;

            wasTentacule = true;
        }
        else
        {
            wasTentacule = false;

            rb.velocity += ((camDir.transform.forward * movementXY.y) + (camDir.transform.right * movementXY.x)) * Time.deltaTime;
            rb.velocity += Vector3.down * 20 * Time.deltaTime;
        }
    }

    void AllTentaculesUpdate(Collider[] cols)
    {
        if (!hasCollider)
        {
            for (int i = 0; i < numberOfTentacules; i++)
            {
                tentacleLines[i].gameObject.SetActive(false);
            }
            return;
        }

        for (int j = 0; j < numberOfTentacules; j++)
        {
            tentacleLines[j].gameObject.SetActive(true);
            TentaculeUpdate(TentaculePos(cols), tentacleLines[j], j);
        }
    }

    Vector3 temp;

    Vector3 TentaculePos(Collider[] cols)
    {
        Vector3 direction = Vector3.zero;
        foreach (Collider col in cols)
        {
            direction += (col.ClosestPoint(transform.position) - transform.position).normalized;
        }
        direction /= cols.Length;

        Debug.Log(direction.normalized);

        Vector3 pos = GenerateRandomPointOnPlane(direction) + transform.position + (direction * 2) + (movementInput.normalized * 6);
        temp = pos;

        int attempts = 0;
        while (attempts < 50)
        {
            Vector3 rayDirection = (pos - transform.position).normalized;

            RaycastHit hit;
            if (Physics.Raycast(transform.position, rayDirection, out hit, maxTentacleDistance * 1.5f, ~layerToIgnore))
            {
                return hit.point;
            }
            else
            {
                pos = GenerateRandomPointOnPlane(direction) + transform.position + (direction * 2) + (movementInput.normalized * 6);
                attempts++;
            }
        }
        Debug.Log("Nonononono");
        return transform.position;
    }

    Vector3 GenerateRandomPointOnPlane(Vector3 dir)
    {
        Vector3 checkTo = Vector3.forward;
        if (checkTo == dir) checkTo = Vector3.up;

        // Compute a perpendicular vector to the given upDirection
        Vector3 perp1 = Vector3.Cross(dir, checkTo).normalized;

        // Compute another perpendicular vector in the plane
        Vector3 perp2 = Vector3.Cross(dir, perp1).normalized;

        // Generate random point in the plane
        float randomAngle = Random.Range(0f, 2f * Mathf.PI);
        float randomRadius = Mathf.Sqrt(Random.Range(0, maxTentacleDistance*2)); // square root to ensure uniform distribution on circle
        Vector3 randomPoint = perp1 * randomRadius * Mathf.Cos(randomAngle) + perp2 * randomRadius * Mathf.Sin(randomAngle);

        return randomPoint;
    }

    void TentaculeUpdate(Vector3 pos, LineRenderer line, int index)
    {
        line.SetPosition(0, transform.position);

        if (staticReposOnce >= 0 && transform.position == previousPos)
        {
            staticReposOnce--;
            tentaculePosToGo[index] = pos;
        }

        if (Vector3.Distance(transform.position, tentaculePosToGo[index]) < maxTentacleDistance * 1.5) return;

        tentaculePosToGo[index] = pos;
    }

    void SmoothTentacule(int index)
    {
        if (tentaculeStartPos[index] == tentaculePosToGo[index]) return;

        Vector3 posLerping = transform.position;
        if (tentaculeLerpValues[index].x <= -1)
        {
            tentaculeStartPos[index] = tentaculePosToGo[index];
            tentaculeLerpValues[index] = new(1, Random.Range(rngTentaculeLerpSpeed.x, rngTentaculeLerpSpeed.y));
            return;
        }
        else if (tentaculeLerpValues[index].x > 0)
        {
            posLerping = Vector3.Lerp(transform.position, tentaculeStartPos[index], tentaculeLerpValues[index].x);
        }
        else
        {
            posLerping = Vector3.Lerp(transform.position, tentaculePosToGo[index], Mathf.Abs(tentaculeLerpValues[index].x));
        }

        tentaculeLerpValues[index].x -= Time.deltaTime * (index + (tentaculeLerpValues[index].y) / index);
        Mathf.Clamp(tentaculeLerpValues[index].x, -1, 1);
        tentacleLines[index].SetPosition(1, posLerping);
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
            if (tentacleLines[k] != null) tentacleLines[k].gameObject.SetActive(false);
        }
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.white;
        Gizmos.DrawLine(transform.position, temp);
        Gizmos.DrawWireSphere(temp, 1);
        Gizmos.DrawWireSphere(transform.position, maxTentacleDistance);
    }
}

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

    [SerializeField]
    Vector2 rngTentaculeLerpSpeed;

    Vector2 movementXY;
    float movementUp;

    Rigidbody rb;

    Vector3 previousPos;
    int staticReposOnce;
    float smallTimer;

    Vector3[] tentaculePosToGo;
    Vector3[] tentaculeStartPos;
    float[] tentaculeLerp;

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
        tentaculeLerp = new float[numberOfTentacules];

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
            tentaculeLerp[i] = 1;
        }
    }

    // Update is called once per frame
    void Update()
    {
        Collider[] listCol = Physics.OverlapSphere(transform.position, GetComponent<SphereCollider>().radius * maxTentacleDistance, ~layerToIgnore);

        Move(listCol);

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
            direction += col.transform.position;
        }
        direction /= cols.Length;

        Vector3 randomPos2D = new Vector3(Random.insideUnitCircle.x, 0, Random.insideUnitCircle.y) * maxTentacleDistance;
        Vector3 pos = transform.position + randomPos2D;

        float rotationAngle = Vector3.Angle(pos - transform.position, direction - transform.position);
        pos = (Quaternion.Euler(0, rotationAngle, 0) * pos);
        temp = pos;

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

    Vector3 RandomSpotLightCirclePoint(Vector3 dir)
    {
        Vector2 circle = Random.insideUnitCircle * maxTentacleDistance/2;
        Vector3 target = transform.position + dir + transform.rotation * new Vector3(circle.x, circle.y);
        return target;
    }

    void TentaculeUpdate(Vector3 pos, LineRenderer line, int index)
    {
        line.SetPosition(0, transform.position);
        
        if (staticReposOnce >=0 && transform.position == previousPos)
        {
            staticReposOnce --;
            tentaculePosToGo[index] = pos;
        }
        
        if (Vector3.Distance(transform.position, tentaculePosToGo[index]) < maxTentacleDistance + 1) return;

        tentaculePosToGo[index] = pos;
    }

    void SmoothTentacule(int index)
    {
        if (tentaculeStartPos[index] == tentaculePosToGo[index]) return;

        Vector3 posLerping = transform.position;
        if (tentaculeLerp[index] <= -1)
        {
            tentaculeStartPos[index] = tentaculePosToGo[index];
            tentaculeLerp[index] = 1;
            return;
        }
        else if (tentaculeLerp[index] > 0)
        {
            posLerping = Vector3.Lerp(transform.position, tentaculeStartPos[index], tentaculeLerp[index]);
        }
        else
        {
            posLerping = Vector3.Lerp(transform.position, tentaculePosToGo[index], Mathf.Abs(tentaculeLerp[index]));
        }

        tentaculeLerp[index] -= Time.deltaTime * (index + (Random.Range(rngTentaculeLerpSpeed.x, rngTentaculeLerpSpeed.y)/index));
        Mathf.Clamp(tentaculeLerp[index], -1, 1);
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
    }
}

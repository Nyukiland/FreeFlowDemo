using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BallChangeState : MonoBehaviour
{
    GameInputManager inputs;

    bool ballState = true;

    [SerializeField]
    float camSpeed = 0;

    Material baseMat;

    [SerializeField]
    MeshRenderer visu;

    [SerializeField]
    Material ballMat;

    [SerializeField]
    Material WalkMat;

    private void Awake()
    {
        inputs = new();
        inputs.Enable();
    }

    void SetInput()
    {
        inputs.BallInput.ChangeState.performed += ctx => ChangeState();
    }

    // Start is called before the first frame update
    void Start()
    {
        baseMat = visu.materials[0];
        SetInput();
        ActivateBallState(true);
        ActivateWalkState(false);
    }

    private void Update()
    {
        if (ballState && Camera.main.fieldOfView > 80)
        {
            Camera.main.fieldOfView -= Time.deltaTime * camSpeed;
        }
        else if (!ballState && Camera.main.fieldOfView < 100)
        {
            Camera.main.fieldOfView += Time.deltaTime * camSpeed;
        }

        Camera.main.fieldOfView = Mathf.Clamp(Camera.main.fieldOfView, 80, 100);
    }

    void ChangeState()
    {
        ballState = !ballState;

        if (ballState)
        {
            ActivateBallState(true);
            ActivateWalkState(false);
        }
        else
        {
            ActivateBallState(false);
            ActivateWalkState(true);
        }
    }

    void ActivateBallState(bool isActive)
    {
        GetComponent<BallRollState>().enabled = isActive;
        if (isActive)
        {
            Material[] mats = new Material[2] {baseMat, ballMat};
            visu.materials = mats;
        }
    }

    void ActivateWalkState(bool isActive)
    {
        GetComponent<BallWalkState>().enabled = isActive;
        if (isActive)
        {
            Material[] mats = new Material[2] { baseMat, WalkMat};
            visu.materials = mats;
        }
    }
}

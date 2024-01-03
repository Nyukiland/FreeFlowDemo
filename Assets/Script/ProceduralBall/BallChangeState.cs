using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BallChangeState : MonoBehaviour
{
    GameInputManager inputs;

    bool ballState = true;

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
        SetInput();
        ActivateBallState(true);
        ActivateWalkState(false);
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
        if (isActive) visu.materials[0] = ballMat;
    }

    void ActivateWalkState(bool isActive)
    {
        GetComponent<BallWalkState>().enabled = isActive;
        if (isActive) visu.materials[0] = WalkMat;
    }
}

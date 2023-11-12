using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraBehavior : MonoBehaviour
{
    GameInputManager inputManager;

    [Tooltip("the camera (used to look up and down)")]
    [SerializeField]
    GameObject camPivotX;

    [Tooltip("the pivot (used to look left and right)")]
    [SerializeField]
    GameObject camPivotY;

    [Tooltip("the camera")]
    [SerializeField]
    GameObject cam;

    [Tooltip("sensibility to look up and down")]
    [SerializeField]
    float sensibilityY = 0.5f;

    [Tooltip("max rotation the camera can do in order to look up or down")]
    [Range(10, 90)]
    [SerializeField]
    float clampRot = 75;

    [Tooltip("sensibility to look left and right")]
    [SerializeField]
    float sensibilityX = 0.5f;

    [Tooltip("layer to ignore for the camera collision")]
    [SerializeField]
    LayerMask layerToIgnore;

    float mouseX, mouseY, xRot, yRot;

    float distCamPivot;
    Vector3 camBasePos;
    float FOVBase;

    #region InputSetUP

    private void Awake()
    {
        inputManager = new();
        inputManager.Enable();
    }

    void InitializeInput()
    {
        inputManager.Camera.Xmove.performed += ctx => mouseX = ctx.ReadValue<float>();
        inputManager.Camera.Xmove.canceled += ctx => mouseX = 0;

        inputManager.Camera.Ymove.performed += ctx => mouseY = ctx.ReadValue<float>();
        inputManager.Camera.Ymove.canceled += ctx => mouseY = 0;
    }

    #endregion

    private void Start()
    {
        InitializeInput();

        camBasePos = cam.transform.localPosition;
        distCamPivot = Vector3.Distance(camPivotY.transform.position, cam.transform.position);
    }

    private void Update()
    {
        CameraMovement();
        CamDistCheck();
    }

    void CameraMovement()
    {
        yRot += mouseX * sensibilityX * Time.deltaTime;
        Vector3 roty = camPivotY.transform.eulerAngles;
        roty.y = yRot;
        camPivotY.transform.eulerAngles = roty;

        xRot -= mouseY * sensibilityY * Time.deltaTime;
        xRot = Mathf.Clamp(xRot, -clampRot, clampRot);
        Vector3 rotx = camPivotX.transform.eulerAngles;
        rotx.x = xRot;
        camPivotX.transform.eulerAngles = rotx;
    }

    void CamDistCheck()
    {
        Vector3 direction = cam.transform.TransformPoint(camBasePos) - camPivotY.transform.position;

        Ray ray = new Ray(camPivotY.transform.position, direction.normalized);
        RaycastHit hit;
        if (Physics.Raycast(ray, out hit, distCamPivot*1.65f, ~layerToIgnore))
        {
            Vector3 newPos = hit.point - (direction.normalized * 0.95f);
            if (Vector3.Distance(camPivotY.transform.position, newPos) < distCamPivot) cam.transform.position = newPos;
        }
        else
        {
            cam.transform.localPosition = camBasePos;
        }
    }
}

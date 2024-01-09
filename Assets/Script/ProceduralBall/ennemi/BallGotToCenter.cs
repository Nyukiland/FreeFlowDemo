using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BallGotToCenter : MonoBehaviour
{
    public GameObject GoToObject;

    Rigidbody rb;

    void Start()
    {
        rb = GetComponent<Rigidbody>();
    }

    void FixedUpdate()
    {
        rb.velocity = (GoToObject.transform.position - transform.position) * 10;
    }
}

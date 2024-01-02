using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class camFollow : MonoBehaviour
{
    [SerializeField]
    GameObject playerFollow;

    // Update is called once per frame
    void Update()
    {
        transform.position = playerFollow.transform.position;
    }
}

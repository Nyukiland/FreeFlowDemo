using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BallEnnemiCenterBehavior : MonoBehaviour
{
    [SerializeField]
    GameObject objToInstantiate;
    [SerializeField]
    int maxOBJ;
    Rigidbody rb;

    [SerializeField]
    LayerMask layerToIgnore;

    void Start()
    {
        rb = GetComponent<Rigidbody>();

        for (int i = 0; i < maxOBJ; i++)
        {
            GameObject temp = Instantiate(objToInstantiate, (Random.insideUnitSphere * 10) + transform.position, Quaternion.identity);
            temp.tag = "ennemiSphere";
            temp.transform.parent = transform.parent;
        }
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (!collision.collider.CompareTag("ennemiSphere"))
        {
            StartCoroutine(jumpprocess());
        }
    }

    IEnumerator jumpprocess()
    {
        rb.isKinematic = true;

        yield return new WaitForSeconds(3);

        Vector3 dir = Random.insideUnitSphere;
        while(Physics.Raycast(transform.position, dir, 5f, ~layerToIgnore))
        {
            dir = Random.insideUnitSphere;
        }

        rb.isKinematic = false;
        rb.AddForce(dir * 10, ForceMode.Impulse);
    }
}

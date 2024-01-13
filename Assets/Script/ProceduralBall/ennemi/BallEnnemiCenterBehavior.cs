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

    Vector3 nextDirection = new Vector3(0, 1, 0);

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
            nextDirection = -(collision.collider.ClosestPoint(transform.position) - transform.position);
            nextDirection = nextDirection.normalized;
            StartCoroutine(jumpprocess());
        }
    }

    IEnumerator jumpprocess()
    {
        rb.isKinematic = true;

        yield return new WaitForSeconds(3);

        Vector3 dir = new Vector3(Random.Range(nextDirection.x - 0.5f, nextDirection.x + 0.5f), Random.Range(nextDirection.y - 0.5f, nextDirection.y + 0.5f), Random.Range(nextDirection.z - 0.5f, nextDirection.z + 0.5f));
        while (Physics.Raycast(transform.position, dir.normalized, 5f, ~layerToIgnore))
        {
            dir = new Vector3(Random.Range(nextDirection.x - 0.5f, nextDirection.x + 0.5f), Random.Range(nextDirection.y - 0.5f, nextDirection.y + 0.5f), Random.Range(nextDirection.z - 0.5f, nextDirection.z + 0.5f));
        }

        Debug.Log(dir.normalized * 10);

        rb.isKinematic = false;
        rb.AddForce(dir.normalized * 10, ForceMode.Impulse);
    }
}

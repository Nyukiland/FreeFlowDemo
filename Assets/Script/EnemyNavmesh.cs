using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class EnemyNavmesh : MonoBehaviour
{
    public GameObject player;

    void Update()
    {
        GetComponent<NavMeshAgent>().SetDestination(player.transform.position);
    }
}

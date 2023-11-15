using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class Enemy : MonoBehaviour
{
    [SerializeField]
    float propultionForce;

    [SerializeField]
    GameObject healthVisuContainer;

    [SerializeField]
    GameObject[] lifeCount;

    public GameObject player;

    FightManager manager;
    NavMeshAgent nav;
    Rigidbody rb;

    int intLifeCount;

    private void Start()
    {
        manager = player.GetComponent<FightManager>();
        nav = GetComponent<NavMeshAgent>();
        rb = GetComponent<Rigidbody>();

        intLifeCount = lifeCount.Length - 1;
    }

    void Update()
    {
        if (nav.enabled) nav.SetDestination(player.transform.position);

        HealthLookAtCamera();
    }

    void HealthLookAtCamera()
    {
        Vector3 camPos = Camera.main.transform.position;

        healthVisuContainer.transform.LookAt(camPos);
    }

    public void EnemyDamage(Vector3 direction, bool isStrong)
    {
        HealthVisu(isStrong);

        if (intLifeCount >= 0) return;

        if (manager.enemyList.Contains(this.gameObject))
        {
            transform.tag = "Null";
            manager.enemyList.Remove(this.gameObject);
        }

        nav.enabled = false;
        rb.isKinematic = false;

        if (isStrong) rb.AddForce((direction + Vector3.up).normalized * propultionForce, ForceMode.Impulse);
        else rb.AddForce((direction + Vector3.up).normalized * (propultionForce/3), ForceMode.Impulse);

        Invoke("DestroyGameObject", 2);
    }

    void HealthVisu(bool isStrong)
    {
        lifeCount[intLifeCount].SetActive(false);
        intLifeCount--;

        if (isStrong)
        {
            intLifeCount = Mathf.Clamp(intLifeCount, 0, 100);
            lifeCount[intLifeCount].SetActive(false);
            intLifeCount--;
        }
    }

    void DestroyGameObject()
    {
        Destroy(this.gameObject);
    }
}

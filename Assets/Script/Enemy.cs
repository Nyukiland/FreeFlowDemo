using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.AI;

public class Enemy : MonoBehaviour
{
    [Header ("Visual Feedback")]

    [SerializeField]
    GameObject healthVisuContainer;

    [SerializeField]
    Image lifeBar;

    [SerializeField]
    GameObject visu;

    [SerializeField]
    ParticleSystem impactParticle;

    [SerializeField]
    Animator anim;

    [Space (5)]
    [Header ("Base Behavior")]

    [SerializeField]
    float propultionForce;

    [SerializeField]
    int maxLife;

    [Space (5)]
    [Header ("Movement")]

    public GameObject player;

    [SerializeField]
    float maxDistFromPlayer;

    NavMeshAgent nav;
    Rigidbody rb;

    int currentLife;

    private void Start()
    {
        nav = GetComponent<NavMeshAgent>();
        rb = GetComponent<Rigidbody>();

        currentLife = maxLife;
    }

    void Update()
    {
        if (nav.enabled) nav.SetDestination(player.transform.position);

        HealthLookAtCamera();

        visu.transform.LookAt(player.transform.position);
        visu.transform.localEulerAngles = new(0, visu.transform.localEulerAngles.y, 0);
    }

    void HealthLookAtCamera()
    {
        Vector3 camPos = Camera.main.transform.position;

        healthVisuContainer.transform.LookAt(camPos);
    }

    public void EnemyDamage()
    {
        lifeBar.fillAmount = currentLife / maxLife;

        if (currentLife >= 0) return;

        nav.enabled = false;
        rb.isKinematic = false;

        Vector3 direction = player.transform.position + transform.position;

        rb.AddForce((direction + Vector3.up).normalized * propultionForce, ForceMode.Impulse);

        Invoke("DestroyGameObject", 2);
    }

    void DestroyGameObject()
    {
        Destroy(this.gameObject);
    }

    public void IsCurrentFight(bool isTheCurrentClose)
    {
        if (isTheCurrentClose) nav.enabled = false;
        else nav.enabled = true;
    }
}

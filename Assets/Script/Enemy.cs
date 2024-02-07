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
        MovementControl();

        HealthLookAtCamera();

        LifeControl();

        visu.transform.LookAt(player.transform.position);
        visu.transform.localEulerAngles = new(0, visu.transform.localEulerAngles.y, 0);
    }

    void MovementControl()
    {
        if (!nav.enabled) return;

        Vector3 destinationToGo = player.transform.position;

        nav.SetDestination(destinationToGo);
    }

    void HealthLookAtCamera()
    {
        Vector3 camPos = Camera.main.transform.position;

        healthVisuContainer.transform.LookAt(camPos);
    }

    void LifeControl()
    {
        lifeBar.fillAmount = currentLife / maxLife;

        if (currentLife <= 0)
        {
            nav.enabled = false;
            rb.isKinematic = false;

            StartCoroutine(DeathEnnemi());
        }
    }

    public void EnemyDamage()
    {
        currentLife--;
    }

    IEnumerator DeathEnnemi()
    {
        Ragdollify();

        yield return new WaitForSeconds(2);

        Destroy(this.gameObject);
    }

    void Ragdollify()
    {

    }

    public void IsCurrentFight(bool isTheCurrentClose)
    {
        if (isTheCurrentClose) nav.enabled = false;
        else nav.enabled = true;
    }
}

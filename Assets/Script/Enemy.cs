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

    [SerializeField]
    string[] ImpactAnimNames;

    [Space (5)]
    [Header ("Movement")]

    public GameObject player;

    [SerializeField]
    float maxDistFromPlayer;

    NavMeshAgent nav;
    Rigidbody rb;

    float currentLife;

    Rigidbody[] Ragdoll;

    float distanceFromPlayer;

    private void Start()
    {
        nav = GetComponent<NavMeshAgent>();
        rb = GetComponent<Rigidbody>();

        Ragdoll = visu.GetComponentsInChildren<Rigidbody>();

        Ragdollify(false);

        currentLife = maxLife;

        distanceFromPlayer = Random.Range(0.75f, 1.25f);
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

        Vector3 destinationToGo = player.transform.position - ((player.transform.position - transform.position).normalized * player.GetComponent<FightManager>().closeMax * distanceFromPlayer);

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
        AnimImpact(Random.Range(0, ImpactAnimNames.Length - 1));
    }

    void AnimImpact(int number)
    {
        anim.Play(ImpactAnimNames[number]);
    }

    IEnumerator DeathEnnemi()
    {
        gameObject.layer = 0;
        player.GetComponent<FightManager>().EnemyDied();
        Ragdollify(true);

        yield return new WaitForSeconds(2);

        Destroy(this.gameObject);
    }

    void Ragdollify(bool isRagdoll)
    {
        foreach(Rigidbody rb in Ragdoll)
        {
            rb.isKinematic = !isRagdoll;
        }

        anim.enabled = !isRagdoll;
    }

    public void IsCurrentFight(bool isTheCurrentClose)
    {
        if (anim.enabled == false)
        {
            if (isTheCurrentClose) nav.enabled = false;
            else nav.enabled = true;
        }
    }
}

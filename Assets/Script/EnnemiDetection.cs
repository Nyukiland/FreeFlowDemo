using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnnemiDetection : MonoBehaviour
{
    [SerializeField]
    FightManager fightManager;

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "Enemy")
        {
            fightManager.enemyList.Add(other.gameObject);
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "Enemy")
        {
            fightManager.enemyList.Remove(other.gameObject);
        }
    }
}

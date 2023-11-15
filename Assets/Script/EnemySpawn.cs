using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemySpawn : MonoBehaviour
{
    [SerializeField]
    GameObject player;

    [SerializeField]
    GameObject enemyPrefab;

    [SerializeField]
    float spawnRate;

    [SerializeField]
    float spawnRadius;

    float timer;

    int spawned;

    // Update is called once per frame
    void Update()
    {
        if (timer < spawnRate) timer += Time.deltaTime;
        else
        {
            Spawn();
            timer = 0;
        }
    }

    void Spawn()
    {
        Vector3 pos = Random.insideUnitCircle.normalized * spawnRadius;

        pos = new Vector3(pos.x, 0, pos.y);

        GameObject temp = Instantiate(enemyPrefab, pos, Quaternion.identity);
        temp.GetComponent<Enemy>().player = player;
        temp.name = "enemy" + spawned;
        spawned++;
    }
}

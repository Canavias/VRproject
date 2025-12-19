using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Door : MonoBehaviour
{
    public List<GameObject> doorObjects = new List<GameObject>();
    
    private List<Quaternion> _doorRotations = new List<Quaternion>();
    
    public AudioClip doorOpenSound;
    public Animator animator;

    public Transform cameraMain;
    private AudioSource _audioSource; 
    private void Start()
    {
        _audioSource = GetComponent<AudioSource>();
        foreach (GameObject obj in doorObjects)
        {
            _doorRotations.Add(obj.transform.rotation);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            foreach (GameObject obj in doorObjects)
            {
                obj.transform.localRotation = Quaternion.Euler(0,-90,0);
            }
            _audioSource.PlayOneShot(doorOpenSound);
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player"))
        {
             for(int i =0 ;i<doorObjects.Count;i++)
             {
                 doorObjects[i].transform.rotation = _doorRotations[i];
             }
             _audioSource.PlayOneShot(doorOpenSound);
             if (cameraMain.position.x < transform.position.x)
             {
                 animator.enabled = true;
                 animator.SetBool("InDoor",true);   
             }
        }
    }
}

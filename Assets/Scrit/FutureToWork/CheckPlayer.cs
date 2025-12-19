using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem.XR;
using UnityEngine.XR.Interaction.Toolkit;
using XRController = UnityEngine.XR.Interaction.Toolkit.XRController;

public class CheckPlayer : MonoBehaviour
{
    public List<Vector3> positions = new List<Vector3>();
    public List<Vector3> rotations = new List<Vector3>();
    private List<bool> _finishs = new List<bool>();
    
    public List<Transform> transforms = new List<Transform>();
    public List<float> animatorSpeed = new List<float>();
    private Animator _animator;
    private bool _start;
    void Start()
    {
        _animator = GetComponent<Animator>();
        for (int i = 0; i < positions.Count; i++)
        {
            _finishs.Add(false);
        }
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            transforms[1].GetComponent<ActionBasedController>().enabled = false;
            transforms[2].GetComponent<ActionBasedController>().enabled = false;
            transforms[0].gameObject.SetActive(true);
            transforms[0].position = transforms[3].position;
            transforms[0].position = transforms[3].position;
            transforms[3].gameObject.SetActive(false);
            _start = true;
        }
    }

    private void Update()
    {
        if (_start)
        {
            for (int i = 0; i < positions.Count; i++)
            {
                if (!_finishs[i])
                {
                    transforms[i].position = Vector3.Lerp(transforms[i].position, positions[i], 
                        animatorSpeed[0] * Time.deltaTime);
                
                    Quaternion targetRotation = Quaternion.Euler(rotations[i]);
                    transforms[i].rotation = Quaternion.Lerp(transforms[i].rotation, targetRotation, 
                        animatorSpeed[1] * Time.deltaTime);
                    if ((transforms[i].position-positions[i]).magnitude < 0.1f)
                    {
                        _finishs[i] = true;
                    }
                }
            }
        }

        bool result = true;
        foreach (var tem in _finishs)
        {
            result &= tem;
        }

        if (result)
        {
            _animator.enabled = true;
            _animator.SetBool("Work",true);
        }
    }
    
}

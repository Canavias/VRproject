using System;
using System.Collections;
using System.Collections.Generic;
using NUnit.Framework;
using UnityEngine;
using UnityEngine.SceneManagement;

public class StartAnimationChange : MonoBehaviour
{
    private Animator animator;
    public Transform cameraTransform;
    private AudioSource audioSource;
    public List<AudioClip> audioClips = new List<AudioClip>();

    private void Start()
    {
        audioSource = GetComponent<AudioSource>();
        animator = GetComponent<Animator>();
    }

    public void StopAnimator()
    {
        animator.SetBool("Start",false);
        animator.enabled = false;
        
    }

    public void PlayAudio(int clipIndex)
    {
        audioSource.PlayOneShot(audioClips[clipIndex]);
    }

    public void ComeToNextScene()
    {
        cameraTransform = Camera.main.transform;
        animator.enabled = true;
        animator.SetBool("Work",true);
    }
    public void LoadNextScene()
    {
        SceneManager.LoadScene(2);
    }
}

using System;
using System.Collections;
using System.Collections.Generic;
using NUnit.Framework;
using UnityEngine;

public class StartAnimationChange : MonoBehaviour
{
    private Animator animator;
    private AudioSource audioSource;
    public List<AudioClip> audioClips = new List<AudioClip>();

    private void Start()
    {
        audioSource = GetComponent<AudioSource>();
        animator = GetComponent<Animator>();
    }

    public void StopAnimator()
    {
        animator.enabled = false;
    }

    public void PlayAudio(int clipIndex)
    {
        audioSource.PlayOneShot(audioClips[clipIndex]);
    }
}

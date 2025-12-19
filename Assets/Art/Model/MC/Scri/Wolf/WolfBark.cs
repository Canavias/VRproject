using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

public class WolfBark : MonoBehaviour
{
    public List<AudioClip> audioClips = new List<AudioClip>();
    private AudioSource _audioSource;

    private void Start()
    {
        _audioSource = GetComponent<AudioSource>();
    }

    public void BarkCheck()
    {
        int a = Random.Range(0, 50);
        if (a < audioClips.Count)
        {
            _audioSource.PlayOneShot(audioClips[a]);;
        }
    }
}

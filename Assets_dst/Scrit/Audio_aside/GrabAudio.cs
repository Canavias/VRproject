using System;
using System.Collections.Generic;
using NUnit.Framework;
using UnityEngine;

public class GrabAudio : MonoBehaviour
{
    public List<AudioClip> audioClips = new List<AudioClip>();
    private List<bool> audioPlayed = new List<bool>();
    private AudioSource _audioSource;

    private void Start()
    {
        _audioSource = GetComponent<AudioSource>();
        for (int i = 0; i < audioClips.Count; i++)
        {
            audioPlayed.Add(false);
        }
    }

    public void AudiosPlay(int num)
    {
        if (!audioPlayed[num])
        {
            _audioSource.PlayOneShot(audioClips[num]);
            audioPlayed[num] = true;
        }
    }
}

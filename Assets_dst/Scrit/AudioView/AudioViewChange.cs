using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;

public class AudioViewChange : MonoBehaviour
{
    public AudioSource audioSource;
    public List<Scri_AudioView> audioViews = new List<Scri_AudioView>();
    private int _currentIndex;

    public float reloadTime = 1f;
    private float _lastTime;

    private void Start()
    {
        _lastTime = Time.time;
        
        _currentIndex = 0;
        if (audioViews.Count == 0)
        {
            Debug.Log("AudioViewChange: No audio views found!");
        }
        audioSource.volume = audioViews[0].audioVolume;
        audioSource.clip = audioViews[0].audio;
        audioSource.Play();
        GetComponent<XRSimpleInteractable>().selectEntered.AddListener(x => ChangeAudio());
    }

    private void ChangeAudio()
    {
        if (Time.time - _lastTime > reloadTime)
        {
            _currentIndex = (_currentIndex + 1)% audioViews.Count;
            audioSource.volume = audioViews[_currentIndex].audioVolume;
            audioSource.clip = audioViews[_currentIndex].audio;
            audioSource.Play();
            _lastTime = Time.time;
        }
    }
}

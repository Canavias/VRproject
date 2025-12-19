using System.Collections.Generic;
using UnityEngine;

public class RoomEvent : MonoBehaviour
{
    private AudioSource _audioSource;
    public AudioSource musicSource;
    private Animator _animator;
    
    //public AudioClip audioClip;
    public GameObject animtionCollider;
    //public AudioClip creeperBoomClip;
    public List<AudioClip> audioClips = new List<AudioClip>();
    public ParticleSystem boom;
    public Animator mainCamera;
    private void Start()
    {
        _audioSource = GetComponent<AudioSource>();
        _animator = GetComponent<Animator>();
    }

    public void Finished()
    {
        mainCamera.enabled = true;
    }

    public void ChangeMusic()
    {
        musicSource.Stop();
        _audioSource.PlayOneShot(audioClips[3]);
    }

    public void StartFinished()
    {
        animtionCollider.SetActive(false);
        _animator.enabled = false;
    }

    public void CreeperBoom()
    {
        boom.Play();
    }

    public void PlayAudio(int index)
    {
        _audioSource.PlayOneShot(audioClips[index]);
    }
    
}

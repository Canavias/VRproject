using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class WorkAnimationChange : MonoBehaviour
{
    public List<AudioClip> audioClips = new List<AudioClip>();
    private AudioSource _audioSource;
    void Start()
    {
        _audioSource = GetComponent<AudioSource>();
    }

    public void PlayAudio(int index)
    {
        _audioSource.PlayOneShot(audioClips[index]);
    }

    public void FinshWork()
    {
        SceneManager.LoadScene(3);
    }
}

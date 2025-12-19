using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.Video;
using UnityEngine.XR.Interaction.Toolkit;

public class ProjectorChange : MonoBehaviour
{
    public GameObject projection;
    
    private Animator m_projectorAnimator;
    
    private VideoPlayer m_VideoPlayer;
    private Animator _videoAnimator;
    public GameObject videoObject;
    
    private bool projectionStyle = false;
    public float reloadTime = 2f;
    private float lastTime ;
    
    void Start()
    {
        m_projectorAnimator = projection.GetComponent<Animator>();
        
        m_VideoPlayer = videoObject.GetComponent<VideoPlayer>();
        _videoAnimator = videoObject.GetComponent<Animator>();
        
        lastTime = Time.time - 10;
        projection.SetActive(projectionStyle);
        videoObject.SetActive(projectionStyle);
        GetComponent<XRSimpleInteractable>().selectEntered.AddListener(x=>OpenProjector());
    }

    void OpenProjector()
    {
        if (Time.time - lastTime > reloadTime)
        {
            lastTime = Time.time;
            projectionStyle = !projectionStyle;
            projection.SetActive(projectionStyle);
            videoObject.SetActive(projectionStyle);
            if (projectionStyle)
            {
                m_VideoPlayer.Play();
                _videoAnimator.SetBool("Change", true);
                m_projectorAnimator.SetBool("Change",true);
            }
        }
    }
    
}

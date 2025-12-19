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
    
    private Animator m_VideoAni;
    private VideoPlayer m_VideoPlayer;
    public GameObject videoObject;
    
    private bool projectionStyle = false;
    public float reloadTime = 2f;
    private float lastTime ;
    
    void Start()
    {
        m_projectorAnimator = projection.GetComponent<Animator>();
        m_VideoAni = videoObject.GetComponent<Animator>();
        m_VideoPlayer = videoObject.GetComponent<VideoPlayer>();
        
        lastTime = Time.time;
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
                m_VideoAni.SetBool("Change",true);
                m_VideoPlayer.Play();
                m_projectorAnimator.SetBool("Change",true);
            }
        }
    }
    
}

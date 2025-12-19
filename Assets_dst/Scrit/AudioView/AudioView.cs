using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioView : MonoBehaviour
{
    private AudioSource _audioSource;
    [Header("采样数量")]
    public int m_NumSamples;
    private float[] m_Samples;
    [Header("圆环物体")]
    public List<Transform> m_Transforms;
    private bool first = true;
    [Header("最小强度")]
    public float min_Intensity;
    private List<Material> m_Materials = new List<Material>();
    private List<Vector3> start_Scale = new List<Vector3>();
    [Header("声音强度")]
    public float audio_Intensity;
    [Header("采样间隔")]
    public float duration;
    [Header("颜色强度")]
    public float color_Intensity = 100;
    private int currentNum = 0;
    private float startTime;
    void Start()
    {
        _audioSource = GetComponent<AudioSource>();
        m_Samples = new float[m_NumSamples];
        for (int i = 0; i < m_Transforms.Count; i++)
        {
            start_Scale.Add(m_Transforms[i].localScale);
            m_Materials.Add(m_Transforms[i].gameObject.GetComponent<Renderer>().material);
        }
        startTime = Time.time - duration;
    }

    // Update is called once per frame
    void Update()
    {

        if (Time.time - startTime >= duration)
        {
            _audioSource.GetOutputData(m_Samples, 0);
            float instensity =Mathf.Abs(m_Samples[m_NumSamples-1]);
            if (instensity < min_Intensity)
            {
                Vector3 temScale = start_Scale[currentNum];
                m_Transforms[currentNum].transform.localScale = new Vector3(temScale.x, temScale.y, temScale.z);
                m_Materials[currentNum].SetFloat("_Intensity",0);
            }
            else
            {
                Vector3 temScale = m_Transforms[currentNum].localScale;
                m_Transforms[currentNum].transform.localScale = new Vector3(temScale.x, temScale.y, instensity * audio_Intensity);
                float temIntensity = Mathf.Clamp(instensity*color_Intensity,0,1);
                m_Materials[currentNum].SetFloat("_Intensity",temIntensity);
            }
            currentNum = (currentNum + 1) % m_Transforms.Count;
            startTime = Time.time;
        }
    }
}

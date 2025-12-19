using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class StartChange : MonoBehaviour
{
    [Header("后处理材质")]
    public Material material;
    [Header("渲染距离")]
    public float renderDepth;
    [Header("渲染范围")]
    public float renderPower;
    [Header("渲染边缘强度")]
    public float renderEdge;
    [Header("背景颜色")]
    public Color color;
    // Start is called before the first frame update
    void Start()
    {
        if(material == null || material.shader == null)
        {
            enabled = false;
            return;
        }
    }
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        material.SetFloat("_Distance", renderDepth);
        material.SetFloat("_DistancePower", renderPower);
        material.SetFloat("_DistanceEdge", renderEdge);
        material.SetColor("_BaseColor", color);
        Graphics.Blit(source, destination, material);
        RenderTexture.ReleaseTemporary(source);
    }
}

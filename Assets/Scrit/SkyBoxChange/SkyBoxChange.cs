using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;

public class SkyBoxChange : MonoBehaviour
{
    public Material skyBoxMaterial;
    public List<SkyBox> skyBoxDatas = new List<SkyBox>();
    private Animator _animator;
    [Range(0,1)]
    public float skyBoxChangeControl;
    [Header("改变文字")]
    public TextMesh textMesh;

    private int _currentIndex = 0;
    void Start()
    {
        if (skyBoxDatas.Count <= 2)
        {
            Debug.Log("天空盒挂载数量小于最小值(2)");
            return;
        }
        
        skyBoxMaterial.SetTexture("_Cube1", skyBoxDatas[0].cubemap);
        skyBoxMaterial.SetTexture("_Cube2", skyBoxDatas[1].cubemap);
        skyBoxChangeControl = -1.0f;
        
        _animator = GetComponent<Animator>();
        GetComponent<XRSimpleInteractable>().selectEntered.AddListener(x => ChangeSkyBox());
    }

    private void Update()
    {
        skyBoxMaterial.SetFloat("_CUbeChange",skyBoxChangeControl);
    }

    public void ChangeSkyBox()
    {
        if (!_animator.GetBool("ChangeSkyBox"))
        {
            _animator.SetBool("ChangeSkyBox",true);
            textMesh.text = "Now Style:Changing...";
        }
    }

    public void FinishChangeSkyBox()
    {
        _currentIndex = (_currentIndex + 1) % skyBoxDatas.Count;
        skyBoxMaterial.SetTexture("_Cube1", skyBoxDatas[_currentIndex].cubemap);
        skyBoxMaterial.SetFloat("_EmissionIntensity",skyBoxDatas[_currentIndex].emission);
        textMesh.text ="Now Style:" + skyBoxDatas[_currentIndex].skyboxName;
        
        skyBoxMaterial.SetTexture("_Cube2", skyBoxDatas[(_currentIndex+1)%skyBoxDatas.Count].cubemap);
        _animator.SetBool("ChangeSkyBox",false);
        
    }
    
}

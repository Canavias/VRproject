// VRButtonInteractor.cs - 按钮基础交互
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.XR.Interaction.Toolkit;

[RequireComponent(typeof(XRSimpleInteractable))]
public class VRButtonInteractor : MonoBehaviour
{
    [Header("按钮事件")]
    public UnityEvent onClick;

    [Header("视觉效果")]
    public Material normalMaterial;
    public Material hoverMaterial;
    public Material pressedMaterial;

    private Renderer buttonRenderer;
    private XRSimpleInteractable simpleInteractable;

    void Start()
    {
        buttonRenderer = GetComponent<Renderer>();
        simpleInteractable = GetComponent<XRSimpleInteractable>();

        // 绑定XR事件
        if (simpleInteractable != null)
        {
            simpleInteractable.selectEntered.AddListener(OnButtonPressed);
            simpleInteractable.hoverEntered.AddListener(OnHoverEnter);
            simpleInteractable.hoverExited.AddListener(OnHoverExit);
        }

        // 设置初始材质
        if (normalMaterial != null)
            buttonRenderer.material = normalMaterial;
    }

    void OnButtonPressed(SelectEnterEventArgs args)
    {
        Debug.Log($"按钮被按下: {gameObject.name}");

        // 视觉反馈
        if (pressedMaterial != null)
            buttonRenderer.material = pressedMaterial;

        // 触发事件
        onClick?.Invoke();

        // 播放音效
        AudioSource audioSource = GetComponent<AudioSource>();
        if (audioSource != null && audioSource.clip != null)
        {
            audioSource.Play();
        }

        // 0.5秒后恢复
        Invoke("ResetButton", 0.5f);
    }

    void OnHoverEnter(HoverEnterEventArgs args)
    {
        if (hoverMaterial != null)
            buttonRenderer.material = hoverMaterial;
    }

    void OnHoverExit(HoverExitEventArgs args)
    {
        if (normalMaterial != null)
            buttonRenderer.material = normalMaterial;
    }

    void ResetButton()
    {
        if (normalMaterial != null)
            buttonRenderer.material = normalMaterial;
    }
}
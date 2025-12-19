// VRButton.cs - 专门处理VR按钮交互
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.XR.Interaction.Toolkit;

[RequireComponent(typeof(XRSimpleInteractable))]
public class VRButton : MonoBehaviour
{
    [Header("按钮事件")]
    public UnityEvent onPressed;

    [Header("视觉反馈")]
    public GameObject buttonVisual;
    public Vector3 pressedPosition = new Vector3(0, -0.01f, 0);
    public Vector3 releasedPosition = Vector3.zero;

    private XRSimpleInteractable interactable;
    private Vector3 originalPosition;

    void Start()
    {
        interactable = GetComponent<XRSimpleInteractable>();
        interactable.selectEntered.AddListener(OnButtonPressed);

        if (buttonVisual != null)
            originalPosition = buttonVisual.transform.localPosition;
    }

    void OnButtonPressed(SelectEnterEventArgs args)
    {
        // 按下动画
        if (buttonVisual != null)
            buttonVisual.transform.localPosition = originalPosition + pressedPosition;

        // 触发事件
        onPressed?.Invoke();

        // 延迟恢复
        Invoke("ResetButton", 0.2f);
    }

    void ResetButton()
    {
        if (buttonVisual != null)
            buttonVisual.transform.localPosition = originalPosition + releasedPosition;
    }
}
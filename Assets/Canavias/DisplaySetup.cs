// DisplaySetup.cs
using UnityEngine;
using TMPro;

public class DisplaySetup : MonoBehaviour
{
    [Header("显示屏3D模型")]
    public Transform screenModel;  // 你的显示屏3D物体

    [Header("Canvas设置")]
    public Vector2 canvasSize = new Vector2(800, 200);
    public float canvasOffsetZ = 0.01f;  // 稍微突出显示屏表面

    private Canvas worldCanvas;
    private TextMeshProUGUI priceText;

    void Start()
    {
        CreateCanvasOnScreen();

        // 连接购物车管理器
        ShoppingCartManager cartManager = FindObjectOfType<ShoppingCartManager>();
        if (cartManager != null && priceText != null)
        {
            // 需要修改ShoppingCartManager来支持TextMeshProUGUI
            // 或者这里做适配
        }
    }

    void CreateCanvasOnScreen()
    {
        if (screenModel == null)
        {
            Debug.LogError("请指定显示屏模型");
            return;
        }

        // 1. 创建Canvas
        GameObject canvasObj = new GameObject("ScreenCanvas");
        canvasObj.transform.SetParent(screenModel);

        // 2. 设置Canvas为World Space
        worldCanvas = canvasObj.AddComponent<Canvas>();
        worldCanvas.renderMode = RenderMode.WorldSpace;

        // 3. 设置Canvas尺寸和位置
        RectTransform canvasRect = canvasObj.GetComponent<RectTransform>();
        canvasRect.sizeDelta = canvasSize;

        // 定位到显示屏表面
        canvasRect.localPosition = new Vector3(0, 0, canvasOffsetZ);
        canvasRect.localRotation = Quaternion.identity;
        canvasRect.localScale = new Vector3(0.001f, 0.001f, 0.001f);

        // 4. 添加Text
        GameObject textObj = new GameObject("PriceText");
        textObj.transform.SetParent(canvasObj.transform);

        RectTransform textRect = textObj.AddComponent<RectTransform>();
        textRect.sizeDelta = new Vector2(600, 150);
        textRect.localPosition = Vector3.zero;
        textRect.localScale = Vector3.one;

        // 5. 添加TextMeshProUGUI组件
        priceText = textObj.AddComponent<TextMeshProUGUI>();
        priceText.text = "总计: $0.00";
        priceText.fontSize = 48;
        priceText.alignment = TextAlignmentOptions.Center;
        priceText.color = Color.green;

    }

}
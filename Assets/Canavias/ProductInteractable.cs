using UnityEngine;
using UnityEngine.Events;
using UnityEngine.XR.Interaction.Toolkit;

public class ProductInteractable : XRGrabInteractable // ⭐ 继承自XRGrabInteractable
{
    [Header("商品信息")]
    public string productName = "商品名称";
    public float price = 9.99f;
    [TextArea(3, 10)]
    public string description = "商品描述";
    public GameObject productPrefab; // 用于补货的预制体

    [Header("事件")]
    public UnityEvent onGrabbed;
    public UnityEvent onPlacedInBasket;

    // 缓存原始状态用于补货
    private Vector3 originalPosition;
    private Quaternion originalRotation;
    private Transform originalParent;
    private bool isInBasket = false;

    protected override void Awake()
    {
        base.Awake();
        SaveOriginalState();

        // 监听抓取事件
        selectEntered.AddListener(OnGrabbedEvent);
    }

    void SaveOriginalState()
    {
        originalParent = transform.parent;
        originalPosition = transform.position;
        originalRotation = transform.rotation;
    }

    void OnGrabbedEvent(SelectEnterEventArgs args)
    {
        onGrabbed?.Invoke();

        // 显示商品信息UI
        ShowProductUI();
    }

    void ShowProductUI()
    {
        ProductUIManager uiManager = FindObjectOfType<ProductUIManager>();
        if (uiManager != null)
        {
            ProductData data = ScriptableObject.CreateInstance<ProductData>();
            data.productName = productName;
            data.price = price;
            data.description = description;
            uiManager.ShowProductInfo(data);
        }
    }

    // 被篮子调用
    public void OnPlacedInBasket(Basket basket)
    {
        if (isInBasket) return;
        isInBasket = true;

        // 1. 隐藏UI
        ProductUIManager uiManager = FindObjectOfType<ProductUIManager>();
        if (uiManager != null)
            uiManager.HideProductInfo();

        // 2. 瞬移到高处（隐藏）
        transform.position = new Vector3(0, 1000, 0);

        // 3. 禁用交互
        enabled = false;
        if (TryGetComponent<Collider>(out var collider))
            collider.enabled = false;

        // 4. 原位置补货
        RestockProduct();

        // 5. 触发事件
        onPlacedInBasket?.Invoke();

        // 6. 延迟销毁（给结算时间）
        Destroy(gameObject, 5f);
    }

    void RestockProduct()
    {
        if (productPrefab != null)
        {
            GameObject newProduct = Instantiate(
                productPrefab,
                originalPosition,
                originalRotation,
                originalParent
            );

            Debug.Log($"🔄 补货: {productName}");
        }
    }
}
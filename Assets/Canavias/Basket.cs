using UnityEngine;
using System.Collections.Generic;
using UnityEngine.Events;

public class Basket : MonoBehaviour
{
    [Header("篮子设置")]
    public Transform dropZone; // 物品放入区域（空对象）
    public Vector3 dropZoneSize = new Vector3(0.5f, 0.5f, 0.5f);
    public float checkInterval = 0.2f; // 更频繁检测

    [Header("自动购买设置")]
    public bool autoPurchase = true; // 放入即购买

    [Header("事件")]
    public UnityEvent<ProductInteractable> onProductAdded;
    public UnityEvent<float> onTotalPriceUpdated;

    private List<ProductInteractable> productsInBasket = new List<ProductInteractable>();
    private ShoppingCartManager cartManager;
    private float totalPrice = 0f;

    void Start()
    {
        cartManager = FindObjectOfType<ShoppingCartManager>();
        if (cartManager == null)
            Debug.LogWarning("未找到ShoppingCartManager");

        // 开始检测篮子内的物品
        InvokeRepeating("CheckBasketContents", 0.5f, checkInterval);
    }

    void CheckBasketContents()
    {
        if (dropZone == null) return;

        Collider[] colliders = Physics.OverlapBox(
            dropZone.position,
            dropZoneSize / 2,
            dropZone.rotation
        );

        foreach (Collider col in colliders)
        {
            ProductInteractable product = col.GetComponent<ProductInteractable>();
            if (product != null && !productsInBasket.Contains(product))
            {
                AddProductToBasket(product);
            }
        }
    }

    void AddProductToBasket(ProductInteractable product)
    {
        // 添加到列表
        productsInBasket.Add(product);

        // 更新总价
        totalPrice += product.price;

        // 通知购物车管理器
        if (cartManager != null)
            cartManager.AddToCart(product.price);

        // 触发事件
        onProductAdded?.Invoke(product);
        onTotalPriceUpdated?.Invoke(totalPrice);

        // 执行放入篮子后的操作
        product.OnPlacedInBasket(this);

        Debug.Log($"✅ 商品放入篮子: {product.productName}, 价格: ${product.price:F2}");
        Debug.Log($"💰 当前总计: ${totalPrice:F2}");
    }

    // 清空篮子（例如购买后）
    public void ClearBasket()
    {
        foreach (var product in productsInBasket)
        {
            // 销毁或隐藏商品
            Destroy(product.gameObject);
        }

        productsInBasket.Clear();
        totalPrice = 0f;

        if (cartManager != null)
            cartManager.UpdateTotalPrice(0f);

        Debug.Log("🧺 篮子已清空");
    }

    // 获取当前总价
    public float GetTotalPrice()
    {
        return totalPrice;
    }

    void OnDrawGizmosSelected()
    {
        if (dropZone != null)
        {
            Gizmos.color = new Color(0, 1, 0, 0.3f);
            Gizmos.matrix = Matrix4x4.TRS(dropZone.position, dropZone.rotation, dropZoneSize);
            Gizmos.DrawCube(Vector3.zero, Vector3.one);
        }
    }
}
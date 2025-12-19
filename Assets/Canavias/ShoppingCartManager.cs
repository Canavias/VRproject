using UnityEngine;
using TMPro;
using UnityEngine.Events;

public class ShoppingCartManager : MonoBehaviour
{
    [Header("显示屏设置")]
    public TextMeshProUGUI totalPriceText;
    public string displayFormat = "总计: ${0:F2}";

    [Header("事件")]
    public UnityEvent<float> onPriceUpdated;

    private float totalPrice = 0f;

    void Start()
    {
        UpdateDisplay();
    }

    // 被篮子调用
    public void AddToCart(float price)
    {
        totalPrice += price;
        UpdateDisplay();

        Debug.Log($"💰 添加到购物车: +${price:F2}, 总计: ${totalPrice:F2}");
    }

    public void UpdateTotalPrice(float price)
    {
        totalPrice = price;
        UpdateDisplay();
    }

    void UpdateDisplay()
    {
        if (totalPriceText != null)
        {
            totalPriceText.text = string.Format(displayFormat, totalPrice);
        }
        onPriceUpdated?.Invoke(totalPrice);
    }

    // 结算（可手动调用）
    public void Checkout()
    {
        if (totalPrice <= 0)
        {
            Debug.Log("购物车为空");
            return;
        }

        Debug.Log($"✅ 结算完成: ${totalPrice:F2}");
        // 这里可以添加支付逻辑、音效等

        // 清空购物车
        totalPrice = 0f;
        UpdateDisplay();

        // 清空篮子
        Basket basket = FindObjectOfType<Basket>();
        if (basket != null)
            basket.ClearBasket();
    }
}
using UnityEngine;
using TMPro;
using UnityEngine.XR.Interaction.Toolkit;
using UnityEngine.Events;

public class ProductUIManager : MonoBehaviour
{
    [Header("UI References")]
    public GameObject productUIPanel;

    [Header("UI Components")]
    public TMP_Text productNameText;
    public TMP_Text priceText;
    public TMP_Text descriptionText;

    [Header("购物车连接")]
    public ShoppingCartManager shoppingCart;

    private ProductData currentProduct;

    void Start()
    {
        if (productUIPanel != null)
            productUIPanel.SetActive(false);
    }

    // ⭐ 修改方法：移除playerHand参数 ⭐
    public void ShowProductInfo(ProductData productData)
    {
        currentProduct = productData;

        if (productNameText != null)
            productNameText.text = productData.productName;
        if (priceText != null)
            priceText.text = $"${productData.price:F2}";
        if (descriptionText != null)
            descriptionText.text = productData.description;

        // 定位UI到玩家面前（不需要playerHand）
        PositionUIInFrontOfPlayer();

        if (productUIPanel != null)
            productUIPanel.SetActive(true);
    }

    void PositionUIInFrontOfPlayer()
    {
        if (Camera.main != null && productUIPanel != null)
        {
            Transform cam = Camera.main.transform;
            Vector3 uiPos = cam.position + cam.forward * 1.5f;
            uiPos.y = cam.position.y - 0.3f;

            productUIPanel.transform.position = uiPos;
            productUIPanel.transform.LookAt(cam);
            productUIPanel.transform.Rotate(0, 180, 0);
        }
    }

    public void HideProductInfo()
    {
        if (productUIPanel != null)
            productUIPanel.SetActive(false);
        currentProduct = null;
    }

    public void OnUIPurchaseClicked()
    {
        if (currentProduct != null)
        {
            Debug.Log($"查看商品: {currentProduct.productName}");
            // 只是记录，实际购买是通过放入篮子
        }
    }
}
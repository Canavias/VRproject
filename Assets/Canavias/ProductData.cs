using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "NewProductData", menuName = "VR Shop/Product Data")]
public class ProductData : ScriptableObject
{
    public string productName;
    public float price;
    [TextArea(3, 10)]
    public string description;
    public Sprite productImage;
    public GameObject productPrefab;
}
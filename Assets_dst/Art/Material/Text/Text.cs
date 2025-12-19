using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Text : MonoBehaviour
{
    private TextMesh _textMesh;
    private int[] _nowTime = new int[3];
    private int[] _temArry = new int[2];

    private void Start()
    {
        _textMesh = GetComponent<TextMesh>();
    } 

    void FixedUpdate()
    {
        _nowTime[0] = DateTime.Now.Hour;
        _nowTime[1] = DateTime.Now.Minute;
        _nowTime[2] = DateTime.Now.Second;
        string temText = "";
        for (int i = 0; i < 3; i++)
        {
            for (int j = 0; j < 2; j++)
            {
                _temArry[j] = _nowTime[i] % 10;
                _nowTime[i] /= 10;
            }

            for(int j = 1; j>=0;j--)
            {
                temText += _temArry[j].ToString(); 
                if (_temArry[j] == 1)
                {
                    temText += " "; 
                }
            }

            if (i != 2)
            {
                temText += ":";
            }
        }
        _textMesh.text = temText;
    }
}

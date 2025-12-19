using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem.Controls;

public class Wolf : MonoBehaviour
{
    public GameObject playerPosition;
    // Update is called once per frame
    void Update()
    {
        transform.LookAt(playerPosition.transform.position);
        float angle = transform.localRotation.eulerAngles.z;
        if (angle < 0)
        {
            angle = angle + 360.0f;
        }

        if (angle < 180)
        {
            angle = Mathf.Clamp(angle, 0, 60);   
        }
        else if (angle >= 180)
        {
            angle = Mathf.Clamp(angle, 300, 360);
        }
        transform.localRotation = Quaternion.Euler(18,0,angle);
    }
}

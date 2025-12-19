using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.Content.Interaction;

public class BaShou : MonoBehaviour
{
    private XRKnob _xrKnob;
    void Start()
    {
        _xrKnob = GetComponent<XRKnob>();
    }

    // Update is called once per frame
    private void FixedUpdate()
    {
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MyCameraChange : MonoBehaviour
{
    public void ChangeCameraFlags()
    {
        Camera.main.clearFlags = CameraClearFlags.SolidColor;
    }
}

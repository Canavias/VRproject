using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem.Controls;

public class FollowControl : MonoBehaviour
{
    public transform arrow;//方向箭头
    public List<Transform> followTargets = new List<Transform>();
    private int _currentTarget = 0;
    [Header("箭头属性")]
    public Vector2 arrowLengthControl;
    public float arrowLengthToScale;
    
    

    // Update is called once per frame
    void Update()
    {
        Vector3 playerPos = transform.position;
        arrow.transform.rotation = Quaternion.LookRotation(arrow.transform.position - playerPos);
        for (int i = 0; i < followTargets.Count; i++)
        {
            if (followTargets[i].position.z > playerPos.z)
            {
                _currentTarget = i;
                break;
            }
            else if (i == followTargets.Count - 1)
            {
                _currentTarget = i+1;
            }
        }
        float distance = Mathf.Clamp((followTargets[_currentTarget].position - playerPos).magnitude,
            arrowLengthControl.x,arrowLengthControl.y) * arrowLengthToScale;
        arrow.transform.localScale = new Vector3(arrow.transform.localScale.x, arrow.transform.localScale.y, distance);
    }
}


using System.Collections.Generic;
using UnityEngine;

public class Arrow : MonoBehaviour
{
    public List<Transform> targets = new List<Transform>();
    public Vector2 arrowControl = new Vector2(0.5f, 2.0f);
    public float distanceInfluence = 1.0f;
    private int _currentIndex = 0;
    public float arrowOffset = 0.5f;
    public float arrowChangeSpeed = 1.0f;
    
    // Update is called once per frame
    void Update()
    {
        for (int i = 0; i < targets.Count; i++)
        {
            if (targets[i].position.z < transform.position.z-arrowControl.x)
            {
                _currentIndex = i;
                break;
            }
        }
        Vector3 targetPos = targets[_currentIndex].position - transform.position;
        
        Quaternion currentRotation = transform.rotation;
        Quaternion targetRotation = Quaternion.LookRotation(targetPos.normalized, Vector3.up) * 
                                   Quaternion.Euler(0,180,0);
        transform.rotation = Quaternion.Lerp(currentRotation,targetRotation,arrowChangeSpeed * Time.deltaTime);
        
        float target = Mathf.Clamp(targetPos.magnitude, arrowControl.x, arrowControl.y);
        transform.localScale =new Vector3(transform.localScale.x,transform.localScale.y, 0.4f * target * distanceInfluence) ;
        
        Vector3 cameraPos = Camera.main.transform.position;
        Vector3 cameraForward = targetPos;
        cameraForward.y = 0;
        cameraForward.Normalize();
        transform.position =new Vector3(cameraPos.x,transform.position.y,cameraPos.z) + cameraForward * arrowOffset;
    }
}

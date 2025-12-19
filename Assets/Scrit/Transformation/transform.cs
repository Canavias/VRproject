using Unity.XR.CoreUtils;
using UnityEngine;
using UnityEngine.SceneManagement;

public class transform : MonoBehaviour 
{

    public XROrigin xrOrigin;

    private void FixedPlayerView()
    {
        xrOrigin.enabled = true;
        SceneManager.LoadScene(1);
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            xrOrigin.enabled = false;
            Invoke("FixedPlayerView",1.5f);
        }
    }
}

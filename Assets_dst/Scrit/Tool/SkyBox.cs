using UnityEngine;
[CreateAssetMenu(menuName = "ScriptableObjects/SkyBox")]
public class SkyBox : ScriptableObject
{
        public Cubemap cubemap;
        public string skyboxName;
        public float emission;
}

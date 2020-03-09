using UnityEngine;

[ExecuteInEditMode]
public class XRayReplacement : MonoBehaviour
{
    [SerializeField] private Shader xRayShader = null;

    void OnEnable()
    {
        GetComponent<Camera>().SetReplacementShader(xRayShader, "XRay");
    }
}
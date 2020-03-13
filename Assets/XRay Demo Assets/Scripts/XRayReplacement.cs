using UnityEngine;

[ExecuteInEditMode]
public class XRayReplacement : MonoBehaviour
{
    [SerializeField] private Shader xRayShader = null;

    private void OnEnable()
    {
        GetComponent<Camera>().SetReplacementShader(xRayShader, "XRay");
    }

    private void OnDisable()
    {
        GetComponent<Camera>().ResetReplacementShader();
    }
}
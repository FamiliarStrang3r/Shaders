using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class SetReplacementShader : MonoBehaviour
{
    [SerializeField] private Shader replacementShader = null;
    [SerializeField] private string replacementTag = string.Empty;
    [SerializeField, Range(0, 50)] private int value = 10;

    private void OnEnable()
    {
        if (replacementShader) GetComponent<Camera>().SetReplacementShader(replacementShader, replacementTag);
        //passing empty string as second parameter this will replace each object shader with
        //the firs subshader defined in the replacement shader
    }

    private void OnDisable()
    {
        GetComponent<Camera>().ResetReplacementShader();
    }

    private void OnValidate()
    {
        Shader.SetGlobalFloat("_DepthValue", 1f / value);
    }
}

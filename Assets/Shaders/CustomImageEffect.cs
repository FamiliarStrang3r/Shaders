using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class CustomImageEffect : MonoBehaviour
{
    [SerializeField] private bool drawEffect = false;
    [SerializeField] private Material material = null;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material && drawEffect)
            Graphics.Blit(source, destination, material);
        else
            Graphics.Blit(source, destination);
    }
}

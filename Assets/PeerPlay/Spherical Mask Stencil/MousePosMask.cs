using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MousePosMask : MonoBehaviour
{
    [SerializeField, Range(0, 5)] private float radius = 1;
    [SerializeField, Range(-1, 1)] private float softness = 1;
    private Camera cam = null;

    private void Start()
    {
        cam = Camera.main;
    }

    private void FixedUpdate()
    {
        Ray ray = cam.ScreenPointToRay(Input.mousePosition);

        if (Physics.Raycast(ray, out var hit))
        {
            Shader.SetGlobalVector("_Position", hit.point);
        }
    }

    private void OnValidate()
    {
        Shader.SetGlobalFloat("_Radius", radius);
        Shader.SetGlobalFloat("_Softness", softness);
    }
}

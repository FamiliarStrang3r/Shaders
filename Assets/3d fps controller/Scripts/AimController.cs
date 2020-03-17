using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AimController : MonoBehaviour
{
    [SerializeField, Range(0, 1)] private float smooth = 1;
    [SerializeField] private Vector3 aim = Vector3.zero;
    [SerializeField] private Vector3 normal = Vector3.zero;

    private Vector3 pos = Vector3.zero;
    private bool isAiming = false;

    private void Start()
    {
        pos = isAiming ? aim : normal;
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            isAiming = !isAiming;
            pos = isAiming ? aim : normal;
        }
    }

    private void FixedUpdate()
    {
        transform.localPosition = Vector3.Lerp(transform.localPosition, pos, smooth);
    }

    private void ChangeShader()
    {
        Shader.SetGlobalFloat("_Percent", isAiming ? 1 : 0);
    }
}

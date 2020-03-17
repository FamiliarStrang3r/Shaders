using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SightSway : MonoBehaviour
{
    [SerializeField] private Vector3 intensity = Vector3.zero;
    [SerializeField, Range(0, 1)] private float smooth = 1;

    private InvisibleJoystick invisibleJoystick = null;

    private Vector3 smoothVelocity = Vector3.zero;
    private Vector3 r = Vector3.zero;

    private float horizontal = 0;
    private float vertical = 0;

    private void Start()
    {
        invisibleJoystick = FindObjectOfType<InvisibleJoystick>();
    }

    private void FixedUpdate()
    {
        float h = invisibleJoystick.Horizontal;
        float v = invisibleJoystick.Vertical;

        horizontal = h != 0 ? Mathf.Sign(h) : 0;
        vertical = v != 0 ? Mathf.Sign(v) : 0;

        Vector3 input = Vector3.Scale(new Vector3(vertical, -horizontal, -horizontal), intensity);
        r = Vector3.SmoothDamp(r, input, ref smoothVelocity, smooth);
        transform.localRotation = Quaternion.Euler(r);
    }
}

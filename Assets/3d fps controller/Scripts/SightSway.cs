using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SightSway : MonoBehaviour
{
    [SerializeField] private Vector3 intensity = Vector3.zero;
    [SerializeField, Range(0, 1)] private float smooth = 1;

    private MoveJoystick moveJoystick = null;
    private InvisibleJoystick invisibleJoystick = null;

    private Vector3 smoothVelocity = Vector3.zero;
    private Vector3 r = Vector3.zero;

    private float horizontal = 0;
    private float vertical = 0;

    private void Start()
    {
        moveJoystick = MoveJoystick.Instance;
        invisibleJoystick = FindObjectOfType<InvisibleJoystick>();
    }

    private void FixedUpdate()
    {
        float h = Mathf.Clamp(invisibleJoystick.Horizontal + moveJoystick.Horizontal, -1, 1);
        float v = Mathf.Clamp(invisibleJoystick.Vertical + moveJoystick.Vertical, -1 , 1);

        horizontal = h != 0 ? Mathf.Sign(h) : 0;
        vertical = v != 0 ? Mathf.Sign(v) : 0;

        Vector3 input = Vector3.Scale(new Vector3(vertical, -horizontal, -horizontal), intensity);
        r = Vector3.SmoothDamp(r, input, ref smoothVelocity, smooth);
        transform.localRotation = Quaternion.Euler(r);
    }
}

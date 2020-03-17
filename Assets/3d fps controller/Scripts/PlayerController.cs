using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    [SerializeField] private float speed = 10;

    private CharacterController cc = null;
    private MoveJoystick moveJoystick = null;

    [SerializeField] private Transform head = null;
    [SerializeField] private Vector2 minMax = Vector2.zero;
    [SerializeField, Range(0, 1)] private float smooth = 1;
    [SerializeField, Range(0, 2)] private float sens = 1;

    private InvisibleJoystick invisibleJoystick = null;

    private float yaw = 0;
    private float pitch = 0;

    private void Start()
    {
        cc = GetComponent<CharacterController>();
        moveJoystick = MoveJoystick.Instance;
        invisibleJoystick = FindObjectOfType<InvisibleJoystick>();
    }

    private void Update()
    {
        HandlePosition();
        HandleRotation();
    }

    private void HandlePosition()
    {
        var move = transform.right * moveJoystick.Horizontal + transform.forward * moveJoystick.Vertical;
        if (move.magnitude > 1) move.Normalize();
        cc.Move(move * speed * Time.deltaTime);
    }

    private void HandleRotation()
    {
        if (invisibleJoystick.HasInput) CalculateRotation();

        transform.rotation = Quaternion.Slerp(transform.rotation, Quaternion.AngleAxis(yaw, Vector3.up), smooth);
        head.localRotation = Quaternion.Slerp(head.localRotation, Quaternion.AngleAxis(-pitch, Vector3.right), smooth);
    }

    private void CalculateRotation()
    {
        yaw += invisibleJoystick.Horizontal * sens;
        yaw %= 360;
        pitch += invisibleJoystick.Vertical * sens;

        pitch = Mathf.Clamp(pitch, minMax.x, minMax.y);
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    [SerializeField] private float speed = 10;

    private CharacterController cc = null;
    private MoveJoystick js = null;

    private void Start()
    {
        cc = GetComponent<CharacterController>();
        js = MoveJoystick.Instance;
    }

    private void Update()
    {
        Move();
    }

    private void Move()
    {
        var move = transform.right * js.Horizontal + transform.forward * js.Vertical;

        if (move.magnitude > 1) move.Normalize();

        cc.Move(move * speed * Time.deltaTime);
    }
}

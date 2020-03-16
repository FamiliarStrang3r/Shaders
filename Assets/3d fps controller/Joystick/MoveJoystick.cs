using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveJoystick : JoystickController
{
    public static MoveJoystick Instance { get; private set; }
    private void InitializeSingleton()
    {
        if (Instance == null)
            Instance = this;
        else if (Instance != this)
            Destroy(this);
    }

    protected override void Awake() => InitializeSingleton();

    public override float Horizontal => Direction.x != 0 ? Direction.x : Input.GetAxisRaw("Horizontal");
    public override float Vertical => Direction.y != 0 ? Direction.y : Input.GetAxisRaw("Vertical");
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SomebodyController : MonoBehaviour
{
    [SerializeField] private LayerMask groundMask = 0;
    [SerializeField, Range(0, 1)] private float brushStrength = 1;
    [SerializeField, Range(0, 10)] private int brushSize = 1;

    private SnowPlane snowPlane = null;
    private Rigidbody rb = null;

    private void Start()
    {
        //groundMask = LayerMask.GetMask("Ground");
        snowPlane = FindObjectOfType<SnowPlane>();

        rb = GetComponent<Rigidbody>();
    }

    private void FixedUpdate()
    {
        Ray ray = new Ray(transform.position, Vector3.down);
        //Debug.DrawRay(ray.origin, ray.direction, Color.red);
        if (Physics.Raycast(ray, out var hit, 1, groundMask))
        {
            snowPlane.Draw(hit.textureCoord, brushStrength, brushSize);
        }

        HandleInput();
    }

    private void HandleInput()
    {
        Vector3 input = new Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxisRaw("Vertical"));

        Vector3 velocity = input.normalized * 3;
        velocity.y = rb.velocity.y;

        rb.velocity = velocity;
    }
}

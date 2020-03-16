using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SightSway : MonoBehaviour
{
    [SerializeField] private Vector3 intensity = Vector3.zero;
    [SerializeField, Range(0, 1)] private float smooth = 1;

    private Vector3 smoothVelocity = Vector3.zero;
    private Vector3 r = Vector3.zero;

    public float h;
    public float v;

    private void FixedUpdate()
    {
        //float h = Input.GetAxis("Mouse X");
        //float v = Input.GetAxis("Mouse Y");

        //Quaternion y = Quaternion.AngleAxis(h * intensity.x, Vector3.up);
        //Quaternion x = Quaternion.AngleAxis(v * intensity.y, Vector3.left);
        //transform.rotation = Quaternion.Lerp(transform.rotation, y * x, smooth);

        //norm vrode
        Vector3 input = Vector3.Scale(new Vector3(v, -h, h), intensity);
        r = Vector3.SmoothDamp(r, input, ref smoothVelocity, smooth);
        transform.localRotation = Quaternion.Euler(r);
    }
}

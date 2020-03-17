using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class InvisibleJoystick : MonoBehaviour, IPointerDownHandler, IPointerUpHandler
{
    private Vector3 clickedPosition = Vector3.zero;
    private Vector3 draggingPosition = Vector3.zero;

    public bool HasInput { get; private set; }
    public float Horizontal { get; private set; }
    public float Vertical { get; private set; }

    public void OnPointerDown(PointerEventData eventData)
    {
        HasInput = true;
        clickedPosition = Input.mousePosition;
    }

    public void OnPointerUp(PointerEventData eventData)
    {
        HasInput = false;
    }

    private void Update()
    {
        if (HasInput)
        {
            draggingPosition = Input.mousePosition;

            Vector3 diff = clickedPosition - draggingPosition;
            clickedPosition = draggingPosition;

            Horizontal = diff.x;
            Vertical = diff.y;
        }
    }
}

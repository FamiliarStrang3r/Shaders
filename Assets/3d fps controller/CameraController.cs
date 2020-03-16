using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class CameraController : MonoBehaviour, IPointerDownHandler, IPointerUpHandler
{
    [SerializeField] private Transform player = null;
    [SerializeField] private Transform hands = null;
    [SerializeField] private Vector2 minMax = Vector2.zero;
    [SerializeField, Range(0, 1)] private float smooth = 1;
    [SerializeField, Range(0, 2)] private float sens = 1;

    private float yaw = 0;
    private float pitch = 0;

    private bool isDragging = false;
    private Vector3 clickedPosition = Vector3.zero;
    private Vector3 draggingPosition = Vector3.zero;

    public void OnPointerDown(PointerEventData eventData)
    {
        isDragging = true;
        clickedPosition = Input.mousePosition;
    }

    public void OnPointerUp(PointerEventData eventData)
    {
        isDragging = false;
    }

    private void Update()
    {
        if (isDragging)
        {
            draggingPosition = Input.mousePosition;

            Vector3 diff = clickedPosition - draggingPosition;
            clickedPosition = draggingPosition;

            yaw -= diff.x * sens;
            yaw %= 360;
            pitch -= diff.y * sens;

            pitch = Mathf.Clamp(pitch, minMax.x, minMax.y);
        }

        player.rotation = Quaternion.Slerp(player.rotation, Quaternion.AngleAxis(yaw, Vector3.up), smooth);
        hands.localRotation = Quaternion.Slerp(hands.localRotation, Quaternion.AngleAxis(-pitch, Vector3.right), smooth);
    }
}

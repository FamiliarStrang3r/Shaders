using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

[System.Serializable]
public class SmoothTransition
{
    public float duration = 1;
    public AnimationCurve curve = null;
}

public abstract class JoystickController : MonoBehaviour, 
                                           IPointerDownHandler, IPointerUpHandler, IDragHandler
{
    [SerializeField] private RectTransform joystickBackground = null;
    [SerializeField] private SmoothTransition smoothTransition = null;

    private RectTransform moveableJoytick = null;
    private CanvasGroup canvasGroup = null;
    private Vector2 delta = Vector2.zero;
    private Vector2 startPosition = Vector2.zero;

    private IEnumerator joytickRoutine = null;

    private Vector2 direction = Vector2.zero;
    public virtual float Horizontal => direction.x;
    public virtual float Vertical => direction.y;
    public bool HasInput => direction != Vector2.zero;
    public Vector2 Direction => direction;

    protected abstract void Awake(); //used for singleton

    private void Start()
    {
        delta = joystickBackground.sizeDelta;
        startPosition = joystickBackground.anchoredPosition;

        canvasGroup = joystickBackground.GetComponent<CanvasGroup>();
        //canvasGroup.alpha = 0;
        //canvasGroup.blocksRaycasts = false;

        moveableJoytick = joystickBackground.GetChild(0).GetComponent<RectTransform>();
    }

    public void OnPointerDown(PointerEventData eventData)
    {
        joystickBackground.position = eventData.position;

        //InvokeJoytickRoutine(true);
    }

    public virtual void OnPointerUp(PointerEventData eventData)
    {
        direction = Vector2.zero;
        moveableJoytick.anchoredPosition = direction;

        joystickBackground.anchoredPosition = startPosition;

        //InvokeJoytickRoutine(false);
    }

    public void OnDrag(PointerEventData eventData)
    {
        if (RectTransformUtility.ScreenPointToLocalPointInRectangle
            (joystickBackground, eventData.position, eventData.pressEventCamera, out var pos))
        {
            direction = new Vector2(pos.x / delta.x, pos.y / delta.y) * 2;
            direction.x = Mathf.Clamp(direction.x, -1, 1);
            direction.y = Mathf.Clamp(direction.y, -1, 1);

            //if (direction.magnitude > 1) direction.Normalize();

            Vector2 finalPosition = new Vector2(direction.x * delta.x / 3, direction.y * delta.y / 3);
            //Vector2 finalPosition = Direction.normalized * delta / 3;
            moveableJoytick.anchoredPosition = finalPosition;
        }
    }

    private void InvokeJoytickRoutine(bool enable)
    {
        if (joytickRoutine != null) StopCoroutine(joytickRoutine);
        joytickRoutine = JoystickRoutine(enable);
        StartCoroutine(joytickRoutine);
    }

    private IEnumerator JoystickRoutine(bool enable)
    {
        float percent = 0;
        float smoothPercent = 0;
        float speed = 1f / smoothTransition.duration;

        float currentAlpha = canvasGroup.alpha;
        float desiredAlpha = enable ? 1 : 0;

        while (percent < 1)
        {
            percent += speed * Time.deltaTime;
            smoothPercent = smoothTransition.curve.Evaluate(percent);
            canvasGroup.alpha = Mathf.MoveTowards(currentAlpha, desiredAlpha, smoothPercent);

            yield return null;
        }
    }
}

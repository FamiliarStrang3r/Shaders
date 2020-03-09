using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class GridTest : MonoBehaviour
{
    [SerializeField, Range(0, 10)] private int width = 5;

    private void OnDrawGizmosSelected()
    {
        Vector2 pos = new Vector2(Mathf.RoundToInt(transform.position.x), Mathf.RoundToInt(transform.position.y));

        Gizmos.color = Color.green;
        Gizmos.DrawCube(pos, Vector3.one);

        for (int x = -width; x <= width; x++)
        {
            for (int y = -width; y <= width; y++)
            {
                Vector2 p = new Vector2(x, y);//локальная координата

                int sum = Mathf.Abs(x) + Mathf.Abs(y);
                bool allowed = sum <= width;

                if (p + pos != pos && allowed)
                {
                    Gizmos.color = sum % 2 == 0 ? Color.white : Color.black;
                    Gizmos.DrawCube(p + pos, Vector3.one);//глобальная
                    //Handles.Label(p + pos, p.x + "/" + p.y, EditorStyles.helpBox);
                }
            }
        }
    }
}

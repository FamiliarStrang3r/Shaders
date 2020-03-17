using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEditor;

public class SomethingMenuItem : EditorWindow
{
    [MenuItem("Custom/Change Alpha")]
    private static void ChangeAlpha()
    {
        ChangeColor(FindObjectOfType<MoveJoystick>().GetComponent<Image>(), Color.red);
        ChangeColor(FindObjectOfType<InvisibleJoystick>().GetComponent<Image>(), Color.green);
    }

    private static void ChangeColor(Image image, Color mainColor)
    {
        image.enabled = false;
        var minAlpha = 0.1f;

        var currentAlpha = image.color.a;
        var desiredAlpha = currentAlpha >= minAlpha ? 0 : minAlpha;

        var newColor = mainColor;
        newColor.a = desiredAlpha;
        image.color = newColor;

        image.enabled = true;
    }
}

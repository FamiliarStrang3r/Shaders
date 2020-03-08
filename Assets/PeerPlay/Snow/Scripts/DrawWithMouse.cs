using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DrawWithMouse : MonoBehaviour
{
    [SerializeField] private Shader drawShader = null;
    [SerializeField, Range(0, 1)] private float brushStrength = 1;
    [SerializeField, Range(0, 10)] private int brushSize = 1;

    private Camera cam = null;
    private RenderTexture splatMap = null;
    private Material snowMaterial = null;
    private Material drawMaterial = null;

    private bool isDrawing = false;

    private void Start()
    {
        cam = Camera.main;

        Init();
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Mouse0))
            isDrawing = true;
        else if (Input.GetKeyUp(KeyCode.Mouse0))
            isDrawing = false;
    }

    private void FixedUpdate()
    {
        if (isDrawing)
        {
            Ray ray = cam.ScreenPointToRay(Input.mousePosition);
            if (Physics.Raycast(ray, out var hit))
            {
                Draw(hit.textureCoord);
            }
        }
    }

    private void Init()
    {
        splatMap = new RenderTexture(512, 512, 0, RenderTextureFormat.ARGBFloat);
        snowMaterial = GetComponent<MeshRenderer>().material;
        snowMaterial.SetTexture("_Splat", splatMap);

        drawMaterial = new Material(drawShader);
        drawMaterial.SetColor("_Color", Color.red);
    }

    private void Draw(Vector4 hitTexrureCoord)
    {
        drawMaterial.SetFloat("_Strength", brushStrength);
        drawMaterial.SetFloat("_Size", brushSize);
        drawMaterial.SetVector("_Coordinate", hitTexrureCoord);

        var temp = RenderTexture.GetTemporary(splatMap.width, splatMap.height, splatMap.depth, RenderTextureFormat.ARGBFloat);
        Graphics.Blit(splatMap, temp);
        Graphics.Blit(temp, splatMap, drawMaterial);
        RenderTexture.ReleaseTemporary(temp);
    }

    private void OnGUI()
    {
        //GUI.DrawTexture(new Rect(10, 10, 256, 256), splatMap, ScaleMode.ScaleToFit, false, 1);
    }
}

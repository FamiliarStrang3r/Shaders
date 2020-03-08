using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

public class SnowPlane : MonoBehaviour
{
    [SerializeField] private bool drawGizmo = false;
    [SerializeField, Range(0, 0.1f)] private float flakeAmount = 0;
    [SerializeField, Range(0, 1)] private float flakeOpacity = 1;

    private Material snowFallMaterial = null;
    private Renderer rend = null;

    private RenderTexture splatMap = null;
    private Material snowMaterial = null;
    private Material drawMaterial = null;

    private string savePath = string.Empty;
    private Vector2Int size = Vector2Int.one * 256;

    private void Start()
    {
        Init();
    }

    //private void OnDisable() => SaveTexture();

    private void FixedUpdate()
    {
        CreateSnow();
    }

    private void OnDrawGizmos()
    {
        if (!drawGizmo) return;

        var c = Color.blue;
        c.a = 0.5f;
        Gizmos.color = c;
        Vector3 ls = transform.localScale * 10;
        ls.y = 0.001f;
        Gizmos.DrawCube(transform.position, ls);
    }

    private void OnGUI()
    {
        Vector2 s = new Vector2(splatMap.width / 2, splatMap.height / 2);
        GUI.DrawTexture(new Rect(Vector2.one * 10, s), splatMap, ScaleMode.ScaleToFit, false, 1);
    }

    private void Init()
    {
        rend = GetComponent<Renderer>();
        snowFallMaterial = new Material(Shader.Find("Hidden/SnowFall"));

        savePath = Application.dataPath + "/SnowTexture.png";
        //if (File.Exists(savePath)) LoadTexture();
        //else
        splatMap = new RenderTexture(size.x, size.y, 0, RenderTextureFormat.ARGBFloat);

        snowMaterial = GetComponent<MeshRenderer>().material;
        snowMaterial.SetTexture("_Splat", splatMap);

        drawMaterial = new Material(Shader.Find("Hidden/DrawSnow"));
        drawMaterial.SetColor("_Color", Color.red);
    }

    private void SaveTexture()
    {
        RenderTexture.active = splatMap;
        Texture2D t = new Texture2D(splatMap.width, splatMap.height, TextureFormat.RGB24, false);
        t.ReadPixels(new Rect(0, 0, t.width, t.height), 0, 0);
        RenderTexture.active = null;

        byte[] bytes = t.EncodeToPNG();
        File.WriteAllBytes(savePath, bytes);
        UnityEditor.AssetDatabase.Refresh();
    }

    private void LoadTexture()
    {
        var bytes = File.ReadAllBytes(savePath);
        var texture = new Texture2D(size.x, size.y, TextureFormat.RGB24, false);
        texture.LoadImage(bytes);
        splatMap = new RenderTexture(size.x, size.y, 0, RenderTextureFormat.ARGBFloat);
        Graphics.Blit(texture, splatMap);
    }

    public void Draw(Vector4 textureCoord, float brushStrength, float brushSize)
    {
        drawMaterial.SetFloat("_Strength", brushStrength);
        drawMaterial.SetFloat("_Size", brushSize);
        drawMaterial.SetVector("_Coordinate", textureCoord);

        var temp = RenderTexture.GetTemporary(splatMap.width, splatMap.height, splatMap.depth, RenderTextureFormat.ARGBFloat);
        Graphics.Blit(splatMap, temp);
        Graphics.Blit(temp, splatMap, drawMaterial);
        RenderTexture.ReleaseTemporary(temp);
    }

    private void CreateSnow()
    {
        snowFallMaterial.SetFloat("_FlakeAmount", flakeAmount);
        snowFallMaterial.SetFloat("_FlakeOpacity", flakeOpacity);
        RenderTexture snow = rend.material.GetTexture("_Splat") as RenderTexture;
        var temp = RenderTexture.GetTemporary(snow.width, snow.height, 0, RenderTextureFormat.ARGBFloat);
        Graphics.Blit(snow, temp, snowFallMaterial);
        Graphics.Blit(temp, snow);
        rend.material.SetTexture("_Splat", snow);
        RenderTexture.ReleaseTemporary(temp);
    }
}

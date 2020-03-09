Shader "Hidden/VignetteImageEffect"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
		_Radius("Radius", Range(0, 1)) = 1
		_Softness("Softness", Range(0, 1)) = 0.5
		//_Color("Color", Color) = (0, 0, 0, 1)
		//_Opacity("Opacity", Range(0, 1)) = 1
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

		Tags
		{
			"PreviewType" = "Plane"
		}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"
			#include "Assets/dima.cginc"

            sampler2D _MainTex;
			float _Radius;
			float _Softness;
			//fixed4 _Color;
			//float _Opacity;

            fixed4 frag (v2f_img i) : SV_Target
            {
                fixed4 baseColor = tex2D(_MainTex, i.uv);
				
				fixed4 finalFignette = baseColor * Vignette(i.uv, 1 - _Radius, _Softness);
				return finalFignette;
            }
            ENDCG
        }
    }
}

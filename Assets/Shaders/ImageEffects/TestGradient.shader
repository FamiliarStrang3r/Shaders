﻿Shader "Hidden/TestGradient"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off 
		//ZWrite Off 
		//ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 black = fixed4(0, 0, 0, 1);
				fixed4 white = fixed4(1, 1, 1, 1);
				fixed4 col = lerp(black, white, i.uv.x) / lerp(black, white, i.uv.y);
                return saturate(col);
            }
            ENDCG
        }
    }
}

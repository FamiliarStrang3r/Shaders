﻿Shader "Custom/SnowPlane"
{
    Properties
    {
		_Tess ("Tessellation", Range(1, 10)) = 5
		_Displacement ("Displacement", Range(0, 1)) = 0.5
        _SnowColor ("Snow Color", Color) = (1, 1, 1, 1)
        _SnowTex ("Snow (RGB)", 2D) = "white" {}
		_GroundColor ("Ground Color", Color) = (1, 1, 1, 1)
        _GroundTex ("Ground (RGB)", 2D) = "white" {}
		_Splat ("Splat Map", 2D) = "black" {}
        _Glossiness ("Smoothness", Range(0, 1)) = 0.5
        _Metallic ("Metallic", Range(0, 1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows vertex:disp tessellate:tess
        #pragma target 4.6

		//#include "Tessellation.cginc"

        struct appdata
		{
            float4 vertex : POSITION;
            float4 tangent : TANGENT;
            float3 normal : NORMAL;
            float2 texcoord : TEXCOORD0;

			//float2 texcoord1 : TEXCOORD1;
			//float2 texcoord2 : TEXCOORD2;
        };

        float _Tess;

        float4 tess()
		{
			return _Tess;
        }

        sampler2D _Splat;
        float _Displacement;

        void disp (inout appdata v)
        {
            float d = tex2Dlod(_Splat, float4(v.texcoord.xy,0,0)).r * _Displacement;
            v.vertex.xyz -= v.normal * d;
			v.vertex.xyz += v.normal * _Displacement;
        }

        sampler2D _GroundTex;
		fixed4 _GroundColor;
		sampler2D _SnowTex;
		fixed4 _SnowColor;

        struct Input
        {
            float2 uv_GroundTex;
			float2 uv_SnowTex;
			float2 uv_Splat;
        };

        half _Glossiness;
        half _Metallic;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        //UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        //UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			half amount = tex2Dlod(_Splat, float4(IN.uv_Splat, 0, 0)).r;
			fixed4 c = lerp(tex2D(_SnowTex, IN.uv_SnowTex) * _SnowColor, tex2D(_GroundTex, IN.uv_GroundTex) * _GroundColor, amount);
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

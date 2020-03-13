Shader "Custom/TesselationSnowPlane"
{
    Properties
    {
		[IntRange] _Tess ("Tessellation", Range(1, 10)) = 5
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
        #pragma surface surf Standard fullforwardshadows vertex:vert tessellate:tess
        #pragma target 4.6

		//#include "Tessellation.cginc"
		//#include "Assets/dima.cginc"

        struct appdata
		{
            float4 vertex : POSITION;
            float4 tangent : TANGENT;
            float3 normal : NORMAL;
            float2 texcoord : TEXCOORD0;

			float2 texcoord1 : TEXCOORD1;
			float2 texcoord2 : TEXCOORD2;
        };

        float _Tess;

        float4 tess()
		{
			return _Tess;
        }

        sampler2D _Splat;
        float _Displacement;

		float3 CalculateNormal(float2 texcoord) 
		{
			const float3 off = float3(-0.01f, 0, 0.01f); // texture resolution to sample exact texels
			const float2 size = float2(0.01, 0.0); // size of a single texel in relation to world units

			float s01 = tex2Dlod(_Splat, float4(texcoord.xy - off.xy, 0, 0)).x * _Displacement;
			float s21 = tex2Dlod(_Splat, float4(texcoord.xy - off.zy, 0, 0)).x * _Displacement;
			float s10 = tex2Dlod(_Splat, float4(texcoord.xy - off.yx, 0, 0)).x * _Displacement;
			float s12 = tex2Dlod(_Splat, float4(texcoord.xy - off.yz, 0, 0)).x * _Displacement;

			float3 va = normalize(float3(size.xy, s21 - s01));
			float3 vb = normalize(float3(size.yx, s12 - s10));
            
			//return float3(s01, s12, 0);
			return normalize(cross(va, vb));
		}

        void vert (inout appdata v)
        {
			float4 uv = float4(v.texcoord.xy, 0, 0);
            float percent = tex2Dlod(_Splat, uv).r * _Displacement;
			v.vertex.xyz += -v.normal * percent + v.normal * _Displacement;
			//v.vertex.xyz += v.normal * d;//for mountains
			//v.normal = normalize(CalculateNormal(v.texcoord) + v.normal);
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

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			half amount = tex2Dlod(_Splat, float4(IN.uv_Splat, 0, 0)).r;
			fixed4 snow = tex2D(_SnowTex, IN.uv_SnowTex) * _SnowColor;
			fixed4 ground = tex2D(_GroundTex, IN.uv_GroundTex) * _GroundColor;
			fixed4 c = lerp(snow, ground, amount);

            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

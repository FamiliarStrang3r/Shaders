Shader "Hidden/UnderwaterImageEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		[Toggle] _Water("Water", float) = 0
		_NoiseScale("Noise Scale", Range(0, 2)) = 1
		_Frequency("Noice Frequency", Range(0, 50)) = 0
		_Speed("Noise Speed", Range(0, 5)) = 1
		_PixelOffset("Pixel Offset", Range(0, 10)) = 1

		[Header(Vignette)]
		_Radius("Radius", Range(0, 1)) = 1
		_Softness("Softness", Range(0, 1)) = 0.5
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
			#include "noiseSimplex.cginc"
			#include "Assets/dima.cginc"
			//#define M_PI 3.1415926535897932384626433832795

			uniform float _Frequency, _Speed, _NoiseScale, _PixelOffset;
			fixed _Water;

			float _Radius;
			float _Softness;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
				float4 screenPos : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.screenPos = ComputeScreenPos(o.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;

            fixed4 frag (v2f i) : COLOR
            {
				float vignette = Vignette(i.uv, 1 - _Radius, _Softness);

                float3 sPos = float3(i.screenPos.x, i.screenPos.y, 0) * _Frequency;
				sPos.z += _Time.y * _Speed;

				float noise = _NoiseScale * (snoise(sPos) + 1) / 2;
				float value = noise * UNITY_PI * 2;
				float4 dir = float4(cos(value), sin(value), 0, 0);
				fixed4 col = fixed4(noise, noise, noise, 1);

				if (_Water != 0) col = tex2Dproj(_MainTex, i.screenPos + normalize(dir) * _PixelOffset / 100);

                return col;
				//return lerp(tex2D(_MainTex, i.uv), col, 1 - vignette);
            }
            ENDCG
        }
    }
}

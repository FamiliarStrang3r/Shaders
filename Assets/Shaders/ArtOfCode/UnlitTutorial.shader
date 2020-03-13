Shader "Unlit/UnlitTutorial"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Frequency("Frequency", Range(0, 1)) = 1
		_Radius("Radius", Range(0, 0.2)) = 0.1
		_Softness("Softness", Range(0, 1)) = 0.08
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
				float3 worldPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			float _Radius, _Softness, _Frequency;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //fixed4 col = tex2D(_MainTex, i.uv);
				//float2 wPos = float2(i.worldPos.x, i.worldPos.z);
				float2 uv = (i.uv) * 2 - 1;
				float a = _Time.y * _Frequency;
				float2 pos = float2(cos(a), sin(a * 2)) * 0.5;
				float d = length(uv - pos);
				float m = smoothstep(_Radius, _Radius - _Softness, d);
                return m;
            }
            ENDCG
        }
    }
}

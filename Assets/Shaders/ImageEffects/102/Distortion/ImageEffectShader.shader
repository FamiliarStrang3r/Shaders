Shader "Hidden/102-ImageEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Mask("Mask", 2D) = "white" {}
		[MaterialToggle] _Inverted("Inverted", float) = 0
		_Speed ("Color Speed", float) = 1
		_DisplaceTex("Displacement Texture", 2D) = "white" {}
		_Amount("Amount", Range(0, 1)) = 1
		_DisplaceSpeed("Speed", Vector) = (0, 0, 0, 0)
    }

    SubShader
    {
		Tags 
		{ 
			"PreviewType"="Plane" 
		}
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
			#include "Assets/dima.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
			float _Speed;
			sampler2D _DisplaceTex;
			float _Amount;
			float2 _DisplaceSpeed;
			sampler2D _Mask;
			float _Inverted;

			fixed4 GetWaveEffectColor(float2 uv)
			{
				float2 distuv = float2(uv.x - _Time.y * _DisplaceSpeed.x, uv.y - _Time.y * _DisplaceSpeed.y);

				float2 disp = tex2D(_DisplaceTex, distuv).xy;//animated
                //float2 disp = tex2D(_DisplaceTex, uv).xy;//not animated
				disp = ((disp * 2) - 1) * _Amount / 10;//converted to range -1..1

				fixed4 col = tex2D(_MainTex, uv + disp);

				return col;
			}

            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 effect = GetWaveEffectColor(i.uv) * GetUVColor(i.uv, _Speed);

				float4 baseColor = tex2D(_MainTex, i.uv);
				float percent01 = tex2D(_Mask, i.uv).r;

				fixed4 finalColor = lerp(baseColor, effect, percent01);

				if (_Inverted != 0) finalColor = lerp(effect, baseColor, percent01);

				return finalColor;
            }

            ENDCG
        }
    }
}

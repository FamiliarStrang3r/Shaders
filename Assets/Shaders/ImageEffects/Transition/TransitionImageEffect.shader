Shader "Hidden/TransitionImageEffect"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
		_SecondTex("Texture", 2D) = "white" {}
		_Color("Color", Color) = (1, 1, 1, 1)
		_Percent("Percent", Range(0, 1)) = 0
		_Radius("Radius", Range(0, 1)) = 0
		_Softness("Softness", Range(0, 1)) = 0
    }
    SubShader
    {
		Tags 
		{ 
			"PreviewType" = "Plane" 
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
			sampler2D _SecondTex;
			fixed4 _Color;
			float _Percent;
			float _Radius;
			float _Softness;

            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 baseColor = tex2D(_MainTex, i.uv);
				return lerp(baseColor, _Color, step(0, _Percent - i.uv.x));

				//if (i.uv.x <= _Percent) return _Color;
				//else return baseColor;

				//
				//return HorizontalTransition(_MainTex, i.uv, _Percent, _Color);
				//return VerticalTransition(_MainTex, i.uv, _Percent, _Color);
				//return TextureTransition(_MainTex, _SecondTex, i.uv, _Percent, _Color);

				//return lerp(tex2D(_MainTex, i.uv), _Color, _Percent);
				//return Fade(tex2D(_MainTex, i.uv), _Color, _Percent);
				//return Fade(_MainTex, i.uv, _Color, _Percent);
            }
            ENDCG
        }
    }
}

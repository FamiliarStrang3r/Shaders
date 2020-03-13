Shader "XRay Shaders/ColoredOutline"
{
	Properties
	{
		//_EdgeColor("Edge Color", Color) = (1,1,1,1)
		//[IntRange] _Power("Power", Range(1, 3)) = 1
	}

	SubShader
	{
		Stencil
		{
			Ref 1		//0
			Comp Equal	//NotEqual
		}

		Tags
		{
			"Queue" = "Transparent"
			"RenderType" = "Transparent"
			"XRay" = "ColoredOutline"
		}

		//ZWrite Off
		ZTest Always
		Blend One One

		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
				float3 viewDir : TEXCOORD1;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = UnityObjectToWorldNormal(v.normal);
				o.viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);
				return o;
			}

			fixed4 _EdgeColor;
			float _Power;

			fixed4 frag (v2f i) : SV_Target
			{
				float rim = 1 - dot(i.normal, i.viewDir);
				return _EdgeColor * pow(rim, _Power);
				//return _EdgeColor;
			}

			ENDCG
		}
	}
}

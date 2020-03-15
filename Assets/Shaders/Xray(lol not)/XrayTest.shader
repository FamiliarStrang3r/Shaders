Shader "Unlit/XrayTest"
{
    Properties
    {

    }

    SubShader
    {
        Tags
		{
			"RenderType" = "Transparent"
			"Queue" = "Transparent"
		}

        Pass
        {
			//ZWrite Off
			//ZTest Always
			//Blend One One

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
				//float3 viewDir : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				//o.normal = UnityObjectToWorldNormal(v.normal);
				o.normal = v.normal;
				//o.normal = normalize(mul(UNITY_MATRIX_IT_MV, v.normal));
				//o.viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);
                return o;
            }

			fixed4 _Color;
			float _Power;

            fixed4 frag (v2f i) : SV_Target
            {
				//float edge = 1 - dot(i.normal, i.viewDir);
                //return _Color * pow(edge, _Power);
				return fixed4(i.normal * 0.5 + 0.5, 1);
            }
            ENDCG
        }
    }
}

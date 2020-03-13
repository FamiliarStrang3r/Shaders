Shader "Unlit/TestUnlit"
{
    Properties
    {
    }

    SubShader
    {
        Tags
		{
			"RenderType" = "Opaque"
			"Replacement" = "Shader"
		}

        Pass
        {
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

			fixed4 _Color;

            fixed4 frag (v2f i) : SV_Target
            {
				//half rim = 1 - saturate(dot(normalize(IN.viewDir), o.Normal));// standard rim calculation  

				float rim = 1 - dot(i.normal, i.viewDir);
                return _Color * rim;
            }
            ENDCG
        }
    }
}

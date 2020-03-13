Shader "Unlit/SpriteGrass"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
		_Color("Color", Color) = (1, 1, 1, 1)

		[Header(Wind)]
		_Mask("Mask", 2D) = "white" {}
		_Frequency("Frequency",Range(0, 5)) = 1
		_Strength("Strength", Range( 0, 1)) = 1
    }
    SubShader
    {
        Tags 
		{ 
			"RenderType"="Transparent"
			"Queue" = "Transparent"
		}
        LOD 100

        Pass
        {
			Blend SrcAlpha OneMinusSrcAlpha
			Cull Off

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

            sampler2D _MainTex;
            float4 _MainTex_ST;
			fixed4 _Color;

			sampler2D _Mask;
			half _Frequency;
			half _Strength;

            v2f vert (appdata v)
            {
				float4 localSpaceVertex = v.vertex;
				float4 worldSpaceVertex = mul(unity_ObjectToWorld, localSpaceVertex);

				float height = (localSpaceVertex.y / 2 + .5);//height of the vertex in the range (0,1)

				//fixed color = tex2Dlod(_Mask, float4(v.uv, 0, 0)).r;
				fixed percent01 = float4(v.uv, 0, 0).y;
				fixed4 color = lerp(fixed4(0, 0, 0, 1), fixed4(1, 1, 1, 1), percent01);
				height *= color;

				float sinValue = sin(_Time.y * _Frequency);
				worldSpaceVertex.x += sinValue * height * _Strength;

				//takes the new modified position of the vert in world space and then puts it back in local space
				v.vertex = mul(unity_WorldToObject, worldSpaceVertex);

				v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                return col;
            }
            ENDCG
        }
    }
}

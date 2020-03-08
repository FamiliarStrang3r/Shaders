Shader "Custom/WindGrass"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0

		[Header(Wind)]
		_Mask("Mask", 2D) = "white" {}
		_Frequency("Frequency",Range(0, 2)) = 1
		_Strength("Strength", Range( 0, 2)) = 0
		_GustDistance("Distance between gusts", Range(0, 1)) = 0
		_Direction("Wind Direction", vector) = (1, 0, 1, 0)
    }

    SubShader
    {
		Cull Off

        Tags
		{ 
			"Queue"="Transparent"
			"RenderType"="TransparentCutout"
		}
        //LOD 200

        CGPROGRAM
        #pragma surface surf Standard vertex:vert alpha:fade
		//#pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

		sampler2D _Mask;
		half _Frequency;
		half _GustDistance;
		half _Strength;
		float3 _Direction;

		void vert(inout appdata_full v)
		{
			float4 localSpaceVertex = v.vertex;
			// Takes the mesh's verts and turns it into a point in world space
			// this is the equivalent of Transform.TransformPoint on the scripting side
			float4 worldSpaceVertex = mul(unity_ObjectToWorld, localSpaceVertex);
 
			//height of the vertex in the range (0,1)
			float height = (localSpaceVertex.y / 2 + .5);

			fixed color = tex2Dlod(_Mask, float4(v.texcoord.xy, 0, 0)).r;
			height *= color;
			
			fixed sinX = sin(_Time.y * _Frequency + worldSpaceVertex.x * _GustDistance);
			fixed sinZ = sin(_Time.y * _Frequency + worldSpaceVertex.z * _GustDistance);

			worldSpaceVertex.x += sinX * height * _Strength * _Direction.x;
			worldSpaceVertex.z += sinZ * height * _Strength * _Direction.z;

			//takes the new modified position of the vert in world space and then puts it back in local space
			v.vertex = mul(unity_WorldToObject, worldSpaceVertex);
		}

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}

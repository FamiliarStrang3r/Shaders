Shader "XRay Shaders/Diffuse-XRay-Replaceable"
{
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Base (RGB)", 2D) = "white" {}
		_EdgeColor("XRay Edge Color", Color) = (0,0,0,0)
		[IntRange] _Power("Power", Range(1, 3)) = 1
		//_Percent("Percent", Range(0, 1)) = 1
	}

	SubShader
	{
		Tags
		{
			//In some cases, it's necessary to force XRay objects to render before the rest of the geometry
			//This is so their depth info is already in the ZBuffer, and Occluding objects won't mistakenly
			//write to the Stencil buffer when they shouldn't.		
			//
			//This is what "Queue" = "Geometry-10" is for.
			//I didn't bring this up in the video because I'm an idiot.
			//Cheers,Dan

			"RenderType" = "Opaque"
			"Queue" = "Geometry-10"
			"XRay" = "ColoredOutline"
		}
		LOD 200

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		fixed4 _Color;
		float _Percent;

		struct Input
		{
			float2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	
	Fallback "Legacy Shaders/VertexLit"
}

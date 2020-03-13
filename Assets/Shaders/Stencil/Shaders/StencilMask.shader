Shader "Custom/StencilMask"
{
    Properties
    {
        [PerRendererData] _MainTex ("Albedo (RGB)", 2D) = "white" {}

		[Header(Stencil)]
		[IntRange] _Ref("Ref", Range(0, 255)) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)] _Comp("Comp", float) = 8
		[Enum(UnityEngine.Rendering.StencilOp)] _Pass("Pass", float) = 2
    }
    SubShader
    {
		//mesh needs to be render before any geometry
		//if object rendered before mask - mask would not apply to it
        Tags
		{
			"RenderType" = "Opaque"
			"Queue" = "Geometry-100"
		}
		//dont draw mesh color channels into scene
		ColorMask 0
		//stop writing to depth buffer,
		//otherwise objects behind the mask would not rendered - opposite what we want
		ZWrite Off

		Stencil
		{
			Ref [_Ref]
			Comp [_Comp]//default: always, now doesnt matter
			Pass [_Pass]//SL: replace - when shader passes replace all values in stencil buffer with new reference value
		}

        CGPROGRAM
		#pragma surface surf Lambert

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG
    }
}

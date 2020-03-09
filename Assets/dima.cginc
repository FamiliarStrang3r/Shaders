float Vignette(float2 uv, float radius, float softness)
{
	float distFromCenter = distance(uv.xy, float2(0.5, 0.5));
	float vignette = smoothstep(radius, radius - softness, distFromCenter);
	return vignette;
}

fixed4 GetGrayscale(fixed4 c)
{
	fixed4 grayscale = (c.r + c.g + c.b) / 3;
	return grayscale;
}

fixed4 GetUVColor(float2 uv, float speed)
{
	fixed4 red = fixed4(uv.r, uv.g, 0, 1);
	fixed4 blue = fixed4(uv.r, uv.g, 1, 1);
	float sinValue = sin(_Time.y * speed);
	float percent01 = (sinValue + 1) / 2;
	fixed4 color = lerp(red, blue, percent01);

	return color;
}

fixed4 HorizontalTransition(sampler2D mainTex, float2 uv, float percent01, fixed4 color)
{
	if (uv.x <= percent01)
		return color;
	else
		return tex2D(mainTex, uv);
}

fixed4 VerticalTransition(sampler2D mainTex, float2 uv, float percent01, fixed4 color)
{
	if (0.5 - abs(uv.y - 0.5) <= percent01 / 2)
		return color;
	else
		return tex2D(mainTex, uv);
}

fixed4 TextureTransition(sampler2D mainTex, sampler2D gradientTex, float2 uv, float percent01, fixed4 color)
{
	fixed4 col = tex2D(gradientTex, uv);

	if (col.r < percent01)
		return color;
	else
		return tex2D(mainTex, uv);
}

fixed4 Fade(fixed4 baseColor, fixed4 color, float percent01)
{
	return lerp(baseColor, color, percent01);
}

fixed4 Fade(sampler2D mainTex, float2 uv, fixed4 color, float percent01)
{
	return lerp(tex2D(mainTex, uv), color, percent01);
}
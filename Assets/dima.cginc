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
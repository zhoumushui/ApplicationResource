precision highp float;

uniform $1$ uSampler;
varying vec2 vTextureCoord;
uniform float uAmount;

vec4 Desaturate(vec3 color)
{
	vec3 grayXfer = vec3(0.3, 0.59, 0.11);
	vec3 gray = vec3(dot(grayXfer, color));
	return vec4(gray, 1.0);
}

void main() {
	vec4 color = texture2D(uSampler, vTextureCoord);
	gl_FragColor = mix(
		color,
		Desaturate(color.rgb),
		uAmount);
}
precision highp float;

uniform $1$ uSampler;
uniform sampler2D uData;
varying vec2 vTextureCoord;
uniform float uAmount;

void main() {
	vec4 color = texture2D(uSampler, vTextureCoord);
	vec2 pos = vec2((color.r + color.g + color.b)/ 3.0, 0.0);
	vec4 dstColor = texture2D(uData, pos);
	
	gl_FragColor = mix(
		color,
		dstColor,
		uAmount);
}
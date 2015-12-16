precision highp float;

uniform sampler2D texture;
uniform float amount;
varying vec2 vTextureCoord;

void main() {
	vec4 color = texture2D(texture, vTextureCoord);
	float average = (color.r + color.g + color.b) / 3.0;
	float mx = max(color.r, max(color.g, color.b));
	float amt = (mx - average) * (-amount * 3.0);
	color.rgb = mix(color.rgb, vec3(mx), amt);
	gl_FragColor = color;
}
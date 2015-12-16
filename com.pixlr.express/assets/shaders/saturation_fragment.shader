precision highp float;

uniform $1$ uSampler;
uniform float saturation;

varying vec2 vTextureCoord;

void main() {
	vec4 color = texture2D(uSampler, vTextureCoord);
	
	/* saturation adjustment */
	float amount = saturation * 0.5; // Multiply by 0.5 in order to match express flash version
	float average = (color.r + color.g + color.b) / 3.0;
	if (amount > 0.0) {
		color.rgb += (average - color.rgb) * (1.0 - 1.0 / (1.001 - amount));
	} else {
		color.rgb += (average - color.rgb) * (-amount);
	}
	
	gl_FragColor = color;
}
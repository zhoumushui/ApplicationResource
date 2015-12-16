precision highp float;

uniform sampler2D texture;
varying vec2 vTextureCoord;
uniform float uAmount;

void main() {
	vec4 color = texture2D(texture, vTextureCoord);
	
	float r = color.r * 255.0;
	float g = color.g * 255.0;
	float b = color.b * 255.0;
	
	r = (r*0.393) + (g*0.769) + (b*0.189);
	g = (r*0.349) + (g*0.686) + (b*0.168);
	b = (r*0.272) + (g*0.534) + (b*0.131);
				
	if(r > 255.0) r = 255.0;
	else if(r < 0.0) r = 0.0;
	if(g > 255.0) g = 255.0;
	else if(g < 0.0) g = 0.0;
	if(b > 255.0) b = 255.0;
	else if(b < 0.0) b = 0.0;
	
	gl_FragColor = mix(
		color,
		vec4(r/255.0, g/255.0, b/255.0, color.a),
		uAmount);
}
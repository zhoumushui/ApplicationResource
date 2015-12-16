precision highp float;

uniform $1$ uSampler;	
uniform sampler2D red;	
uniform sampler2D green;	
uniform sampler2D blue;
uniform float uAmount;

varying vec2 vTextureCoord;

void main() {
	vec4 color = texture2D(uSampler, vTextureCoord);
	
	vec2 indexRed = vec2(color.r, 0.0);
    vec4 redColor = texture2D(red, indexRed);
    
    vec2 indexGreen = vec2(color.g, 0.0);
    vec4 greenColor = texture2D(green, indexGreen);
    
    vec2 indexBlue = vec2(color.b, 0.0);
    vec4 blueColor = texture2D(blue, indexBlue);
    
	gl_FragColor = mix(
		color,
		vec4(redColor.r, greenColor.g, blueColor.b, color.a),
		uAmount);
}
precision highp float;

varying vec2 vTextureCoord;
uniform sampler2D uSampler;	

uniform sampler2D red;	
uniform sampler2D green;	
uniform sampler2D blue;

void main() {
	vec4 color = texture2D(uSampler, vTextureCoord);

	//for premultiplied image
	if(color.a != 0.0) color.rgb /= color.a;
	
	vec2 indexRed = vec2(color.r, 0.0);
    vec4 redColor = texture2D(red, indexRed);
    
    vec2 indexGreen = vec2(color.g, 0.0);
    vec4 greenColor = texture2D(green, indexGreen);
    
    vec2 indexBlue = vec2(color.b, 0.0);
    vec4 blueColor = texture2D(blue, indexBlue);
	
	gl_FragColor = vec4(redColor.r, greenColor.g, blueColor.b, color.a);

	//for premultiplied image
	gl_FragColor.rgb *= gl_FragColor.a;
}
precision highp float;

uniform sampler2D uSampler;	
uniform sampler2D red;	
uniform sampler2D green;	
uniform sampler2D blue;

uniform int mode;

varying vec2 vTextureCoord;

void main() {
	vec4 color = texture2D(uSampler, vTextureCoord);

	//for premultiplied image
	if(color.a != 0.0)	color.rgb /= color.a;

	if(mode == 0)
	{
		vec2 indexRed = vec2(color.r, 0.0);
		vec4 redColor = texture2D(red, indexRed);
    
		vec2 indexGreen = vec2(color.g, 0.0);
		vec4 greenColor = texture2D(green, indexGreen);
    
		vec2 indexBlue = vec2(color.b, 0.0);
		vec4 blueColor = texture2D(blue, indexBlue);

		gl_FragColor = vec4(redColor.r, greenColor.g, blueColor.b, color.a);
	}
	else if(mode == 1)
	{
		vec2 indexRed = vec2(color.r, 0.0);
		vec4 redColor = texture2D(red, indexRed);

		vec2 indexGreen = vec2(color.g, 0.0);
		vec4 greenColor = texture2D(green, indexGreen);

		gl_FragColor = vec4(redColor.r, greenColor.g, color.b, color.a);
	}
	else if(mode == 2)
	{
		vec2 indexRed = vec2(color.r, 0.0);
		vec4 redColor = texture2D(red, indexRed);

		vec2 indexBlue = vec2(color.b, 0.0);
		vec4 blueColor = texture2D(blue, indexBlue);

		gl_FragColor = vec4(redColor.r, color.g, blueColor.b, color.a);
	}
	else if(mode == 3)
	{
		vec2 indexGreen = vec2(color.g, 0.0);
		vec4 greenColor = texture2D(green, indexGreen);

		vec2 indexBlue = vec2(color.b, 0.0);
		vec4 blueColor = texture2D(blue, indexBlue);

		gl_FragColor = vec4(color.r, greenColor.g, blueColor.b, color.a);
	}
	else if(mode == 4)
	{
		vec2 indexRed = vec2(color.r, 0.0);
		vec4 redColor = texture2D(red, indexRed);

		gl_FragColor = vec4(redColor.r, color.g, color.b, color.a);
	}
	else if(mode == 5)
	{
		vec2 indexGreen = vec2(color.g, 0.0);
		vec4 greenColor = texture2D(green, indexGreen);

		gl_FragColor = vec4(color.r, greenColor.g, color.b, color.a);
	}
	else if(mode == 6)
	{
		vec2 indexBlue = vec2(color.b, 0.0);
		vec4 blueColor = texture2D(blue, indexBlue);

		gl_FragColor = vec4(color.r, color.g, blueColor.b, color.a);
	}
	else
		gl_FragColor = color;

	//for premultiplied image
	gl_FragColor.rgb *= gl_FragColor.a;
}
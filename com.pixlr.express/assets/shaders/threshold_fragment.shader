precision highp float;

varying vec2 vTextureCoord;
uniform sampler2D uSampler;
uniform float amount;

void main(void) {

	vec4 color = texture2D(uSampler, vTextureCoord);
	color.r = (color.r >= amount ? amount : 0.0);
	color.g = (color.g >= amount ? amount : 0.0);
	color.b = (color.b >= amount ? amount : 0.0);
	color.a = (color.a >= amount ? amount : 0.0);
	
	gl_FragColor = color;
  
}
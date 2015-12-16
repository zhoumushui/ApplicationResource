precision highp float;

varying vec2 vTextureCoord;
uniform $1$ uSampler;

void main(void) { 
	gl_FragColor = texture2D(uSampler, vTextureCoord);
}
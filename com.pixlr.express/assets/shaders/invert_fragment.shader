//this shader inverts colors
precision highp float;


uniform sampler2D sampler0;
varying vec2 vTextureCoord;

void main(){
	gl_FragColor = 1.0 - texture2D(sampler0, vTextureCoord);
}
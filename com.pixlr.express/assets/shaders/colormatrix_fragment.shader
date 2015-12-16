precision highp float;

uniform sampler2D texture;
uniform mat4 colormatrix;
varying vec2 vTextureCoord;

void main() {
	vec4 color = texture2D(texture, vTextureCoord);
	gl_FragColor = color * colormatrix;
}
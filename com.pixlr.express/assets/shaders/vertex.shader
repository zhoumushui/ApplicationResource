precision highp float;

attribute vec3 aVertexPosition;
attribute vec2 aTextureCoord;

uniform float uXoffset;
uniform float uYoffset;
uniform float uScaleX;
uniform float uScaleY;
uniform float uFlip;
uniform float vFlip;
uniform vec2 uRotation;

uniform vec2 uResolution;

uniform mat4 uTexMatTransform;

varying vec2 vTextureCoord;

void main(void) {

	vec3 vertex_pos = aVertexPosition;

	vertex_pos.x = vertex_pos.x * uScaleX * uResolution.x / uResolution.y;
	vertex_pos.y = vertex_pos.y * uScaleY;

	vec3 pos = vec3(
	 	vertex_pos.x * uRotation.y + vertex_pos.y * uRotation.x,
	 	vertex_pos.y * uRotation.y - vertex_pos.x * uRotation.x, 0.0);

	pos = pos / vec3(uResolution.x / uResolution.y, 1.0, 1.0);

	pos = pos + vec3(uXoffset * uScaleX, uYoffset * uScaleY, 0.0);

	pos.y = pos.y * uFlip;
	pos.x = pos.x * vFlip;

	gl_Position = vec4(pos, 1.0);


 	vec4 l_tex =  uTexMatTransform*vec4(aTextureCoord.xy,0, 1);
	vTextureCoord = l_tex.xy;
}
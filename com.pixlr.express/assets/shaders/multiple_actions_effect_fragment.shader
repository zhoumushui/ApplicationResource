precision highp float;

varying vec2 vTextureCoord;
uniform sampler2D uSampler;
uniform sampler2D blendTexture;
uniform float uAmount;

void main(void) {

	vec4 color = texture2D(uSampler, vTextureCoord);
	
	vec4 texel = texture2D(blendTexture, vec2(vTextureCoord.s, vTextureCoord.t));
	vec4 blendColor = vec4(texel.rgb, 1.0);
	gl_FragColor = mix(color, blendColor, uAmount); 
}
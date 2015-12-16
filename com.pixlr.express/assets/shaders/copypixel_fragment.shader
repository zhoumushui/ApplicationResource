precision highp float;

varying vec2 vTextureCoord;
uniform sampler2D uSampler;
uniform sampler2D sourceTexture;
uniform sampler2D alphaTexture;

void main() {
	vec4 color = texture2D(uSampler, vTextureCoord);
    vec4 sourceColor = texture2D(sourceTexture, vTextureCoord);
    vec4 alphaColor = texture2D(alphaTexture, vTextureCoord);

	gl_FragColor = sourceColor * alphaColor.a + color * (1.0 - alphaColor.a);
}
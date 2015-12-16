precision highp float;

varying vec2 vTextureCoord;
uniform sampler2D uSampler;
uniform sampler2D blurredTexture;

uniform float amount;

void main(void) {

	vec4 color = texture2D(uSampler, vTextureCoord);

	//for premultiplied image
	if(color.a != 0.0) color.rgb /= color.a;

    vec4 blurColor = texture2D(blurredTexture, vTextureCoord);

	vec4 result = mix(blurColor, color, 1.0 + amount);

	result.rgb = clamp(result.rgb, 0.0, 1.0);

	//for premultiplied image
	result.rgb *= result.a;

    gl_FragColor = result;
}
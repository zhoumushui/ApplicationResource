precision highp float;

varying vec2 vTextureCoord;

uniform $1$ uSampler;
uniform float uContrast;
uniform float uBrightness;

void main(void) {
    vec4 texel = texture2D(uSampler, vec2(vTextureCoord.s, vTextureCoord.t));

    vec3 rgbcolor = texel.rgb;

	float nStepB = uBrightness * 0.498;
	
    if(texel.a != 0.0)
	{
		rgbcolor += nStepB;
		if (uContrast > 0.0) {
			float nStepC = uContrast * 0.687;
			rgbcolor = (rgbcolor - 0.5) / (1.0 - nStepC) + 0.5;
		} else {
			float nStepC = uContrast * 1.123;
			rgbcolor = (rgbcolor - 0.5) * (1.0 + nStepC) + 0.5;
		}	
	}

    gl_FragColor = vec4(rgbcolor, texel.a);//1.0);
}
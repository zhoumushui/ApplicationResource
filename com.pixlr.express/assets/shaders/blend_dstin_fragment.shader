precision highp float;

uniform sampler2D Sample0;	// Background layer (AKA: Destination)
uniform sampler2D Sample1;	// Foreground layer (AKA: Source)

uniform float alpha;
uniform float amount;

varying vec2 vTextureCoord;

void main ()
{
	vec4 dst = texture2D(Sample0, vTextureCoord);
	vec4 src = texture2D(Sample1, vTextureCoord);

	src.a *= alpha;		
	vec4 colour = vec4(dst.rgb * src.a, dst.a * src.a);
				
	colour = clamp(colour, 0.0, 1.0);

	gl_FragColor = mix(dst, colour, amount);
}
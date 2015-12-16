precision highp float;

uniform sampler2D Sample0;	// Background layer (AKA: Destination)
uniform sampler2D Sample1;	// Foreground layer (AKA: Source)

uniform float alpha;
uniform float amount;

varying vec2 vTextureCoord;

void main ()
{
	// Get samples from both layers
	vec4 dst = texture2D(Sample0, vTextureCoord);
	vec4 src = texture2D(Sample1, vTextureCoord);	
	
	src.a *= alpha;
				
	vec3 value = vec3((dst.x <= 0.5) ? (2.0 * src.x * dst.x) : (1.0 - 2.0 * (1.0 - dst.x) * (1.0 - src.x)),
			(dst.y <= 0.5) ? (2.0 * src.y * dst.y) : (1.0 - 2.0 * (1.0 - dst.y) * (1.0 - src.y)),
			(dst.z <= 0.5) ? (2.0 * src.z * dst.z) : (1.0 - 2.0 * (1.0 - dst.z) * (1.0 - src.z)));
		
	vec4 colour = vec4(value, 1.0) * src.a + dst * (1.0 - src.a);
				
	colour = clamp(colour, 0.0, 1.0);

	gl_FragColor.xyz = mix(dst, colour, amount).rgb;
	gl_FragColor.w = 1.0;
	
}
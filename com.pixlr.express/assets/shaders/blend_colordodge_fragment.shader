/// <summary>
/// Fragment shader for blending 2 images.
/// </summary>

/// <summary>
/// Uniform variables.
/// <summary>

precision highp float;

uniform sampler2D Sample0;	// Background layer (AKA: Destination)
uniform sampler2D Sample1;	// Foreground layer (AKA: Source)

uniform float alpha;
uniform float amount;


/// <summary>
/// Varying variables.
/// <summary>
varying vec2 vTextureCoord;

/// <summary>
/// Fragment shader entry.
/// <summary>
void main ()
{
	// Get samples from both layers
	vec4 dst = texture2D(Sample0, vTextureCoord);
	vec4 src = texture2D(Sample1, vTextureCoord);
	
	src.a *= alpha;
		
	vec3 value = vec3((src.x == 1.0) ? 1.0 : min(1.0, dst.x / (1.0 - src.x)),
			(src.y == 1.0) ? 1.0 : min(1.0, dst.y / (1.0 - src.y)),
			(src.z == 1.0) ? 1.0 : min(1.0, dst.z / (1.0 - src.z)));
				
	vec4 colour = vec4(value, 1.0) * src.a + dst * (1.0 - src.a);
		
	colour = clamp(colour, 0.0, 1.0);

	gl_FragColor = mix(dst, colour, amount);
}
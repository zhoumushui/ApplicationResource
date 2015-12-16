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

	vec4 colour = vec4(max(dst, src).rgb, 1.0) * src.a + dst * (1.0 - src.a);
		
	colour = clamp(colour, 0.0, 1.0);

	gl_FragColor = mix(dst, colour, amount);
}
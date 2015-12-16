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
	
	float value1;
	if(src.x <= 0.5)
	{
		value1 = dst.x - (1.0 - 2.0 * src.x) * dst.x * (1.0 - dst.x);
	}
	else
	{
		if((src.x > 0.5) && (dst.x <= 0.25))
		{
			value1 = dst.x + (2.0 * src.x - 1.0) * (4.0 * dst.x * (4.0 * dst.x + 1.0) * (dst.x - 1.0) + 7.0 * dst.x);
		}
		else
		{
			value1 = (dst.x + (2.0 * src.x - 1.0) * (sqrt(dst.x) - dst.x));
		}
	}
	float value2;
	if(src.y <= 0.5)
	{
		value2 = dst.y - (1.0 - 2.0 * src.y) * dst.y * (1.0 - dst.y);
	}
	else
	{
		if((src.y > 0.5) && (dst.y <= 0.25))
		{
			value2 = dst.y + (2.0 * src.y - 1.0) * (4.0 * dst.y * (4.0 * dst.y + 1.0) * (dst.y - 1.0) + 7.0 * dst.y);
		}
		else
		{
			value2 = dst.y + (2.0 * src.y - 1.0) * (sqrt(dst.y) - dst.y);
		}
	}
	float value3;
	if(src.z <= 0.5)
	{
		value3 = dst.z - (1.0 - 2.0 * src.z) * dst.z * (1.0 - dst.z);
	}
	else
	{
		if((src.z > 0.5) && (dst.z <= 0.25))
		{
			value3 = dst.z + (2.0 * src.z - 1.0) * (4.0 * dst.z * (4.0 * dst.z + 1.0) * (dst.z - 1.0) + 7.0 * dst.z);
		}
		else
		{
			value3 = dst.z + (2.0 * src.z - 1.0) * (sqrt(dst.z) - dst.z);
		}
	}
		
	vec3 value = vec3(value1, value2, value3);	
	
	vec4 colour = vec4(value, 1.0) * src.a + dst * (1.0 - src.a);
		
	colour = clamp(colour, 0.0, 1.0);

	gl_FragColor = mix(dst, colour, amount);
}
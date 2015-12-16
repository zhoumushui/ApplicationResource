/// <summary>
/// Fragment shader for blending 2 images.
/// </summary>

/// <summary>
/// Uniform variables.
/// <summary>

precision highp float;

uniform sampler2D Sample0;	// Background layer (AKA: Destination)
uniform sampler2D Sample1;	// Foreground layer (AKA: Source)
uniform sampler2D maskTexture;

uniform int blendmode;  // use to identify the blend mode
uniform float alpha;

uniform float amount;


/// <summary>
/// Varying variables.
/// <summary>
varying vec2 vTextureCoord;


/// <summary>
/// Blend the source and destination pixels.
/// This function does not precompute alpha channels. To learn more about the equations that
/// factor in alpha blending, see http://www.w3.org/TR/2009/WD-SVGCompositing-20090430/.
/// <summary>
/// <param name="src">Source (foreground) pixel.</param>
/// <param name="dst">Destination (background) pixel.</param>
/// <returns>The blended pixel.</returns>
vec4 blend (in vec4 src, in vec4 dst, in int blendmode, in float alpha)
{	
	if(blendmode == 0) // Dst over
	{
		return vec4(dst.rgb, alpha) * alpha + src * (1.0 - alpha);
	}
	else if(blendmode == 1) //Add
	{
		return vec4((src + dst).rgb, alpha) * alpha + dst * (1.0 - alpha);
	}
	else if(blendmode == 2) //Multiply
	{
		return src * dst * alpha + dst * (1.0 - alpha);
	}
	else if(blendmode == 3) //Screen
	{
		return ((src + dst) - (src * dst)) * alpha + dst * (1.0 - alpha); 
	}
	else if(blendmode == 7) //Softlight
	{	
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
		return vec4(value, alpha) * alpha + dst * (1.0 - alpha);
	}
	else if(blendmode == 11) //Substract
    {
        return vec4((src - dst).rgb, alpha) * alpha + dst * (1.0 - alpha);
    }
    else if(blendmode == 12){ //special hardlight for liquify

		if (abs(src.x) + abs(src.y - 0.50) + abs(src.z - 0.50) < 0.01) return vec4(dst.xyz, alpha);

        if(src.rgb == dst.rgb){
            return dst;
        }
        else{
            vec3 value = vec3((src.x <= 0.5) ? (2.0 * src.x * dst.x) : (1.0 - 2.0 * (1.0 - src.x) * (1.0 - dst.x)),
                        (src.y <= 0.5) ? (2.0 * src.y * dst.y) : (1.0 - 2.0 * (1.0 - src.y) * (1.0 - dst.y)),
                        (src.z <= 0.5) ? (2.0 * src.z * dst.z) : (1.0 - 2.0 * (1.0 - src.z) * (1.0 - dst.z)));
            return vec4(value, alpha);
        }

    }
	else if(blendmode == 13) // color burn
	{
		vec3 value = dst.rgb;
		if(src.a != 0.0)
		{
		    value = vec3((src.x == 0.0) ? 0.0 : (1.0 - ((1.0 - dst.x) / src.x)),
			(src.y == 0.0) ? 0.0 : (1.0 - ((1.0 - dst.y) / src.y)),
			(src.z == 0.0) ? 0.0 : (1.0 - ((1.0 - dst.z) / src.z)));
		}

		return vec4(value, alpha);
	}
	else if(blendmode == 14) // color dodge
	{
		vec3 value = vec3((src.x == 1.0) ? 1.0 : min(1.0, dst.x / (1.0 - src.x)),
			(src.y == 1.0) ? 1.0 : min(1.0, dst.y / (1.0 - src.y)),
			(src.z == 1.0) ? 1.0 : min(1.0, dst.z / (1.0 - src.z)));

		return vec4(value, alpha);
	}
	
	return src;
}

/// <summary>
/// Fragment shader entry.
/// <summary>
void main ()
{
	// Get samples from both layers
	vec4 dst = texture2D(Sample0, vTextureCoord);
	vec4 src = texture2D(Sample1, vTextureCoord);
	
	if(blendmode == 0) //Normal or Layer
	{
		gl_FragColor = mix(dst, src, amount);
	}
	else if(blendmode == 9)
	{
		src.a *= alpha;
		
		gl_FragColor = mix(dst, src, src.a); //opacity
	}
	else if(blendmode == 10){
		vec4 colorMask = texture2D(maskTexture, vTextureCoord);
		gl_FragColor = dst * colorMask + src * (1.0 - colorMask);
	}
	else
	{
		src.a *= alpha;
		// Apply blend operation
		
		vec4 colour = vec4(0.0, 0.0, 0.0, 0.0);
		
		if(blendmode == 4) //darken
		{
			colour = min(src + (1.0 - src.a) * dst, dst + (1.0 - dst.a) * src);
		}
		else if(blendmode == 8) //Hardlight
		{
			vec3 value = vec3((src.x <= 0.50) ? (2.0 * src.x * dst.x) : (1.0 - 2.0 * (1.0 - src.x) * (1.0 - dst.x)),
				(src.y <= 0.50) ? (2.0 * src.y * dst.y) : (1.0 - 2.0 * (1.0 - src.y) * (1.0 - dst.y)),
				(src.z <= 0.50) ? (2.0 * src.z * dst.z) : (1.0 - 2.0 * (1.0 - src.z) * (1.0 - dst.z)));
			
			colour = vec4(value, src.a) * src.a + dst * (1.0 - src.a);
		}
		else if(blendmode == 6) //Overlay
		{
			vec3 value = vec3((dst.x <= 0.5) ? (2.0 * src.x * dst.x) : (1.0 - 2.0 * (1.0 - dst.x) * (1.0 - src.x)),
				(dst.y <= 0.5) ? (2.0 * src.y * dst.y) : (1.0 - 2.0 * (1.0 - dst.y) * (1.0 - src.y)),
				(dst.z <= 0.5) ? (2.0 * src.z * dst.z) : (1.0 - 2.0 * (1.0 - dst.z) * (1.0 - src.z)));
		
			colour = vec4(value, src.a) * src.a + dst * (1.0 - src.a);
		}
		else if(blendmode == 5) //Lighten
		{
			colour = vec4(max(dst, src).rgb, src.a) * src.a + dst * (1.0 - src.a);
		}
		else if(blendmode == 15) // difference
		{
			colour = abs(dst - src);
		}
		else
		{
			colour = clamp(blend(src, dst, blendmode, src.a), 0.0, 1.0);
		}
		colour = clamp(colour, 0.0, 1.0);

		//vec4 colour = clamp(blend(src, dst, blendmode), 0.0, 1.0);

		// Set fragment
		gl_FragColor.xyz = mix(dst, colour, amount).rgb;
		gl_FragColor.w = 1.0;

	}
}
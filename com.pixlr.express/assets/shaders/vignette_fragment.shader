precision highp float;

uniform $1$ uSampler;
uniform float size;
varying vec2 vTextureCoord;
uniform int colormode;

void main()
{
   vec4 color = texture2D(uSampler, vTextureCoord);
   
   float amount = 0.5;
   float vSize = size * 2.0; // Multiply by 2.0 to make the effect match the express flash version.
   
   float dist = distance(vTextureCoord, vec2(0.5, 0.5));
   if(colormode == 0)
   {
	   color.rgb *= smoothstep(0.8, vSize * 0.799, dist * (amount + vSize));
   }
   else
   {
	   float percent = smoothstep(0.5, 0.8, dist);
	   color = vec4(mix(color.rgb, vec3(1.0, 1.0, 1.0), percent), color.a);
   }

   gl_FragColor = color;
}
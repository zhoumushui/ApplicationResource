precision highp float;

uniform sampler2D texture;
uniform float amount;
uniform float size;
varying vec2 vTextureCoord;

void main()
{
   vec4 color = texture2D(texture, vTextureCoord);
   
   float dist = distance(vTextureCoord, vec2(0.5, 0.5));
   color.rgb *= smoothstep(0.8, size * 0.799, dist * (amount + size));

   gl_FragColor = color;
}
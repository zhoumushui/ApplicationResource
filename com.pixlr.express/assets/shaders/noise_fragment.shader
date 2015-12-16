precision highp float;

uniform sampler2D texture;
uniform float amount;
varying vec2 vTextureCoord;

float rand(vec2 co) {
   return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
   vec4 color = texture2D(texture, vTextureCoord);
    float diff = (rand(vTextureCoord) - 0.5) * amount * 0.5; // here multiply 0.5 in order to match the express flash version
   color.r += diff;
   color.g += diff;
   color.b += diff;
   
   gl_FragColor = color;
	
}
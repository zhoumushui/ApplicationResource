precision highp float;

uniform sampler2D uSampler;
uniform vec2 delta;
varying vec2 vTextureCoord;


float random(vec3 scale, float seed){
	return fract(sin(dot(gl_FragCoord.xyz + seed, scale)) * 43758.5453 + seed);
}

vec4 getBlurColor(){
	vec4 color = vec4(0.0);
	float total = 0.0;
	
	float offset = random(vec3(12.9898, 78.233, 151.7182), 0.0);
	
	for (float t = -20.0; t <= 20.0; t++) {
		float percent = (t + offset - 0.5) / 20.0;
		float weight = 1.0 - abs(percent);
		vec4 sample = texture2D(uSampler, vTextureCoord + delta * percent);
		
		color += sample * weight;
		total += weight;
	}
	
	color = color / total;
	
	return color;
}

void main(){

	float x = vTextureCoord.x;
	float y = vTextureCoord.y;
	
	gl_FragColor = getBlurColor();
}
precision highp float;

varying vec2 vTextureCoord;
uniform $1$ uSampler;

uniform float resolutionRate;
uniform int type;

vec4 getRadialGradientColor(){
	
	float centerX = 0.5;
	float centerY = 0.5 / resolutionRate;
	
	float x = vTextureCoord.x;
	float y = vTextureCoord.y / resolutionRate;
	
	float distance = sqrt((x - centerX) * (x - centerX) + (y - centerY) * (y - centerY));
	
	vec4 color;
	
	float innerRadius = 0.0;
	float outterRadius = 0.5;
	
	if(type == 0){
		innerRadius = 60.0 / 255.0;
		color = vec4(0.0, 0.0, 0.0, 1.0);
	}
	else if(type == 1){
		innerRadius = 50.0 / 255.0;
		color = vec4(0.0, 0.0, 0.0, 1.0);
	}
	
	if(distance < innerRadius){
		color = vec4(1.0, 1.0, 1.0, 1.0);
	}
	else if(distance <= outterRadius && distance >= innerRadius){
		float intensity = (distance - innerRadius) / (outterRadius - innerRadius);
		color = vec4(mix(color.rgb, vec3((1.0 - intensity), (1.0 - intensity), (1.0 - intensity)), (1.0 - intensity)), 1.0);
	}
		
	return color;
}

void main(void) {

	gl_FragColor = getRadialGradientColor();
  
}
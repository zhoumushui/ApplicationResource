precision highp float;

varying vec2 vTextureCoord;
uniform $1$ uSampler;

uniform float resolutionRate;
uniform int type;

bool InsideInnerRectancle(float x, float y){

	float innerRadius = 85.0 / (255.0 * 2.0);
	float rotation = -40.0 * 3.1415926 / 180.0;
	
	float centerX = 0.5;
	float centerY = 0.5 / resolutionRate;

	float rotate = 1.5707963 + rotation;
		
	float point1X = centerX - innerRadius * cos(rotate);
	float point1Y = centerY - innerRadius * sin(rotate);
	
	float point2X = centerX + innerRadius * cos(rotate);
	float point2Y = centerY + innerRadius * sin(rotate);
	
	//y - tan(-rotation) * x - point1Y + tan(-rotation) * point1X = 0; 
	//A = -tan(-rotation) B = 1, C = tan(-rotation) * pointX
	//Ax + By + C = 0;
	//y - tan(-rotation) * x - point2Y + tan(-rotation) * point2X = 0;
	//the distance of one point to the line: abs(Ax0 + By0 + C) /sqrt(A*A + B*B)
	
	float A = -tan(-rotation);
	float distance1 = abs(y - tan(-rotation) * x - point1Y + tan(-rotation) * point1X) / sqrt(1.0 + A * A);
	float distance2 = abs(y - tan(-rotation) * x - point2Y + tan(-rotation) * point2X) / sqrt(1.0 + A * A);
	
	if((distance1 + distance2) <= (innerRadius * 2.0))
		return true;
	else 
		return false;
}

bool InsideOutterRectancle(float x, float y){

	float outterRadius = 80.0 / 255.0 + 85.0 / (255.0 * 2.0);
	float rotation = -40.0 * 3.1415926 / 180.0;
	
	float centerX = 0.5;
	float centerY = 0.5 / resolutionRate;
	
	float rotate = 1.5707963 + rotation;
	
	float point1X = centerX - outterRadius * cos(rotate);
	float point1Y = centerY - outterRadius * sin(rotate);
	
	float point2X = centerX + outterRadius * cos(rotate);
	float point2Y = centerY + outterRadius * sin(rotate);
	
	//y - tan(-rotation) * x - point1Y + tan(-rotation) * point1X = 0; 
	//A = -tan(-rotation) B = 1, C = tan(-rotation) * pointX
	//Ax + By + C = 0;
	//y - tan(-rotation) * x - point2Y + tan(-rotation) * point2X = 0;
	//the distance of one point to the line: abs(Ax0 + By0 + C) /sqrt(A*A + B*B)
	
	float A = -tan(-rotation);
	float distance1 = abs(y - tan(-rotation) * x - point1Y + tan(-rotation) * point1X) / sqrt(1.0 + A * A);
	float distance2 = abs(y - tan(-rotation) * x - point2Y + tan(-rotation) * point2X) / sqrt(1.0 + A * A);
	
	if((distance1 + distance2) <= (outterRadius * 2.0))
		return true;
	else 
		return false;
}


vec4 getLinearGradientColor(){

	float x = vTextureCoord.x;
	float y = vTextureCoord.y / resolutionRate;
	float rotation = -40.0 * 3.1415926 / 180.0;
	
	vec4 color;
			
	if(InsideInnerRectancle(x, y)){
		color = vec4(1.0, 1.0, 1.0, 1.0);
	}
	else if(InsideOutterRectancle(x, y) && !InsideInnerRectancle(x, y)){
	
		float innerRadius = 85.0 / (255.0 * 2.0);
		float outterRadius = 80.0 / 255.0 + 85.0 / (255.0 * 2.0);
		float centerX = 0.5;
		float centerY = 0.5 / resolutionRate;
		
		float rotate = 1.5707963 - rotation;
	
		float point1X = centerX - innerRadius * cos(rotate);
		float point1Y = centerY - innerRadius * sin(rotate);
		
		float point2X = centerX + innerRadius * cos(rotate);
		float point2Y = centerY + innerRadius * sin(rotate);
		
		//y - tan(-rotation) * x - point1Y + tan(-rotation) * point1X = 0; 
		//A = -tan(-rotation) B = 1, C = tan(-rotation) * point1X - point1Y
		//Ax + By + C = 0;
		//y - tan(-rotation) * x - point2Y + tan(-rotation) * point2X = 0;
		//the distance of one point to the line: abs(Ax0 + By0 + C) /sqrt(A*A + B*B)
		
		float A = -tan(-rotation);
		float distance1 = abs(y - tan(-rotation) * x - point1Y + tan(-rotation) * point1X) / sqrt(1.0 + A * A);
		float distance2 = abs(y - tan(-rotation) * x - point2Y + tan(-rotation) * point2X) / sqrt(1.0 + A * A);
		
		if(distance1 >= distance2){
			float intensity = distance2 / (outterRadius - innerRadius);
			color = vec4((1.0 - intensity), (1.0 - intensity), (1.0 - intensity), 1.0);
		}
		else if(distance2 >= distance1){
			float intensity = distance1 / (outterRadius - innerRadius);
			color = vec4((1.0 - intensity), (1.0 - intensity), (1.0 - intensity), 1.0);
		}
	}
	else
		color = vec4(0.0, 0.0, 0.0, 0.0);
		
	return color;
}

void main(void) {

	gl_FragColor = getLinearGradientColor();
  
}
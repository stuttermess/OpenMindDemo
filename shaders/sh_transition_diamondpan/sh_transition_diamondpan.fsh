vec2 v_vTexcoord;
vec4 v_vColour;
uniform float progress;
void main(){
	float gridWidth = 28.0;
	float gridHeight = 15.0;
	int fadeType = 0;
	
	// Normalized pixel coordinates (from 0 to 1)
	vec2 uv = v_vTexcoord;
	float time = progress*3.5;
	float fadeTimer = mod(time,3.5) - 1.25;
	
	//Inverse the ranges so that the fade in animation is before the fade out animation
	if(fadeTimer > .5) fadeTimer -= 1.75;
	else fadeTimer += 1.75;
	
	vec4 outcol;
	//Scale the uvs to integers to scale directly with the equation.
	vec2 posI =  vec2(uv.x * gridWidth * 2.0,uv.y * gridHeight * 2.0);
	//modulo the position to clamp it to repeat the pattern.
	vec2 pos = mod(posI,2.0) - vec2(1.0,1.0);
	float size;
	
	posI = vec2(floor(posI.x/2.0)/gridWidth,floor(posI.y/2.0)/gridHeight); //Floor the values to round them to the value for the square they're in
	
	//switch(fadeType){
	//	case 0: //Vertical Fade
			size = pow(fadeTimer - posI.y,3.0);
	//		break;
	//	case 1: //Horizontal Fade
		//	size = pow(fadeTimer - posI.x,3.0);
	//		break;
	//	case 2: //Center Fade
		//	size = pow(fadeTimer - (abs(posI.x - 0.5) + abs(posI.y - 0.5)),3.0);
	//		break;
	//}
	
	//Get absolute value to keep in positive range
	size = abs(size);
	
	outcol = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	
	//Absolute value method for expressing the area of a rotatable square.
	if(abs(pos.x) + abs(pos.y) < size){
	    outcol =  vec4(0,0,0,1);
	}
	
	gl_FragColor = outcol;
	//gl_FragColor = vec4(1.0,1.0,1.0,1.0);
}
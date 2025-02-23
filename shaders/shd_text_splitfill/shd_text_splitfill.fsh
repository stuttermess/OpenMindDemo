//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform vec4 topFillColor;
uniform vec4 topOutlineColor;
uniform vec4 bottomFillColor;
uniform vec4 bottomOutlineColor;
uniform float yThreshold;
uniform float pixels_height;
void main()
{
	vec2 UV = v_vTexcoord;
	vec4 baseCol = v_vColour * texture2D( gm_BaseTexture, UV );
	vec4 outcol = baseCol;
	
	float real_yThreshold = yThreshold;//floor(yThreshold*(pixels_height))/(pixels_height);
	
	if (baseCol.a>0.0){
		if (UV.y > real_yThreshold){//bottom
			if (baseCol.r<0.01 && baseCol.g<0.01 && baseCol.b<0.01){//black: outline
				outcol = bottomOutlineColor;
			} else {//white: fill
				outcol = bottomFillColor;
			}
		} else {//top
			if (baseCol.r<0.01 && baseCol.g<0.01 && baseCol.b<0.01){//black: outline
				outcol = topOutlineColor;
			} else {//white: fill
				outcol = topFillColor;
			}
			//baseCol = vec4(UV, 1.0,1.0);
		}
		baseCol.a = 1.0;
	}
	gl_FragColor = outcol;
}
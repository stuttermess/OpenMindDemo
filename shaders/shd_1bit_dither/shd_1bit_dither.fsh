//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform vec2 textureSizePixels;//width and height *in pixels* of the texture used by the sprite
uniform vec2 ditherTextureSizePixels;//width and height *in pixels* of the texture used by the dither sprite
uniform vec4 textureUVs;//left+top, right+bottom uv coords for sprite
uniform sampler2D ditherTexture;//spr_dither_progression
uniform vec4 ditherUVs;//left+top, right+bottom uv coords for dither sprite
uniform int ditherStages;//should be sprite width divided by its height
uniform int cellSize;//height of spr_dither_progression in pixels. should be 8
uniform vec2 ditherOffset;
uniform float scale;
uniform vec4 lightColor;
uniform vec4 darkColor;
vec3 rgb2hsv(vec3 c)
{
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
	
	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
void main()
{
	vec4 baseCol = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	float baseAlpha = baseCol.a;
	
	//get value of fragment
	vec3 hsv = rgb2hsv(baseCol.rgb);
	float val = hsv.z;
	
	//check adjacent fragment values
	//pick the fragment with the biggest difference in value
	//push this fragment's value away from that value
	/*
	float biggestDiff = 0.0;
	float lowestDiff = 0.0;
	for(int xx=-1;xx<=1;xx++) {
	    int _x = xx;
	    for(int yy=-1;yy<=1;yy++) {
			int _y = yy;
			
			//get uv of fragment
			vec2 adjUV = v_vTexcoord;
			adjUV += ((1.0/textureSizePixels)*0.0001220703125);
			vec4 adjCol = v_vColour * texture2D( gm_BaseTexture, adjUV);
			vec3 adjHsv = rgb2hsv(adjCol.rgb);
			float adjVal = adjHsv.z;
			biggestDiff = max(biggestDiff, adjVal-val);
			lowestDiff = min(lowestDiff, adjVal-val);
		}
	}
	
	if (biggestDiff > -lowestDiff){
		if (biggestDiff > 0.3){
			val += (biggestDiff/5.0);
		}
	} else {
		if (lowestDiff < -0.3){
			val += (lowestDiff/5.0);
		}
	}
	*/
	
	//convert value to dither "stage"
	int stage = int((1.0-val)*float(ditherStages-1));
	
	vec2 oneTexturePixel = textureSizePixels;
	vec2 oneDitherPixel = ditherTextureSizePixels;
	
	//the width and height (in fragment, not pixels) of a single cell of the dither sprite in the texture page
	vec2 ditherCellSize = oneDitherPixel*float(cellSize);
	//uv coordinates of the current dither cell
	vec2 thisFuckinMultiplier = ((1.0/oneTexturePixel)*0.0001220703125)/scale;
	vec4 ditherCellUVs = vec4(ditherUVs.x, ditherUVs.y, ditherUVs.x+ditherCellSize.x, ditherUVs.y+ditherCellSize.y)+(vec4(ditherCellSize,ditherCellSize)*vec4(float(stage), 0.0,float(stage), 0.0));
	vec2 ditherTexcoord = ((v_vTexcoord-textureUVs.xy)*thisFuckinMultiplier)+(ditherOffset*oneDitherPixel);
	ditherTexcoord = mod(ditherTexcoord, ditherCellSize);
	ditherTexcoord = ditherTexcoord+ditherCellUVs.xy;
	
	vec4 ditherColor = texture2D(ditherTexture, ditherTexcoord);
	//gl_FragColor = texture2D(gm_BaseTexture, v_vTexcoord) * v_vColour;
	//gl_FragColor.a = min(gl_FragColor.a, ditherColor.r);
	vec4 outCol = ditherColor;
	if (outCol.r<0.5){
		outCol = darkColor;
	} else {
		outCol = lightColor;
	}
	//vec4 outCol = vec4(min(baseCol.r, ditherColor.r),min(baseCol.g, ditherColor.g),min(baseCol.b, ditherColor.b),min(baseCol.a, ditherColor.a));
	outCol.a = baseAlpha;
	gl_FragColor = outCol;
}
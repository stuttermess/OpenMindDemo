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
uniform int ditherStages;//should be dither sprite width divided by its height
uniform int cellSize;//height of spr_dither_progression in pixels. should be 8
uniform int stage;//0-ditherStages
uniform vec2 ditherOffset;
uniform bool invert;
uniform vec2 scale;
void main()
{
	/*
		Color of texture at pixel coord:
		gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
		
		if corresponding pixel of ditherTexture is black, drop alpha
	*/
	//ivec2 textureSize = textureSize2D(gm_BaseTexture);
	
	
	//gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
	
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
	
	/*
	vec2 ditherTexcoord = ((v_vTexcoord-textureUVs.xy)/1.0)+ditherUVs.xy;
	gl_FragColor.xy = ditherTexcoord;
	gl_FragColor.b = 0.0;
	gl_FragColor.a = 1.0;
	*/
	/*
	vec2 texturePixelPos = (v_vTexcoord-textureUVs.xy)/oneTexturePixel;
	vec2 ditherPixelPos = mod(texturePixelPos, float(cellSize));
	
	gl_FragColor = vec4(0.0,0.0,0.0,1.0);
	gl_FragColor.xy = ditherPixelPos/1.0;
	*/
	
	vec4 ditherColor = texture2D(ditherTexture, ditherTexcoord);
	if (invert){
		ditherColor.rgb = 1.0-ditherColor.rgb;
	}
	gl_FragColor = texture2D(gm_BaseTexture, v_vTexcoord) * v_vColour;
	gl_FragColor.a = min(gl_FragColor.a, ditherColor.r);
	//gl_FragColor = ditherColor;
}
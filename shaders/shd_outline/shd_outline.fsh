varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform vec2 textureSizePixels;//width and height *in pixels* of the texture used by the sprite
uniform vec4 textureUVs;//left+top, right+bottom uv coords for sprite
uniform vec4 Color;
uniform int Size;//outline size
uniform int useCorners;//whether or not to include corners in the outline
uniform float alphaThreshold;
void main()
{
	/*
	  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10,
	 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,
	 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32,
	 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43,
	 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54,
	 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65,
	 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76,
	 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87,
	 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98,
	 99,100,101,102,103,104,105,106,107,108,109,
	110,111,112,113,114,115,116,117,118,119,120
	
	right=+1
	left=-1
	up=-gridSize
	down=+gridSize
	
	first, step from the center Size times (meaning, repeat times the Size variable)
	diagonal pixels are counted as 2 pixels away
	if Corners==true, diagonal pixels are counted as 1 pixel away
	
	without corners
	0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,1,0,0,0,0,0,
	0,0,0,0,1,2,1,0,0,0,0,
	0,0,0,1,2,3,2,1,0,0,0,
	0,0,0,0,1,2,1,0,0,0,0,
	0,0,0,0,0,1,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0
	3 = 12
	
	0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,1,0,0,0,0,0,
	0,0,0,0,1,2,1,0,0,0,0,
	0,0,0,1,2,3,2,1,0,0,0,
	0,0,1,2,3,4,3,2,1,0,0,
	0,0,0,1,2,3,2,1,0,0,0,
	0,0,0,0,1,2,1,0,0,0,0,
	0,0,0,0,0,1,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0
	4 = 25
	
	0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,1,0,0,0,0,0,
	0,0,0,0,1,2,1,0,0,0,0,
	0,0,0,1,2,3,2,1,0,0,0,
	0,0,1,2,3,4,3,2,1,0,0,
	0,1,2,3,4,5,4,3,2,1,0,
	0,0,1,2,3,4,3,2,1,0,0,
	0,0,0,1,2,3,2,1,0,0,0,
	0,0,0,0,1,2,1,0,0,0,0,
	0,0,0,0,0,1,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0
	5 = 41
	
	0,0,0,0,0,1,0,0,0,0,0,
	0,0,0,0,1,2,1,0,0,0,0,
	0,0,0,1,2,3,2,1,0,0,0,
	0,0,1,2,3,4,3,2,1,0,0,
	0,1,2,3,4,5,4,3,2,1,0,
	1,2,3,4,5,6,5,4,3,2,1,
	0,1,2,3,4,5,4,3,2,1,0,
	0,0,1,2,3,4,3,2,1,0,0,
	0,0,0,1,2,3,2,1,0,0,0,
	0,0,0,0,1,2,1,0,0,0,0,
	0,0,0,0,0,1,0,0,0,0,0
	6 = 61
	
	with corners
	0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,1,1,1,1,1,0,0,0,
	0,0,0,1,2,2,2,1,0,0,0,
	0,0,0,1,2,3,2,1,0,0,0,
	0,0,0,1,2,2,2,1,0,0,0,
	0,0,0,1,1,1,1,1,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,
	
	
	if a pixel within the range passes or matches the alpha threshold,
	then color the subject pixel (it's part of the outline)
	*/
	
	vec2 oneTexturePixel = textureSizePixels;
	vec2 thisFuckinMultiplier = ((1.0/oneTexturePixel)*0.0001220703125);
	
	gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
	
	if (gl_FragColor.a < alphaThreshold){
		bool isOutline = false;
		//If using corners, test pixels in a square range from the subject pixel
		//If not using corners, test pixels cascading out from the subject pixel, in a diamond pattern
		int _x,_y;
		for (int _x=-Size; _x<=Size; _x++){
			for (int _y=-Size; _y<=Size; _y++){
				if ( isOutline ) break;
				
				float float_x = float(_x);
				float float_y = float(_y);
				
				//corners (Chebyshev distance)
				int dist = int( max(abs(float_x), abs(float_y)) );
				
				if (useCorners<=0){//no corners (taxicab distance)
					dist = int( abs(float_x) + abs(float_y) );
				}
				
				vec2 testTexCoord = v_vTexcoord+(vec2(_x,_y)*oneTexturePixel);
				testTexCoord.x = clamp(testTexCoord.x, textureUVs.r, textureUVs.b);
				testTexCoord.y = clamp(testTexCoord.y, textureUVs.g, textureUVs.a);
				vec4 testCol = texture2D(gm_BaseTexture, testTexCoord);
				float testAlpha = testCol.a;
				
				isOutline = (testAlpha >= alphaThreshold && dist <= Size);
			}
		}
		
		if (isOutline){
			gl_FragColor = Color;
		}
	}
}
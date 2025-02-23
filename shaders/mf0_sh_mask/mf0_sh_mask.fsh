//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
void main()
{
	vec4 pixelcol = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	
	if (pixelcol.r >= 1.) {
		pixelcol.a = 0.;
	}
	
    gl_FragColor = pixelcol;
}
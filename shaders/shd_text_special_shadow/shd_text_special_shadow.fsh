//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform vec4 Color;
void main()
{
	vec4 baseCol = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	vec4 col = Color;
	col.a = baseCol.a;
	gl_FragColor = col;
}
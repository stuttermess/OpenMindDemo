varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float lerp;
void main()
{
	vec4 col = texture2D( gm_BaseTexture, v_vTexcoord );
    gl_FragColor = v_vColour * col;//mix(col, vec4(col.rgb,0.0), 0.0);
}
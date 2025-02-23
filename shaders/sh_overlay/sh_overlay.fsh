varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform sampler2D TextureBlend;
uniform sampler2D TextureBase;
float overlay( float S, float D ) {
	return float( D > 0.5 ) * ( 2.0 * (S + D - D * S ) - 1.0 )
	+ float( D <= 0.5 ) * ( ( 2.0 * D ) * S );
}
void main() {
	vec2 tex = v_vTexcoord;
	vec4 baseCol = texture2D(TextureBase, tex);
	vec4 blendCol = texture2D(TextureBlend, tex);
	vec4 final = vec4(
	overlay(baseCol.r, blendCol.r),
	overlay(baseCol.g, blendCol.g),
	overlay(baseCol.b, blendCol.b),
	min(baseCol.a, blendCol.a));
    gl_FragColor = v_vColour * final;
}
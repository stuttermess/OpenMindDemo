/*////////////////////////////////////////////////////////////////////////
	SMF animation fragment shader
	This is the standard shader that comes with the SMF system.
	This does some basic diffuse, specular and rim lighting.
*/////////////////////////////////////////////////////////////////////////
varying vec2 v_vTexcoord;
varying vec3 v_eyeVec;
varying vec3 v_vNormal;
varying float v_vRim;
varying vec4 v_vColour;
varying vec3 v_worldPosition;
uniform vec3 v_cameraPosition;
void main() {
    vec4 startColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord);
	
	gl_FragColor = startColor;
}
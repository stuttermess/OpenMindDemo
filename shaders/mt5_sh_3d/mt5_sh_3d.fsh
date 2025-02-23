/*////////////////////////////////////////////////////////////////////////
	SMF animation fragment shader
	This is the standard shader that comes with the SMF system.
	This does some basic diffuse, specular and rim lighting.
*/////////////////////////////////////////////////////////////////////////
varying vec2 v_vTexcoord;
varying vec3 v_eyeVec;
varying vec3 v_vNormal;
varying float v_vRim;
varying vec3 v_worldPosition;
uniform vec3 v_cameraPosition;
uniform float darkness;
void main() {
    vec4 startColor = texture2D(gm_BaseTexture, v_vTexcoord);
	
	//fog
	vec3 fogOrigin = v_cameraPosition;
	vec4 fogColor = vec4(vec3(-1.), 1.);
	
	float fogStart = 20.;
	float fogEnd = 75.;
	
	float dist = length(v_worldPosition - fogOrigin);
	
	float fraction = clamp((dist - fogStart) / (fogEnd - fogStart), 0., 1.);
	
	vec4 finalColor = mix(startColor, fogColor, fraction);
	
	//Diffuse shade
	finalColor.rgb *= .5 + .7 * max(dot(v_vNormal, normalize(vec3(1.))), 0.);
	
	//Specular highlights
	finalColor.rgb += .1 * pow(max(dot(normalize(reflect(v_eyeVec, v_vNormal)), normalize(vec3(1.))), 0.), 4.);
	
	//Rim lighting
	finalColor.rgb += .1 * vec3(pow(1. + v_vRim, 2.));
	
	finalColor.rgb -= darkness;
	
	
	gl_FragColor = finalColor;
	
}
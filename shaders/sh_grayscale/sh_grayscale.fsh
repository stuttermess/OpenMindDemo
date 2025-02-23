//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float u_saturation;
void main()
{
	vec4 tex = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord);
	
	float gray = dot(tex, vec4(0.299, 0.587, 0.114, 0.0));
	
	vec4 shade = vec4(gray, gray, gray, tex.a);
	gl_FragColor = mix(shade, tex, u_saturation);
}
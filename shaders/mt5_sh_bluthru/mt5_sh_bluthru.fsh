//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 _p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(_p - K.xxx, 0.0, 1.0), c.y);
}
void main()
{
	vec4 baseCol = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	//vec3 hsv = rgb2hsv(vec3(baseCol.r,baseCol.g,baseCol.b));
    if (abs(baseCol.r-baseCol.g)<0.01 && abs(baseCol.r-baseCol.b)<0.01){
		gl_FragColor = vec4(0.0,0.0,0.0,0.0);
	} else {
		vec3 hsv = rgb2hsv(vec3(baseCol.r,baseCol.g,baseCol.b));
		hsv.y = 1.0;
		hsv.z = 1.0;
		vec3 _rgb = hsv2rgb(hsv);
		gl_FragColor = vec4(_rgb.x,_rgb.y,_rgb.z, 1.0);
	}
}
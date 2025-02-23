varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform sampler2D TextureBlend;
uniform sampler2D TextureBase;
vec4 hardLight( vec4 target, vec4 blend ) {
	vec4 temp;
    temp.x = (blend.x > 0.5) ? (1.0-(1.0-target.x)*(1.0-2.0*(blend.x-0.5))) : (target.x * (2.0*blend.x));
    temp.y = (blend.y > 0.5) ? (1.0-(1.0-target.y)*(1.0-2.0*(blend.y-0.5))) : (target.y * (2.0*blend.y));
    temp.z = (blend.z > 0.5) ? (1.0-(1.0-target.z)*(1.0-2.0*(blend.z-0.5))) : (target.z * (2.0*blend.z));
	temp.a = blend.a;
    return temp;
}
void main(){
	vec2 tex = v_vTexcoord;
	vec4 final = hardLight(texture2D(TextureBase, tex), texture2D(TextureBlend, tex));
	
    gl_FragColor = v_vColour * final;
}
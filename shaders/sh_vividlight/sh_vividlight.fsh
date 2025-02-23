varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform sampler2D TextureBlend;
uniform sampler2D TextureBase;
vec4 vividlight (vec4 target, vec4 blend){
	vec4 temp;
    temp.x = (target.x < 0.5) ? 1.0 - (1.0 - blend.x) / (2.0 * target.x) : blend.x / (2.0 * (1.0 - target.x));
    temp.y = (target.y < 0.5) ? 1.0 - (1.0 - blend.y) / (2.0 * target.y) : blend.y / (2.0 * (1.0 - target.y));
    temp.z = (target.z < 0.5) ? 1.0 - (1.0 - blend.z) / (2.0 * target.z) : blend.z / (2.0 * (1.0 - target.z));
	//temp.a = (target.a < 0.5) ? 1.0 - (1.0 - blend.a) / (2.0 * target.a) : blend.a / (2.0 * (1.0 - target.a));
	temp.a = 1.0;
    return temp;
}
void main(){
	vec2 tex = v_vTexcoord;
	vec4 final = vividlight(texture2D(TextureBase, tex), texture2D(TextureBlend, tex));
    gl_FragColor = v_vColour * final;
}
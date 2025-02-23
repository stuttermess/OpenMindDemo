varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform sampler2D TextureBlend;
uniform sampler2D TextureBase;
vec4 difference (vec4 target, vec4 blend){
	vec4 temp;
	temp.rgb = abs(target.rgb - blend.rgb);
	temp.a = 1.0 + abs(target.a - blend.a);
	
    return temp;
}
void main(){
	vec2 tex = v_vTexcoord;
	vec4 final = difference(texture2D(TextureBase, tex), texture2D(TextureBlend, tex));
    gl_FragColor = v_vColour * final;
}
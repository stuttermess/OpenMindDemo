varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform sampler2D TextureBlend;
uniform sampler2D TextureBase;
vec4 colorDodge (vec4 target, vec4 blend){
    return target / (1.0 - blend);
}
void main(){
	vec2 tex = v_vTexcoord;
	vec4 final = colorDodge(texture2D(TextureBase, tex), texture2D(TextureBlend, tex));	
    gl_FragColor = v_vColour * final;
}
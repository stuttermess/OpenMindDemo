varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform sampler2D TextureBlend;
uniform sampler2D TextureBase;
vec4 hardmix (vec4 target, vec4 blend){
	vec4 col;
	
	col.rgb = floor(target.rgb + blend.rgb);
	col.a = blend.a;
	
    return col;  
}
void main(){
	vec2 tex = v_vTexcoord;
	vec4 final = hardmix(texture2D(TextureBase, tex), texture2D(TextureBlend, tex));
	
    gl_FragColor = v_vColour * final;
}
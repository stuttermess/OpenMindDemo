varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform sampler2D TextureBlend;
uniform sampler2D TextureBase;
vec4 colorburn(vec4 target, vec4 blend){
	vec4 temp;
	temp = 1.0 - (1.0 - target) / blend;
	//temp.a = blend.a;
    return temp;  
}
void main(){
	vec2 tex = v_vTexcoord;
	vec4 final = colorburn(texture2D(TextureBase, tex), texture2D(TextureBlend, tex));
	
    gl_FragColor = v_vColour * final;
}
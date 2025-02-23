varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform sampler2D TextureBlend;
uniform sampler2D TextureBase;
vec4 subtract(vec4 target, vec4 blend){
	vec4 temp;
	temp.rgba = target.rgba * blend.rgba;
	//temp.a = blend.a;
    return temp;  
}
void main(){
	vec2 tex = v_vTexcoord;
	vec4 final = subtract(texture2D(TextureBase, tex), texture2D(TextureBlend, tex));
	
    gl_FragColor = v_vColour * final;
}
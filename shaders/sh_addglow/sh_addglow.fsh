varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform sampler2D TextureBlend;
uniform sampler2D TextureBase;
vec4 addglow (vec4 target, vec4 blend){
	vec4 temp;
	temp = (target + blend);
	temp.a = ceil(temp.a);
    return temp;  
}
void main(){
	vec2 tex = v_vTexcoord;
	vec4 final = addglow(texture2D(TextureBase, tex), texture2D(TextureBlend, tex));
	
    gl_FragColor = v_vColour * final;
}
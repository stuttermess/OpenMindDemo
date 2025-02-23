//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float PixelsCount;
uniform vec4 Texture;
vec2 mapUV(vec2 UV)
{
    return (UV-Texture.xy)/(Texture.zw-Texture.xy);
}
vec2 spriteUV(vec2 UV)
{
    return UV*(Texture.zw-Texture.xy)+Texture.xy;
}
vec2 PixelsUV(vec2 uv, float pixelsCount){
	if (pixelsCount < 1.0) return uv;
    return floor(uv * pixelsCount) / pixelsCount;
}
void main(){
    gl_FragColor = texture2D(gm_BaseTexture, spriteUV(PixelsUV(mapUV(v_vTexcoord), PixelsCount))) * v_vColour;
}
//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform float Time;
uniform vec2 Texel;
uniform vec4 TexPos;
uniform float Xspeed;
uniform float Xfreq;
uniform float Xsize;
uniform float Yspeed;
uniform float Yfreq;
uniform float Ysize;
/*
const float Xspeed = 0.10;
const float Xfreq = 200.0;
const float Xsize = 5.0;
const float Yspeed = 0.01;
const float Yfreq = 20.0;
const float Ysize = 0.0;
*/
void main()
{
	//X wave
	float Xwave = sin(Time*Xspeed + v_vTexcoord.y*Xfreq) * (Xsize*Texel.x) * 1.0;
	//Y wave
	float Ywave = sin(Time*Yspeed + v_vTexcoord.x*Yfreq) * (Ysize*Texel.y) * 1.0;
	
	vec2 texcord = v_vTexcoord + vec2(Xwave, Ywave);
	if (texcord.x < TexPos.r) {texcord.x += Texel.x;}
	if (texcord.x > TexPos.b) {texcord.x -= Texel.x;}
	if (texcord.y < TexPos.g) {texcord.y += Texel.y;}
	if (texcord.y > TexPos.a) {texcord.y -= Texel.y;}
	
    gl_FragColor = v_vColour * texture2D( gm_BaseTexture, texcord);
}
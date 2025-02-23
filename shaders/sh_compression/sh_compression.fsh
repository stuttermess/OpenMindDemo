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
uniform float Xoffset;
uniform float Yoffset;
uniform float TexXoffset;
uniform float TexYoffset;
const float PI = 3.14159265359;
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
	float Xwave = Xsize * sin((Xfreq * v_vTexcoord.x) + (Xspeed * Time));
	//Y wave
	float Ywave = Ysize * sin((Yfreq * v_vTexcoord.y) + (Yspeed * Time));
	
	
	
	vec2 texcord = v_vTexcoord + vec2(Xwave + Xoffset, Ywave + Yoffset);
	if (texcord.x < TexPos.r) {texcord.x += Texel.x;}
	if (texcord.x > TexPos.b) {texcord.x -= Texel.x;}
	if (texcord.y < TexPos.g) {texcord.y += Texel.y;}
	if (texcord.y > TexPos.a) {texcord.y -= Texel.y;}
	
	texcord += vec2(TexXoffset,TexYoffset);
	
    gl_FragColor = v_vColour * texture2D( gm_BaseTexture, texcord);
}
//amplitude * sin((frequency * UV.y) + (speed * TIME));
//amplitude_vertical * sin((frequency_vertical * UV.y)  + (speed_vertical * TIME));
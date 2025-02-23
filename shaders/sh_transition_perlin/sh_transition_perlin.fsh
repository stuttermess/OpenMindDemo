// Author: Rich Harris
// License: MIT
/*
#ifdef GL_ES
precision mediump float;
#endif
*/
//attribute vec4 in_Colour;
//attribute vec2 in_TextureCoord;
varying vec2 v_vTexcoord;
varying vec4 v_vColour;
//int xmod;
//int ymod;
uniform float scale; // = 4.0
uniform float seed; // = 12.9898
uniform float time;
uniform float resolution;
uniform vec4 color;
// http://byteblacksmith.com/improvements-to-the-canonical-one-liner-glsl-rand-for-opengl-es-2-0/
float random(vec2 co)
{
	highp float _a = seed;
	highp float _b = 78.233;
	highp float _c = 43758.5453;
	highp float dt= dot(co.xy ,vec2(_a,_b));
	highp float sn= mod(dt,3.14);
	return fract(sin(sn) * _c);
}
// 2D Noise based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (vec2 st) {
	vec2 i = floor(st);
	vec2 f = fract(st);
	
	// Four corners in 2D of _a tile
	float _a = random(i);
	float _b = random(i + vec2(1.0, 0.0));
	float _c = random(i + vec2(0.0, 1.0));
	float _d = random(i + vec2(1.0, 1.0));
	
	// Cubic Hermine Curve.  Same as SmoothStep()
	vec2 u = f*f*(3.0-2.0*f);
	
	// Mix 4 coorners porcentages
	return mix(_a, _b, u.x) +
			((_c - _a)* u.y * (1.0 - u.x)) +
			((_d - _b) * u.x * u.y);
}
void main(){
	vec2 uv = (floor((v_vTexcoord * 480.0) * resolution) / resolution) / 480.0;
	vec4 from = texture2D( gm_BaseTexture, uv );
	vec4 to = vec4(color.r,color.g,color.b,1.0);
	float n = noise(uv * scale);
	
	float _p = mix(0.0, 1.0, time);
	float _q = smoothstep(_p, _p, n);
	/*
	if (_q==0.0){
		vec2 adjacent_uv;
		to = vec4(1.0-color.r,1.0-color.g,1.0-color.b,1.0);
		for (xmod=0; (xmod<3) && (_q==0.0); xmod++){
			for (ymod=0; (ymod<3) && (_q==0.0); ymod++){
				adjacent_uv = uv+vec2(float(xmod-1)/480.0, float(ymod-1)/270.0);
				n = noise(adjacent_uv * scale);
				_q = smoothstep(_p, _p, n);
			}
		}
	}
	*/
	gl_FragColor = mix(to, from, _q);
}
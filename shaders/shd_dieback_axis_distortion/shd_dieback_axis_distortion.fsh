varying vec2 v_vTexcoord;
varying vec4 v_vColour;
uniform ivec2 tex_size;
uniform vec2 tex_offset;
uniform int palette_enabled;
uniform sampler2D palette_texture;
uniform float palette_index;
uniform ivec2 axis_mode;
uniform ivec2 axis_frequency;
uniform ivec2 axis_amplitude;
uniform vec2 axis_shift;
/*
#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position)
{
    vec4 transformed = transform_projection * vertex_position;
    return transformed;
}
#endif
*/
//#ifdef PIXEL
const float PI = 3.1415926538;
//x vec2 is X, Y
//y vec2 is Y, X
int distort(int d_mode, ivec2 i_position, int i_frequency, int i_amplitude, float i_shift)
{
	float f_frequency = float(i_frequency);
	float f_amplitude = float(i_amplitude);
	float f_shift = float(i_shift);
	vec2 f_position = vec2(float(i_position.x), float(i_position.y));
		
    int offset_pos = 0;
    if(d_mode == 0) { //oscillation
        offset_pos = int(f_amplitude * sin( ((1.0/f_frequency)*PI) * (f_position.y + f_shift) ));
    }
    if(d_mode == 1) { //interlaced
        if(mod(f_position.y,2.0) == 0.0) {
            offset_pos = -int(f_amplitude * sin( ((1.0/f_frequency)*PI) * (f_position.y + f_shift) ));
        } else {
            offset_pos = int(f_amplitude * sin( ((1.0/f_frequency)*PI) * (f_position.y + f_shift) ));
        }
    }
    if(d_mode == 2) { //compression
        offset_pos = int(f_amplitude * sin( ((1.0/f_frequency)*PI) * (f_position.x + f_shift) ));
    }
    if(d_mode == 3) { //linear scaling
        offset_pos = int( (f_position.x+f_shift)*(f_amplitude/f_frequency) );
    }
	//offset_pos = 3;
    return offset_pos;
}
vec4 effect(vec4 color, sampler2D tex, vec2 texture_coords, vec2 screen_coords)
{
    ivec2 distortion = ivec2(
        distort(axis_mode.x, ivec2(texture_coords.x,texture_coords.y), axis_frequency.x, axis_amplitude.x,axis_shift.x),
        distort(axis_mode.y, ivec2(texture_coords.y,texture_coords.x), axis_frequency.y, axis_amplitude.y,axis_shift.y)
    );
	
	vec2 f_distortion = vec2(float(distortion.x), float(distortion.y))*100.0;
	vec2 i_tex_size = vec2(float(tex_size.x),float(tex_size.y));
    vec4 base_color = texture2D(tex, ((texture_coords+tex_offset+f_distortion)/i_tex_size));
    if (palette_enabled>0) {
        base_color = texture2D(palette_texture,vec2(base_color.r,palette_index));
    }
	
    return color * base_color;
}
//#endif
void main()
{
	//gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	gl_FragColor = effect(v_vColour, gm_BaseTexture, v_vTexcoord, vec2(0.0,0.0));
}
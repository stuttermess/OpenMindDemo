function dieback_instance() constructor
{
    layers = [];
    width = 480;
    height = 270;
    time = 0;
    surface = -1;
    
    tick = function()
    {
        time += (delta_time / 1000000);
    };
    
    draw = function(arg0, arg1)
    {
        var _wid = width;
        var _hei = height;
        if (!surface_exists(surface))
        {
            surface = surface_create(_wid, _hei);
        }
        var _targ = surface_get_target();
        if (_targ != application_surface && _targ >= 0)
        {
            surface_reset_target();
        }
        surface_set_target(surface);
        draw_clear(c_black);
        surface_reset_target();
        if (_targ != application_surface && _targ >= 0)
        {
            surface_set_target(_targ);
        }
        for (var i = 0; i < array_length(layers); i++)
        {
            var layer_final_sf = -1;
            var time = self.time;
            
            var wrap = function(arg0, arg1, arg2)
            {
                if (arg1 == arg2)
                {
                    return arg1;
                }
                if (arg0 > arg2)
                {
                    arg0 -= arg1;
                    arg0 %= (arg2 - arg1);
                    arg0 += arg1;
                }
                else if (arg0 < arg1)
                {
                    while (arg0 < arg1)
                    {
                        arg0 += (arg2 - arg1);
                    }
                }
                return arg0;
            };
            
            _targ = surface_get_target();
            if (_targ != application_surface && _targ >= 0)
            {
                surface_reset_target();
            }
            with (layers[i])
            {
                if (!surface_exists(surfaces[0]))
                {
                    surfaces[0] = surface_create(_wid, _hei);
                }
                surface_set_target(surfaces[0]);
                draw_clear_alpha(c_black, 0);
                var _sprite_x = sprite_get_xoffset(sprite);
                var _sprite_y = sprite_get_yoffset(sprite);
                var _shd = shd_dieback_axis_distortion;
                shader_set(_shd);
                var _u_tex_size = shader_get_uniform(_shd, "tex_size");
                var _u_tex_offset = shader_get_uniform(_shd, "tex_offset");
                var _u_palette_enabled = shader_get_uniform(_shd, "palette_enabled");
                var _u_axis_mode = shader_get_uniform(_shd, "axis_mode");
                var _u_axis_frequency = shader_get_uniform(_shd, "axis_frequency");
                var _u_axis_amplitude = shader_get_uniform(_shd, "axis_amplitude");
                var _u_axis_shift = shader_get_uniform(_shd, "axis_shift");
                var _sprite_tex = sprite_get_texture(sprite, 0);
                var _tex_width = texture_get_width(_sprite_tex);
                var _tex_height = texture_get_height(_sprite_tex);
                shader_set_uniform_i_array(_u_tex_size, [_tex_width, _tex_height]);
                var real_offset = 
                {
                    x: 0,
                    y: 0
                };
                real_offset.x = -offset.x;
                real_offset.y = -offset.y;
                if (string_lower(offset_mode) == "scrolling")
                {
                    real_offset.x = time * -offset.x;
                    real_offset.y = time * -offset.y;
                }
                var axis_offset_arr = [wrap(real_offset.x, 0, frequency.x * 2), wrap(real_offset.y, 0, frequency.y * 2)];
                shader_set_uniform_f_array(_u_tex_offset, axis_offset_arr);
                shader_set_uniform_i(_u_palette_enabled, 0);
                var real_shift = 
                {
                    x: 0,
                    y: 0
                };
                real_shift.x = -shift_offset.x;
                real_shift.y = -shift_offset.y;
                if (string_lower(shift_mode) == "scrolling")
                {
                    real_shift.x = time * -shift_offset.x;
                    real_shift.y = time * -shift_offset.y;
                }
                var axis_shift_arr = [wrap(real_shift.x, 0, frequency.x * 2), wrap(real_shift.y, 0, frequency.y * 2)];
                shader_set_uniform_i_array(_u_axis_mode, [distortion.x, distortion.y]);
                shader_set_uniform_i_array(_u_axis_frequency, [frequency.x, frequency.y]);
                shader_set_uniform_i_array(_u_axis_amplitude, [amplitude.x, amplitude.y]);
                shader_set_uniform_f_array(_u_axis_shift, axis_shift_arr);
                draw_sprite_tiled(sprite, 0, _sprite_x, _sprite_y);
                draw_text(5, 5, axis_shift_arr);
                shader_reset();
                surface_reset_target();
                layer_final_sf = surfaces[0];
            }
            surface_set_target(surface);
            draw_surface(layer_final_sf, 0, 0);
            surface_reset_target();
        }
        if (_targ != application_surface && _targ >= 0)
        {
            surface_set_target(_targ);
        }
        draw_surface(surface, arg0, arg1);
    };
    
    cleanup = function()
    {
        if (surface_exists(surface))
        {
            surface_free(surface);
        }
        for (var i = 0; i < array_length(layers); i++)
        {
            var _layer = layers[i];
            for (var j = 0; j < array_length(_layer.surfaces); j++)
            {
                var _sf = _layer.surfaces[j];
                if (surface_exists(_sf))
                {
                    surface_free(_sf);
                }
            }
        }
    };
}

function __dieback_layer_instance() constructor
{
    sprite = spr_none;
    surfaces = [-1, -1];
    blend_mode = 1;
    opacity = 1;
    offset_mode = "Static";
    offset = 
    {
        x: 0,
        y: 0
    };
    distortion = 
    {
        x: 0,
        y: 0
    };
    frequency = 
    {
        x: 0,
        y: 0
    };
    amplitude = 
    {
        x: 0,
        y: 0
    };
    shift_mode = "Static";
    shift_offset = 
    {
        x: 0,
        y: 0
    };
    plane_distort = 1;
    plane_amplitude = 0;
}

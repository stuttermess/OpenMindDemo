function draw_text_special(arg0, arg1, arg2, arg3 = {}, arg4 = 1, arg5 = 1, arg6 = 0)
{
    var effects = 
    {
        splitfill: 
        {
            active: false,
            threshold: 0.4166666666666667,
            top_color: 16777215,
            bottom_color: 16777215,
            y_threshold: 0.4166666666666667,
            outline_top_color: -1,
            outline_bottom_color: -1
        },
        outline: 
        {
            active: false,
            color: 0,
            width: 1,
            smooth: false,
            extra_layers_amount: 0,
            layers: [
            {
                color: 0,
                width: 1,
                smooth: false
            }]
        },
        shadow: 
        {
            active: false,
            color: 0,
            x: 0,
            y: 1
        }
    };
    var active_effects_count = 0;
    var _ef_names = struct_get_names(effects);
    for (var i = 0; i < array_length(_ef_names); i++)
    {
        var _ef_name = _ef_names[i];
        if (struct_exists(arg3, _ef_name))
        {
            effects = struct_merge(effects, arg3, true, true, false);
            struct_get(effects, _ef_name).active = true;
            active_effects_count++;
        }
    }
    if (effects.splitfill.outline_top_color == -1)
    {
        effects.splitfill.outline_top_color = effects.outline.color;
    }
    if (effects.splitfill.outline_bottom_color == -1)
    {
        effects.splitfill.outline_bottom_color = effects.outline.color;
    }
    var fontscale = 1;
    var yoff = 0;
    switch (draw_get_font())
    {
        case fnt_pinch:
            fontscale = 2;
            yoff = 1;
            effects.splitfill.y_threshold += 0.2;
            break;
    }
    arg4 /= fontscale;
    arg5 /= fontscale;
    if (active_effects_count == 1)
    {
        if (effects.shadow.active)
        {
            _col = draw_get_color();
            draw_set_color(effects.shadow.color);
            draw_text(arg0 + effects.shadow.x, arg1 + effects.shadow.y, arg2);
            draw_set_color(_col);
            draw_text(arg0, arg1, arg2);
            exit;
        }
    }
    if (effects.outline.active && effects.splitfill.active && effects.shadow.active)
    {
        var lalala = 0;
    }
    var sf_w = string_width(arg2);
    var sf_h = string_height(arg2);
    if (effects.outline.active)
    {
        var combined_outline_w = 0;
        combined_outline_w += (effects.outline.width * 2);
        for (var i = 0; i < effects.outline.extra_layers_amount; i++)
        {
            var _layer = effects.outline.layers[i];
            combined_outline_w += ((_layer.width * 2) / fontscale);
        }
        combined_outline_w /= fontscale;
        sf_w += combined_outline_w;
        sf_h += combined_outline_w;
    }
    sf_w += 2;
    sf_w *= arg4;
    sf_h *= arg5;
    sf_w = ceil(sf_w / arg4) * arg4;
    sf_h = ceil(sf_h / arg5) * arg5;
    var _sf = surface_create(sf_w, sf_h);
    var _col = draw_get_color();
    var _halign = draw_get_halign();
    var _valign = draw_get_valign();
    
    var _draw_text = function(arg0, arg1, arg2, arg3, arg4 = 1, arg5 = 1, arg6 = 0)
    {
        var _col = draw_get_color();
        if (arg3.splitfill.active)
        {
            draw_set_color(c_white);
        }
        draw_text_transformed(arg0, arg1, arg2, arg4, arg5, arg6);
        draw_set_color(_col);
    };
    
    var _targ_sf = surface_get_target();
    if (_targ_sf != application_surface)
    {
        surface_reset_target();
    }
    surface_set_target(_sf);
    draw_clear_alpha(c_white, 0);
    var cx = sf_w / 2;
    var cy = (sf_h / 2) + yoff;
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    _draw_text(cx, cy, arg2, effects, arg4, arg5, 0);
    var _outline_layers;
    if (effects.outline.active)
    {
        _outline_layers = [
        {
            color: effects.outline.color,
            width: effects.outline.width,
            smooth: effects.outline.smooth
        }];
        if (effects.splitfill.active)
        {
            _outline_layers[0].color = 0;
        }
        array_copy(_outline_layers, 1, effects.outline.layers, 0, effects.outline.extra_layers_amount);
        var _transfer_sf = surface_create(sf_w, sf_h);
        for (var i = 0; i < 1; i++)
        {
            surface_copy(_transfer_sf, 0, 0, _sf);
            var _layer = _outline_layers[i];
            shader_set_outline_texture(surface_get_texture(_transfer_sf), undefined, _layer.color, _layer.width / fontscale, true);
            draw_surface(_transfer_sf, 0, 0);
            shader_reset();
        }
        surface_free(_transfer_sf);
    }
    if (effects.splitfill.active)
    {
        var _dupesf;
        if (arg5 <= 1)
        {
            _dupesf = surface_create(sf_w, sf_h);
            surface_copy(_dupesf, 0, 0, _sf);
        }
        shader_set(shd_text_splitfill);
        var _u_topFillColor = shader_get_uniform(shd_text_splitfill, "topFillColor");
        var _u_topOutlineColor = shader_get_uniform(shd_text_splitfill, "topOutlineColor");
        var _u_bottomFillColor = shader_get_uniform(shd_text_splitfill, "bottomFillColor");
        var _u_bottomOutlineColor = shader_get_uniform(shd_text_splitfill, "bottomOutlineColor");
        var _u_yThreshold = shader_get_uniform(shd_text_splitfill, "yThreshold");
        var _u_pixels_height = shader_get_uniform(shd_text_splitfill, "pixels_height");
        var _alpha = 1;
        var topfill = effects.splitfill.top_color;
        var topoutline = effects.splitfill.outline_top_color;
        var bottomfill = effects.splitfill.bottom_color;
        var bottomoutline = effects.splitfill.outline_bottom_color;
        if (topoutline == -1)
        {
            topoutline = effects.outline.color;
        }
        if (bottomoutline == -1)
        {
            bottomoutline = effects.outline.color;
        }
        var topfill_rgba = [color_get_red(topfill) / 255, color_get_green(topfill) / 255, color_get_blue(topfill) / 255, _alpha];
        var topoutline_rgba = [color_get_red(topoutline) / 255, color_get_green(topoutline) / 255, color_get_blue(topoutline) / 255, _alpha];
        var bottomfill_rgba = [color_get_red(bottomfill) / 255, color_get_green(bottomfill) / 255, color_get_blue(bottomfill) / 255, _alpha];
        var bottomoutline_rgba = [color_get_red(bottomoutline) / 255, color_get_green(bottomoutline) / 255, color_get_blue(bottomoutline) / 255, _alpha];
        shader_set_uniform_f_array(_u_topFillColor, topfill_rgba);
        shader_set_uniform_f_array(_u_topOutlineColor, topoutline_rgba);
        shader_set_uniform_f_array(_u_bottomFillColor, bottomfill_rgba);
        shader_set_uniform_f_array(_u_bottomOutlineColor, bottomoutline_rgba);
        effects.splitfill.y_threshold = round_to_multiple(effects.splitfill.y_threshold, 1 / surface_get_height(_sf));
        shader_set_uniform_f(_u_yThreshold, effects.splitfill.y_threshold);
        var __hei = surface_get_height(_sf) * 0.24;
        shader_set_uniform_f(_u_pixels_height, __hei);
        if (arg5 <= 1)
        {
            draw_surface(_dupesf, 0, 0);
            surface_free(_dupesf);
            shader_reset();
        }
        else
        {
            _dupesf = surface_create(sf_w, sf_h / arg5);
            surface_reset_target();
            surface_set_target(_dupesf);
            draw_surface_ext(_sf, 0, 0, 1, 1 / arg5, 0, c_white, 1);
            surface_reset_target();
            shader_reset();
            surface_set_target(_sf);
            draw_surface_ext(_dupesf, 0, 0, 1, arg5, 0, c_white, 1);
            surface_free(_dupesf);
        }
    }
    if (effects.outline.active)
    {
        var _transfer_sf;
        if (array_length(_outline_layers) > 1)
        {
            _transfer_sf = surface_create(sf_w, sf_h);
        }
        for (var i = 1; i < array_length(_outline_layers); i++)
        {
            surface_copy(_transfer_sf, 0, 0, _sf);
            var _layer = _outline_layers[i];
            shader_set_outline_texture(surface_get_texture(_transfer_sf), undefined, _layer.color, _layer.width, true);
            draw_surface(_transfer_sf, 0, 0);
            shader_reset();
        }
        surface_free(_transfer_sf);
    }
    surface_reset_target();
    if (_targ_sf != application_surface)
    {
        surface_set_target(_targ_sf);
    }
    var sf_x = arg0;
    var sf_y = arg1;
    switch (_halign)
    {
        case 0:
            if (effects.outline.active)
            {
                sf_x -= effects.outline.width;
            }
            break;
        case 1:
            sf_x -= (sf_w / 2);
            break;
        case 2:
            sf_x -= sf_w;
            if (effects.outline.active)
            {
                sf_x += effects.outline.width;
            }
            break;
    }
    switch (_valign)
    {
        case 0:
            if (effects.outline.active)
            {
                sf_y -= effects.outline.width;
            }
            break;
        case 1:
            sf_y -= (sf_h / 2);
            break;
        case 2:
            sf_y -= sf_h;
            if (effects.outline.active)
            {
                sf_y += effects.outline.width;
            }
            break;
    }
    if (effects.shadow.active)
    {
        shader_set(shd_text_special_shadow);
        var _shdw_color = effects.shadow.color;
        var shadow_rgba = [color_get_red(_shdw_color) / 255, color_get_green(_shdw_color) / 255, color_get_blue(_shdw_color) / 255, 1];
        shader_set_uniform_f_array(shader_get_uniform(shd_text_special_shadow, "Color"), shadow_rgba);
        draw_surface(_sf, sf_x + effects.shadow.x, sf_y + effects.shadow.y);
        shader_reset();
    }
    arg4 *= fontscale;
    arg5 *= fontscale;
    draw_surface_ext(_sf, sf_x, sf_y, fontscale, fontscale, 0, c_white, 1);
    surface_free(_sf);
    draw_set_halign(_halign);
    draw_set_valign(_valign);
    draw_set_color(_col);
}

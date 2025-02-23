function draw_text_outline_splitfill(arg0, arg1, arg2, arg3 = 16777215, arg4 = 0, arg5 = 16777215, arg6 = 0, arg7 = false, arg8 = 1, arg9 = 1, arg10 = 1, arg11 = 0, arg12 = 0)
{
    var sf_w = string_width(arg2) + (arg8 * 2);
    var sf_h = string_height(arg2) + (arg8 * 2);
    var _sf = surface_create(sf_w, sf_h);
    var _col = draw_get_color();
    var _halign = draw_get_halign();
    var _valign = draw_get_valign();
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    surface_set_target(_sf);
    draw_clear_alpha(c_white, 0);
    draw_text_outline(arg8, arg8, arg2, 0, arg7, arg8 / min(arg9, arg10), 1, 1, arg11, arg12);
    surface_reset_target();
    draw_set_color(_col);
    draw_set_halign(_halign);
    draw_set_valign(_valign);
    sf_w *= arg9;
    sf_h *= arg10;
    switch (_halign)
    {
        case 1:
            arg0 -= (sf_w / 2);
            break;
        case 2:
            arg0 -= sf_w;
            break;
    }
    switch (_valign)
    {
        case 1:
            arg1 -= (sf_h / 2);
            break;
        case 2:
            arg1 -= sf_h;
            break;
    }
    arg0 += (arg8 * arg9);
    arg1 += (arg8 * arg10);
    shader_set(shd_text_splitfill);
    var _u_topFillColor = shader_get_uniform(shd_text_splitfill, "topFillColor");
    var _u_topOutlineColor = shader_get_uniform(shd_text_splitfill, "topOutlineColor");
    var _u_bottomFillColor = shader_get_uniform(shd_text_splitfill, "bottomFillColor");
    var _u_bottomOutlineColor = shader_get_uniform(shd_text_splitfill, "bottomOutlineColor");
    var _u_yThreshold = shader_get_uniform(shd_text_splitfill, "yThreshold");
    var _u_pixels_height = shader_get_uniform(shd_text_splitfill, "pixels_height");
    var _alpha = 1;
    var topfill_rgba = [color_get_red(arg3) / 255, color_get_green(arg3) / 255, color_get_blue(arg3) / 255, _alpha];
    var topoutline_rgba = [color_get_red(arg4) / 255, color_get_green(arg4) / 255, color_get_blue(arg4) / 255, _alpha];
    var bottomfill_rgba = [color_get_red(arg5) / 255, color_get_green(arg5) / 255, color_get_blue(arg5) / 255, _alpha];
    var bottomoutline_rgba = [color_get_red(arg6) / 255, color_get_green(arg6) / 255, color_get_blue(arg6) / 255, _alpha];
    shader_set_uniform_f_array(_u_topFillColor, topfill_rgba);
    shader_set_uniform_f_array(_u_topOutlineColor, topoutline_rgba);
    shader_set_uniform_f_array(_u_bottomFillColor, bottomfill_rgba);
    shader_set_uniform_f_array(_u_bottomOutlineColor, bottomoutline_rgba);
    shader_set_uniform_f(_u_yThreshold, 0.4166666666666667);
    shader_set_uniform_f(_u_pixels_height, surface_get_height(_sf));
    draw_surface_ext(_sf, arg0, arg1, arg9, arg10, 0, c_white, 1);
    shader_reset();
    surface_free(_sf);
}

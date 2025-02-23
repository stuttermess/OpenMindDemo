function save_steam_avatar(arg0, arg1)
{
    var _spr = spr_none;
    var _l_dims = steam_image_get_size(arg0);
    if (is_array(_l_dims))
    {
        var _buff_size = _l_dims[0] * _l_dims[1] * 4;
        var _l_cols = buffer_create(_buff_size, buffer_fixed, 1);
        var _l_ok = steam_image_get_rgba(arg0, _l_cols, _buff_size);
        if (!_l_ok)
        {
            buffer_delete(_l_cols);
            exit;
        }
        var _width = 26;
        var _height = 26;
        var _l_surf = surface_create(_l_dims[0], _l_dims[1]);
        var _f_surf = surface_create(_width, _height);
        buffer_set_surface(_l_cols, _l_surf, 0);
        surface_set_target(_f_surf);
        shader_set(shd_posterize);
        var uni = shader_get_uniform(shd_posterize, "posterization_level");
        shader_set_uniform_f(uni, 4);
        var scale = surface_get_width(_f_surf) / surface_get_width(_l_surf);
        gpu_set_texfilter(true);
        draw_surface_ext(_l_surf, 0, 0, scale, scale, 0, c_white, 1);
        gpu_set_texfilter(false);
        shader_reset();
        surface_reset_target();
        _spr = sprite_create_from_surface(_f_surf, 0, 0, _width, _height, false, false, _width / 2, _height / 2);
        surface_free(_l_surf);
        surface_free(_f_surf);
        buffer_delete(_l_cols);
    }
    if (struct_exists(steam_avatars, arg1))
    {
        var _delspr = struct_get(steam_avatars, arg1);
        if (_delspr != spr_none)
        {
            sprite_delete(_delspr);
        }
    }
    struct_set(steam_avatars, arg1, _spr);
}

function draw_charportrait_basic(arg0)
{
    with (arg0)
    {
        var _speaking_disp = speaking_display;
        var _face_ind = 1;
        for (var i = 1; i < array_length(pose_face_grid[0]); i++)
        {
            if (pose_face_grid[0][i] == face)
            {
                _face_ind = i;
            }
        }
        var _pose_spr = pose_sprite;
        var _face_spr = face_sprite;
        if (_pose_spr == -1)
        {
            _pose_spr = spr_blank;
        }
        if (!surface_exists(surface))
        {
            set_surface();
        }
        var _sf_w = surface_get_width(surface);
        var _sf_h = surface_get_height(surface);
        surface_set_target(surface);
        draw_clear_alpha(c_black, 0);
        var _dir = dir * sprite_dir;
        var _drawx = _sf_w / 2;
        var _drawy = _sf_h;
        if (_pose_spr != -1)
        {
            draw_sprite_ext(_pose_spr, 0, _drawx, _drawy, _dir, 1, 0, c_white, 1);
        }
        if (_face_spr != -1 && _face_spr != _pose_spr)
        {
            draw_sprite_ext(_face_spr, 0, _drawx, _drawy, _dir, 1, 0, c_white, 1);
        }
        if (_speaking_disp < 1)
        {
            gpu_set_colorwriteenable(1, 1, 1, 0);
            draw_sprite_stretched_ext(spr_dialogue_portrait_notspeaking_gradient, 0, 0, 0, _sf_w, _sf_h, c_white, 1 - _speaking_disp);
            gpu_set_colorwriteenable(1, 1, 1, 1);
        }
        surface_reset_target();
        var _x = x + (lerp(-2, 2, _speaking_disp) * dir);
        draw_surface(surface, _x - (_sf_w / 2), y - _sf_h);
    }
}

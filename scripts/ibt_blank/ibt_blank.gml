function ibt_blank() : inbetween_constructor() constructor
{
    draws_minigame_surface = true;
    intro_length = 1;
    
    get_intro_jingle = function()
    {
        return -1;
    };
    
    get_prep_jingle = function()
    {
        return -1;
    };
    
    get_win_jingle = function()
    {
        return -1;
    };
    
    get_lose_jingle = function()
    {
        return -1;
    };
    
    get_speedup_jingle = function()
    {
        return -1;
    };
    
    get_boss_jingle = function()
    {
        return -1;
    };
    
    bg_color = 65280;
    
    _draw_control_prompt = function(arg0, arg1 = -1)
    {
        if (is_array(arg0))
        {
            arg0 = build_control_style(arg0);
        }
        if (!is_struct(arg0))
        {
            exit;
        }
        var styles = [];
        var use_arrows = false;
        var use_spacebar = false;
        var use_cursor = false;
        var use_keyboard = false;
        var use_special = is_string(arg0.special);
        if (use_special)
        {
            array_push(styles, arg0.special);
        }
        else
        {
            use_arrows = arg0.arrows.any;
            use_spacebar = arg0.spacebar;
            use_cursor = arg0.cursor.any;
            use_keyboard = arg0.keyboard;
            if (use_arrows)
            {
                array_push(styles, "arrows");
            }
            if (use_spacebar)
            {
                array_push(styles, "spacebar");
            }
            if (use_cursor)
            {
                array_push(styles, "cursor");
            }
            if (use_keyboard)
            {
                array_push(styles, "keyboard");
            }
        }
        var stylescount = array_length(styles);
        var dx = 240;
        var dy = 135;
        var _spr = -1;
        switch (stylescount)
        {
            case 1:
                var _style = styles[0];
                switch (_style)
                {
                    case "arrows":
                        _spr = ibtS_spr_controlprompt_arrows;
                        break;
                    case "spacebar":
                        _spr = ibtS_spr_controlprompt_space;
                        break;
                    case "cursor":
                        _spr = ibtS_spr_controlprompt_mouse;
                        break;
                    case "keyboard":
                        _spr = ibtS_spr_controlprompt_keyboard;
                        break;
                }
                break;
            case 2:
                if (array_contains(styles, "arrows") && array_contains(styles, "spacebar"))
                {
                    _spr = ibtS_spr_controlprompt_arrows_space;
                }
                if (array_contains(styles, "arrows") && array_contains(styles, "cursor"))
                {
                    _spr = ibtS_spr_controlprompt_arrows_space_mouse;
                }
                if (array_contains(styles, "space") && array_contains(styles, "cursor"))
                {
                    _spr = ibtS_spr_controlprompt_arrows_space_mouse;
                }
                if (array_contains(styles, "keyboard") && array_contains(styles, "cursor"))
                {
                    _spr = ibtS_spr_controlprompt_keyboard_mouse;
                }
                break;
            case 3:
                if (array_contains(styles, "arrows") && array_contains(styles, "cursor") && array_contains(styles, "space"))
                {
                    _spr = ibtS_spr_controlprompt_arrows_space_mouse;
                }
                break;
        }
        if (_spr == -1)
        {
            exit;
        }
        var _r = 0;
        var _s = 0;
        arg1 = clamp(arg1 / 0.25, 0, 1);
        var _prog = 0;
        if (arg1 < 0.2)
        {
            _prog = clamp(arg1 / 0.2, 0, 1);
            _r = lerp(-10, 10, _prog);
            _s = lerp(1.3, 0.8, _prog);
        }
        else
        {
            _prog = lerp_easeOut(clamp((arg1 - 0.2) / 0.8, 0, 1));
            _r = lerp(10, 0, _prog);
            _s = lerp(0.8, 1, _prog);
        }
        var _ele_open = (minigame_intro_length - inbetween_timer) / minigame_intro_length;
        draw_sprite_ditherfaded(_spr, 0, dx, dy, _ele_open, _s, _s, _r, 16777215, 1);
    };
    
    minigame_intro_length = 0.5;
    minigame_outro_length = 0.5;
    lives_pos = [[39, 70], [120, 45], [360, 45], [441, 70]];
    
    __init = function()
    {
    };
    
    __tick = function()
    {
        var beat = obj_minigame_controller.inbetween_length - inbetween_timer;
    };
    
    __draw = function()
    {
        draw_clear(bg_color);
        var _len = obj_minigame_controller.inbetween_length;
        var beat = _len - inbetween_timer;
        beat = max(0, beat);
        var beat1 = beat % 1;
        var standard_mg_intro = true;
        if (standard_mg_intro)
        {
            var _mask_spr = -1;
            var _outline_spr = -1;
            var _time = 0;
            var _mg_scale = 1;
            if (inbetween_timer < minigame_intro_length)
            {
                if (obj_minigame_controller.inbetween_type != 3)
                {
                    _mask_spr = ibtS_spr_mgintro_mask;
                    _outline_spr = ibtS_spr_mgintro_outline;
                    _time = (minigame_intro_length - inbetween_timer) / minigame_intro_length;
                }
            }
            else if ((obj_minigame_controller.inbetween_length - inbetween_timer) <= minigame_outro_length)
            {
                if (success_state != 0)
                {
                    _mask_spr = ibtS_spr_mgintro_mask;
                    _outline_spr = ibtS_spr_mgintro_outline;
                    _time = 1 - (obj_minigame_controller.inbetween_length - (inbetween_timer / minigame_outro_length));
                    _mg_scale = 1;
                    _time = 0;
                }
            }
            var _mask_sizes = [[0, 0], [1, 1], [7, 6], [16, 11], [25, 18], [38, 26], [48, 42], [68, 61], [100, 92], [138, 129], [255, 215], [480, 270], [480, 270], [480, 270], [480, 270], [480, 270], [480, 270]];
            var _frame = clamp(_time, 0, 1) * sprite_get_number(_mask_spr);
            var _frame_mask_size = _mask_sizes[_frame];
            _mg_scale = max(_frame_mask_size[0] / 480, _frame_mask_size[1] / 270);
            if (_time > 0)
            {
                draw_sprite(_outline_spr, sprite_get_number(_outline_spr) * _time, 240, 135);
                var _transition_sf = surface_create(480, 270);
                var _prev_targ = surface_get_target();
                surface_reset_target();
                surface_set_target(_transition_sf);
                draw_clear_alpha(c_white, 0);
                gpu_set_blendenable(false);
                gpu_set_colorwriteenable(false, false, false, true);
                draw_set_alpha(0);
                draw_rectangle(-1, -1, 481, 271, false);
                draw_set_alpha(1);
                draw_sprite(_mask_spr, sprite_get_number(_mask_spr) * _time, 240, 135);
                gpu_set_colorwriteenable(true, true, true, false);
                draw_minigame_surface(240, 135, _mg_scale, _mg_scale, 0);
                gpu_set_colorwriteenable(true, true, true, true);
                surface_reset_target();
                surface_set_target(_prev_targ);
                draw_surface(_transition_sf, 0, 0);
                surface_free(_transition_sf);
            }
        }
        var cprompt_time = 3 - inbetween_timer;
        if (cprompt_time > 0 && obj_minigame_controller.inbetween_type != 3)
        {
            _draw_control_prompt(next_control_style, cprompt_time);
        }
    };
    
    __on_return = function()
    {
    };
}

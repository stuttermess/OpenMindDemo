function draw_generic_control_prompt(arg0, arg1 = -1, arg2 = 0, arg3 = 0, arg4 = 0)
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
    var dx = arg2;
    var dy = arg3;
    var _spr = -1;
    switch (stylescount)
    {
        case 1:
            var _style = styles[0];
            switch (_style)
            {
                case "arrows":
                    _spr = ibtG_spr_controlprompt_arrows;
                    break;
                case "spacebar":
                    _spr = ibtG_spr_controlprompt_space;
                    break;
                case "cursor":
                    _spr = ibtG_spr_controlprompt_mouse;
                    break;
                case "keyboard":
                    _spr = ibtG_spr_controlprompt_keyboard;
                    break;
            }
            break;
        case 2:
            if (array_contains(styles, "arrows") && array_contains(styles, "spacebar"))
            {
                _spr = ibtG_spr_controlprompt_arrows_space;
            }
            if (array_contains(styles, "arrows") && array_contains(styles, "cursor"))
            {
                _spr = ibtG_spr_controlprompt_arrows_space_mouse;
            }
            if (array_contains(styles, "space") && array_contains(styles, "cursor"))
            {
                _spr = ibtG_spr_controlprompt_arrows_space_mouse;
            }
            if (array_contains(styles, "keyboard") && array_contains(styles, "cursor"))
            {
                _spr = ibtG_spr_controlprompt_keyboard_mouse;
            }
            break;
        case 3:
            if (array_contains(styles, "arrows") && array_contains(styles, "cursor") && array_contains(styles, "space"))
            {
                _spr = ibtG_spr_controlprompt_arrows_space_mouse;
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
    draw_sprite_ditherfaded(_spr, 0, dx, dy, arg4, _s, _s, _r, 16777215, 1);
}

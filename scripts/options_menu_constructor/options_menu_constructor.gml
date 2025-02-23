function options_menu_constructor(arg0 = true) constructor
{
    y = 5;
    scroll_y = 0;
    cursor_hover = -1;
    focused = true;
    input_allowed = true;
    dropdown_open = -1;
    dropdown_pos = [0, 0];
    slider_dragging = -1;
    draw_time_screen_0 = true;
    screen = 0;
    width = 200;
    x = 240 - (width / 2);
    draw_set_font(fnt_dialogue);
    key_ghosting_test_text = string_to_wrapped(strloc("menus/options/key_ghosting_test_text"), width);
    draw_set_font(fnt_pixel);
    
    _draw_option = function(arg0, arg1 = -1)
    {
        var i = arg0;
        var _op = options[i];
        _op.container = self;
        _op.x = draw_x + _op.xoff;
        _op.y = draw_y + _op.yoff;
        _op.cursor_x = -100;
        _op.cursor_y = -100;
        if (input_allowed)
        {
            _op.cursor_x = mouse_x;
            _op.cursor_y = mouse_y;
        }
        var usedropdown = is_struct(arg1);
        var is_dropdown = usedropdown && (i + 1) == array_length(options);
        if (input_allowed && (_op.hovered || is_dropdown) && get_input_click() && (!usedropdown || is_dropdown))
        {
            cursor_click = 2;
            master.click = 0;
        }
        if (!usedropdown || is_dropdown)
        {
            _op.cursor_click = cursor_click;
        }
        else if ((!usedropdown && is_dropdown) || is_dropdown)
        {
            _op.cursor_click = -1;
        }
        if (is_dropdown)
        {
            _op.draw_menu(dropdown_pos[0], dropdown_pos[1]);
        }
        else
        {
			_op._draw();
        }
        if (_op.hovered && cursor_hover == -1 && (arg1 == -1 || is_dropdown))
        {
            cursor_hover = i;
        }
        if (cursor_click == 2 || (cursor_click == 1 && !mouse_check_button(mb_left)))
        {
            cursor_click = 0;
        }
        if (input_allowed && cursor_click == 0 && mouse_check_button_pressed(mb_left) && cursor_hover != -1)
        {
            cursor_click = 1;
        }
        if (_op.tick_tooltip_hover(cursor_hover == i))
        {
            tooltip_hover_option = _op;
        }
    };
    
    _tick = function()
    {
    };
    
    _draw = function()
    {
        if (!focused)
        {
            exit;
        }
        var padding = 15;
        var _bgspr = spr_optionsbg_gradient;
        var _x1 = (x - 10 - padding) + 5;
        var _y1 = y - padding;
        var _x2 = x + width + padding + 5;
        var _y2 = y + 270 + padding;
        _y1 = 3;
        _y2 = 267;
        var _wid = _x2 - _x1;
        var _hei = _y2 - _y1;
        var _xscale = _wid / sprite_get_width(_bgspr);
        var _yscale = _hei / sprite_get_height(_bgspr);
        draw_sprite_ext(_bgspr, 0, _x1, _y1, _xscale, _yscale, 0, c_white, 1);
        switch (screen)
        {
            case 0:
                line_height = string_height("A") + 10;
                draw_x = x;
                draw_y = (y - scroll_y) + (line_height / 2);
                if (draw_time_screen_0)
                {
                    draw_set_halign(fa_right);
                    var _pt_total_seconds = floor(master.profile.stats.playtime + ((current_time - master.timestamp_for_playtime) / 1000));
                    var _pt_hours = floor(_pt_total_seconds / 3600);
                    _pt_total_seconds -= (_pt_hours * 3600);
                    var _pt_minutes = floor(_pt_total_seconds / 60);
                    _pt_total_seconds -= (_pt_minutes * 60);
                    var _pt_seconds = floor(_pt_total_seconds);
                    var _str_minutes = string_replace_all(string_format(_pt_minutes, 2, 0), " ", "0");
                    var _str_seconds = string_replace_all(string_format(_pt_seconds, 2, 0), " ", "0");
                    var _time_str = "";
                    if (_pt_hours > 0)
                    {
                        _time_str += (string(_pt_hours) + ":");
                    }
                    _time_str += (_str_minutes + ":" + _str_seconds);
                    draw_text_outline(draw_x + width, draw_y, _time_str);
                    draw_set_halign(fa_left);
                }
                draw_set_valign(fa_middle);
                cursor_hover = -1;
                var realclick = input_allowed && get_input_click();
                var usedropdown = false;
                if (dropdown_open != -1)
                {
                    array_push(options, dropdown_open);
                    usedropdown = true;
                }
                tooltip_hover_option = -1;
                var _ddopen = dropdown_open;
                for (var i = 0; i < array_length(options); i++)
                {
                    _draw_option(i, _ddopen);
                    draw_y += line_height;
                }
                if (usedropdown)
                {
                    array_pop(options);
                }
                if (tooltip_hover_option != -1)
                {
                    var _op = tooltip_hover_option;
                    _op.draw_tooltip();
                }
                draw_set_valign(fa_top);
                break;
            case 1:
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_set_font(fnt_dialogue);
                draw_text_outline(x + (width / 2), 200, key_ghosting_test_text);
                draw_set_halign(fa_left);
                draw_set_font(fnt_pixel);
                var _keys = [192, "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", 189, 187, 8, 9, "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", 219, 221, 220, -1, "A", "S", "D", "F", "G", "H", "J", "K", "L", 186, 222, 13, 160, "Z", "X", "C", "V", "B", "N", "M", 188, 190, 191, 161, 162, -1, 164, 32, 165, -1, -1, 163];
                var _kb_x = x + (width / 2);
                var _kb_y = 100;
                draw_sprite(spr_options_keyboard_indicator, 0, _kb_x, _kb_y);
                if (input_allowed)
                {
                    for (var i = 0; i < array_length(_keys); i++)
                    {
                        var _key = _keys[i];
                        if (is_string(_key))
                        {
                            _key = ord(_key);
                        }
                        if (keyboard_check(_key) && _key != -1)
                        {
                            draw_sprite(spr_options_keyboard_indicator, i + 1, _kb_x, _kb_y);
                        }
                    }
                }
                draw_x = x;
                draw_y = (y - scroll_y) + (line_height / 2);
                cursor_hover = -1;
                draw_set_valign(fa_middle);
                _draw_option(0);
                draw_set_valign(fa_top);
                break;
        }
    };
    
    on_exit = function()
    {
    };
    
    options = [];
    cursor_click = 0;
    var _blank = new option_text_constructor();
    
    _blank._draw = function()
    {
        draw_y -= (line_height / 2);
    };
    
    var _tab_in = new option_tab_constructor(1);
    var _tab_out = new option_tab_constructor(-1);
    btnback = new option_button_constructor(strloc("menus/options/back_button"), function()
    {
        switch (screen)
        {
            case 0:
                on_exit();
                profile_save();
                break;
            case 1:
                screen = 0;
                break;
        }
    });
    btnback.xoff = -10;
    btnback.click_sound = snd_menu_back;
    if (arg0)
    {
        var mastervol = new option_slider_constructor(strloc("menus/options/vol_master"), option_value(master.settings, "vol_master"), true, "%");
        var sfxvol = new option_slider_constructor(strloc("menus/options/vol_sfx"), option_value(master.settings, "vol_sfx"), true, "%");
        var musvol = new option_slider_constructor(strloc("menus/options/vol_music"), option_value(master.settings, "vol_music"), true, "%");
        var mute_unfocus = new option_checkbox_constructor(strloc("menus/options/mute_on_lose_focus"), option_value(master.settings, "mute_on_lose_focus"), strloc("menus/options/tooltip/mute_on_lose_focus"));
        var window_scale = new option_dropdown_constructor(strloc("menus/options/window_scale"), option_value(master, "settings_window_scale"));
        window_scale.name = strloc("menus/options/window_scale");
        window_scale.options = [-1];
        var _default_str = string_replace_all(strloc("menus/options/window_scale_default"), "#", string(master.get_default_screen_size()));
        window_scale.options_text = [_default_str];
        var _max_scale = master.get_max_screen_size();
        for (var i = 1; i < _max_scale; i++)
        {
            array_push(window_scale.options, i);
            array_push(window_scale.options_text, string_replace_all(strloc("menus/options/window_scale_option"), "#", string(i)));
        }
        var fullscreen_toggle = new option_checkbox_constructor(strloc("menus/options/fullscreen_toggle"), option_value(master.settings, "fullscreen"));
        var window_mouse_lock = new option_checkbox_constructor(strloc("menus/options/window_mouse_lock_toggle"), option_value(master, "mouselock_bool"), strloc("menus/options/tooltip/window_mouse_lock_toggle"));
        var key_ghosting_compensation_checkbox = new option_checkbox_constructor(strloc("menus/options/key_ghosting_compensation"), option_value(master.settings, "key_ghosting_compensation"), strloc("menus/options/tooltip/key_ghosting_compensation"));
        var test_key_ghosting_button = new option_button_constructor(strloc("menus/options/test_key_ghosting"), function()
        {
            screen = 1;
        }, strloc("menus/options/tooltip/test_key_ghosting"));
        var pause_unfocus = new option_checkbox_constructor(strloc("menus/options/pause_on_lose_focus"), option_value(master.settings, "pause_on_lose_focus"), strloc("menus/options/tooltip/pause_on_lose_focus"));
        array_push(options, btnback, new option_text_constructor(strloc("menus/options/volume_label")), _tab_in, mastervol, sfxvol, musvol, _tab_out, mute_unfocus, window_mouse_lock, pause_unfocus, key_ghosting_compensation_checkbox, test_key_ghosting_button, window_scale, fullscreen_toggle);
    }
}

function option_value(arg0, arg1, arg2 = 0)
{
    return 
    {
        inst: arg0,
        value_name: arg1,
        index: arg2,
        
        get: function()
        {
            if (is_struct(inst))
            {
                return variable_struct_get(inst, value_name);
            }
            else
            {
                return variable_instance_get(inst, value_name);
            }
        },
        
        set: function(arg0)
        {
            if (is_struct(inst))
            {
                variable_struct_set(inst, value_name, arg0);
            }
            else
            {
                variable_instance_set(inst, value_name, arg0);
            }
        }
    };
}

function option_constructor(arg0 = "", arg1 = "") constructor
{
    container = -1;
    name = arg0;
    if (arg1 != "")
    {
        var lalala = 0;
    }
    tooltip = arg1;
    type = "";
    
    on_update = function()
    {
    };
    
    _tick = function()
    {
    };
    
    _draw = function()
    {
        draw_text_outline(x, y + 1, name);
    };
    
    x = 0;
    y = 0;
    xoff = 0;
    yoff = 0;
    hovered = false;
    cursor_x = 0;
    cursor_y = 0;
    cursor_click = 0;
    click_sound = snd_menu_click;
    _tooltip_hover_area = [0, 0, 0, 0];
    tooltip_hover_time_max = 60;
    tooltip_hover_time = 0;
    
    define_tooltip_hover_area = function(arg0, arg1, arg2, arg3)
    {
        _tooltip_hover_area = [arg0, arg1, arg2, arg3];
    };
    
    tick_tooltip_hover = function(arg0 = true)
    {
        var _ttha = _tooltip_hover_area;
        if ((arg0 || point_in_rectangle(mouse_x, mouse_y, _ttha[0], _ttha[1], _ttha[2], _ttha[3])) && !container.dropdown_open)
        {
            tooltip_hover_time++;
        }
        else
        {
            tooltip_hover_time = 0;
        }
        return tooltip_hover_time >= tooltip_hover_time_max;
    };
    
    tooltip_max_width = 180;
    
    draw_tooltip = function()
    {
        if (tooltip == "")
        {
            exit;
        }
        if (tooltip_hover_time < tooltip_hover_time_max)
        {
            exit;
        }
        var _halign = draw_get_halign();
        var _valign = draw_get_valign();
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        var _fnt = draw_get_font();
        draw_set_font(fnt_dialogue);
        var _str = string_to_wrapped(tooltip, tooltip_max_width, "\n");
        var _margin = 5;
        var _hei = string_height(_str) + (_margin * 2);
        var _wid = string_width(_str) + (_margin * 2);
        var _tx = (mouse_x + 15) - (_wid / 2);
        var _ty = mouse_y + 20;
        if (_tx > 360)
        {
            _tx -= (15 + _wid);
        }
        if ((_ty + _hei) > 202.5)
        {
            _ty -= (35 + _hei);
        }
        _tx = clamp(_tx, 5, 475 - _wid);
        _ty = clamp(_ty, 5, 265 - _hei);
        draw_set_color(c_purple);
        draw_set_alpha(0.8);
        draw_rectangle(_tx, _ty, _tx + _wid, _ty + _hei, false);
        draw_set_color(c_white);
        draw_set_alpha(1);
        draw_rectangle(_tx, _ty, _tx + _wid, _ty + _hei, true);
        draw_text_outline(_tx + _margin, _ty + _margin, _str);
        draw_set_halign(_halign);
        draw_set_valign(_valign);
        draw_set_font(_fnt);
    };
}

function option_text_constructor(arg0 = "") : option_constructor(arg0) constructor
{
}

function option_tab_constructor(arg0 = 1) : option_constructor() constructor
{
    dir = arg0;
    
    _draw = function()
    {
        container.draw_x += 20 * dir;
        container.draw_y -= container.line_height;
    };
}

function option_button_constructor(arg0, arg1 = function()
{
}, arg2 = "") : option_constructor(arg0, arg2) constructor
{
    _draw = function()
    {
        var _str = name;
        draw_text_outline(x, y + 1, _str);
        var _h = string_height(_str);
        var _w = string_width(_str);
        var _m = 3;
        coords = [x - _m, y - (_h / 2) - _m, x + _w + _m, y + (_h / 2) + _m];
        draw_rectangle(coords[0] + 1, coords[1] + 1, coords[2] - 1, coords[3] - 1, true);
        hovered = point_in_rectangle(cursor_x, cursor_y, coords[0], coords[1], coords[2], coords[3]);
        if (hovered && cursor_click == 2)
        {
            sfx_play(click_sound);
            on_click();
        }
        define_tooltip_hover_area(coords[0], coords[1], coords[2], coords[3]);
    };
    
    on_click = arg1;
    coords = [0, 0, 0, 0];
}

function option_checkbox_constructor(arg0, arg1, arg2 = "") : option_constructor(arg0, arg2) constructor
{
    type = "checkbox";
    value = arg1;
    checked = value.get();
    click_sound = snd_menu_click_minor;
    
    _draw = function()
    {
        checked = value.get();
        draw_text_outline(x, y + 1, name);
        var cx = x + string_width(name) + 3;
        var cs = 6;
        var crds = [cx, y - (cs / 2), cx + cs, y + (cs / 2)];
        draw_rectangle(crds[0], crds[1], crds[2], crds[3], true);
        if (checked)
        {
            draw_rectangle(crds[0] + 1, crds[1] + 1, crds[2] - 1, crds[3] - 1, false);
        }
        hovered = point_in_rectangle(cursor_x, cursor_y, crds[0], crds[1], crds[2], crds[3]);
        if (hovered && cursor_click == 2)
        {
            sfx_play(click_sound);
            checked = !checked;
            on_update();
        }
        var _strhei = string_height(name) / 2;
        define_tooltip_hover_area(x, y - _strhei, cx + cs, y + _strhei);
    };
    
    on_update = function()
    {
        value.set(checked);
    };
}

function option_slider_constructor(arg0, arg1, arg2 = true, arg3 = "", arg4 = "") : option_constructor(arg0, arg4) constructor
{
    value_to_slider_value = function()
    {
        return value.get();
    };
    
    value = arg1;
    slider_value = value_to_slider_value();
    value_min = 0;
    value_max = 100;
    dragging = false;
    drag_x = 0;
    line_length = 100;
    _round = arg2;
    suffix = arg3;
    click_sound = snd_menu_slider;
    sound_repeat_time = 0;
    
    _draw = function()
    {
        draw_text_outline(x, y + 1, name);
        var _strhei = string_height(name) / 2;
        var line_x = x + 50;
        var circ_x = line_x + (line_length * ((slider_value - value_min) / (value_max - value_min)));
        var circ_r = 6;
        var circ_rr = circ_r + (-1 * real(dragging));
        define_tooltip_hover_area(x, y - _strhei, line_x + line_length + 1, y + _strhei);
        draw_set_color(c_black);
        draw_line_width(line_x - 1, y, line_x + line_length + 1, y, 5);
        draw_circle(circ_x, y, circ_rr + 1, false);
        draw_set_color(c_white);
        draw_line_width(line_x, y, line_x + line_length, y, 3);
        draw_circle(circ_x, y, circ_rr, false);
        draw_text_outline(line_x + line_length + circ_r + 4, y + 2, get_value_string(slider_value));
        hovered = point_in_circle(cursor_x, cursor_y, circ_x, y, circ_r);
        if (!hovered && cursor_click == 0)
        {
            dragging = false;
        }
        if (cursor_click != 1 || (!mouse_check_button(mb_left) && dragging))
        {
            dragging = false;
            container.slider_dragging = -1;
        }
        if ((hovered || dragging) && cursor_click == 1)
        {
            if (!dragging && container.slider_dragging == -1)
            {
                drag_x = circ_x - cursor_x;
                dragging = true;
                container.slider_dragging = self;
            }
            if (dragging)
            {
                circ_x = cursor_x + drag_x;
                var _prev_val = slider_value;
                var _frac = (circ_x - line_x) / line_length;
                slider_value = lerp(value_min, value_max, _frac);
                slider_value = clamp(slider_value, value_min, value_max);
                if (slider_value != _prev_val && sound_repeat_time == 0)
                {
                    sfx_play(click_sound, false, 1, 0, lerp(0.9, 1.3, _frac));
                    sound_repeat_time = 7;
                }
                if (_round)
                {
                    slider_value = round(slider_value);
                }
                on_update();
            }
        }
        else
        {
            dragging = false;
        }
        if (sound_repeat_time > 0)
        {
            sound_repeat_time--;
        }
    };
    
    on_update = function()
    {
        value.set(slider_value);
    };
    
    get_value_string = function(arg0)
    {
        return string(arg0) + suffix;
    };
}

function option_dropdown_constructor(arg0, arg1, arg2 = "") : option_constructor(arg0, arg2) constructor
{
    name = "";
    options = [0];
    options_text = [""];
    selected_option_num = -1;
    value = arg1;
    coords = [0, 0, 0, 0];
    open = false;
    
    draw_menu = function(arg0, arg1)
    {
        hovered = -1;
        var option_height = 12;
        var _w = 0;
        var _h = option_height * array_length(options_text);
        if ((arg1 + _h) > 260)
        {
            arg1 = 260 - _h;
        }
        for (var i = 0; i < array_length(options_text); i++)
        {
            _w = max(_w, string_width(options_text[i]) + 6);
        }
        draw_set_color(c_purple);
        draw_set_alpha(0.75);
        draw_rectangle(arg0, arg1, arg0 + _w, arg1 + _h, false);
        draw_set_color(c_white);
        draw_set_alpha(1);
        draw_rectangle(arg0, arg1, arg0 + _w, arg1 + _h, true);
        var _valign = draw_get_valign();
        draw_set_valign(fa_middle);
        arg1 += 1;
        for (var i = 0; i < array_length(options_text); i++)
        {
            var _op_str = options_text[i];
            var _crds = [arg0 + 1, arg1 + (option_height * i), (arg0 - 1) + _w, (arg1 - 2) + (option_height * (i + 1))];
            draw_set_color(c_white);
            draw_set_alpha(0.25);
            draw_rectangle(_crds[0], _crds[1], _crds[2], _crds[3], false);
            draw_set_color(c_white);
            draw_set_alpha(1);
            draw_text_outline(arg0 + 3, mean(_crds[1], _crds[3]) + 2, _op_str);
            if (hovered == -1)
            {
                if (point_in_rectangle(cursor_x, cursor_y, _crds[0], _crds[1], _crds[2], _crds[3]))
                {
                    hovered = i + 1;
                }
            }
        }
        draw_set_valign(_valign);
        var cursor_in_menu = point_in_rectangle(cursor_x, cursor_y, arg0, arg1, arg0 + _w, arg1 + _h);
        if (cursor_click == 2)
        {
            if (cursor_in_menu)
            {
                if (hovered != -1)
                {
                    selected_option_num = hovered - 1;
                    on_update();
                    open = false;
                    container.dropdown_open = -1;
                    sfx_play(click_sound);
                }
            }
            else
            {
                open = false;
                container.dropdown_open = -1;
            }
        }
    };
    
    _draw = function()
    {
        if (selected_option_num == -1 || (selected_option_num != -1 && options[selected_option_num] != value.get()))
        {
            selected_option_num = array_get_index(options, value.get());
            if (open)
            {
                open = false;
                container.dropdown_open = -1;
            }
        }
        var _name = name;
        var drawx = x;
        draw_text_outline(drawx, y + 1, _name);
        drawx += (string_width(_name) + 5);
        if (open)
        {
            tooltip_hover_time = 0;
        }
        else
        {
            var _str = "   ";
            if (selected_option_num != -1)
            {
                _str = options_text[selected_option_num];
            }
            draw_text_outline(drawx, y + 1, _str);
            var _h = string_height(_str);
            var _w = string_width(_str);
            var _m = 3;
            coords = [drawx - _m, y - (_h / 2) - _m, drawx + _w + _m, y + (_h / 2) + _m];
            draw_rectangle(coords[0] + 1, coords[1] + 1, coords[2] - 1, coords[3] - 1, true);
            hovered = point_in_rectangle(cursor_x, cursor_y, coords[0], coords[1], coords[2], coords[3]);
            if (hovered && cursor_click == 2)
            {
                sfx_play(click_sound);
                open = true;
                container.dropdown_open = self;
                container.dropdown_pos = [coords[0] + 1, coords[1] + 1];
            }
            var _strhei = string_height(name) / 2;
            define_tooltip_hover_area(x, y - _strhei, coords[2], y + _strhei);
        }
    };
    
    on_update = function()
    {
        if (selected_option_num != -1)
        {
            value.set(options[selected_option_num]);
        }
    };
}

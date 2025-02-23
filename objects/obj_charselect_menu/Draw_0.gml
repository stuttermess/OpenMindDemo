var _easefunc = lerp_easeOutBack;
var _vis_screen_transition = _easefunc(screen_transition);
var _offset_x = cam_x - obj_mainmenu_controller.cam_x;
var char_pos = [240 + _offset_x, 135];
var char_pos_top = [char_pos[0] + 135 + (char_box_seperation / 2), char_pos[1] - 270 - char_box_seperation];
var char_pos_bottom = [char_pos[0] - 135 - (char_box_seperation / 2), char_pos[1] + 270 + char_box_seperation];
var char_pos_enter, char_pos_exit;
if (transition_direction == 1)
{
    char_pos_enter = char_pos_top;
    char_pos_exit = char_pos_bottom;
}
else
{
    char_pos_enter = char_pos_bottom;
    char_pos_exit = char_pos_top;
}
var background_pos = char_pos;
var background_pos_enter = char_pos_enter;
var background_pos_exit = char_pos_exit;
menu_in_draw = lerp_easeOutBack(menu_in);
if (!surface_exists(bg_sf))
{
    bg_sf = surface_create(480, 270);
}
if (!surface_exists(letterbox_sf))
{
    letterbox_sf = surface_create(480, 270);
}
surface_set_target(bg_sf);
obj_mainmenu_controller.mmbg_args.overlay_col = letterbox_color;
draw_surface(application_surface, 0, 0);
surface_reset_target();
surface_set_target(letterbox_sf);
draw_clear_alpha(c_white, 0);
var left_lbox_dist = 35;
var tx1 = border_y_to_x(270, left_lbox_dist);
var tx2 = border_y_to_x(-1, left_lbox_dist);
draw_triangle(tx1, -1, tx2, -1, tx1, 270, false);
draw_rectangle(-1, -1, tx1, 271, false);
draw_rectangle(372 + _offset_x, 0, 480 + _offset_x, 270, false);
draw_triangle(371 + _offset_x, -2, 371 + _offset_x, 270, 235 + _offset_x, 270, false);
var _y = lerp(background_pos_enter[1], background_pos[1], _vis_screen_transition) - 135;
gpu_set_colorwriteenable(1, 1, 1, 0);
draw_surface(bg_sf, 0, 0);
gpu_set_colorwriteenable(1, 1, 1, 1);
surface_reset_target();
left_lbox_dist = 35;
draw_surface(bg_sf, 0, 0);
var char_xs = [0, 0];
var char_ys = [0, 0];
if (screen_transition < 1)
{
    var _x = lerp(background_pos[0], background_pos_exit[0], _vis_screen_transition);
    _y = lerp(background_pos[1], background_pos_exit[1], _vis_screen_transition);
    prev_character._draw_background(_x, _y, 1 - _vis_screen_transition);
    if (prev_character.character_script == -1)
    {
        char_ys[1] = 570;
    }
    else
    {
        char_ys[1] = _y;
    }
    char_xs[1] += 0;
}
if (character != -1)
{
    var _x = lerp(background_pos_enter[0], background_pos[0], _vis_screen_transition);
    _y = lerp(background_pos_enter[1], background_pos[1], _vis_screen_transition);
    character._draw_background(_x, _y, _vis_screen_transition);
    char_ys[0] = _y;
    char_xs[0] += 0;
}
draw_surface_part(letterbox_sf, 0, 0, 230, 270, 0, 0);
draw_border_line(left_lbox_dist + char_xs[1], char_ys[1] - 135 - 2, char_ys[1] + 135);
draw_border_line(left_lbox_dist + char_xs[0], char_ys[0] - 135 - 2, char_ys[0] + 135);
if (character != -1)
{
    if (screen_transition < 1)
    {
        _x = lerp(char_pos[0], char_pos_exit[0], _vis_screen_transition);
        _y = lerp(char_pos[1], char_pos_exit[1], _vis_screen_transition);
        prev_character._draw_character(_x, _y, 1 - _vis_screen_transition);
    }
    var _x = lerp(char_pos_enter[0], char_pos[0], _vis_screen_transition);
    _y = lerp(char_pos_enter[1], char_pos[1], _vis_screen_transition);
    character._draw_character(_x, _y, _vis_screen_transition);
}
draw_surface_part(letterbox_sf, 230, 0, 250, 270, 230, 0);
draw_border_line(370 + char_xs[1], char_ys[1] - 135 - 2, char_ys[1] + 135);
draw_border_line(370 + char_xs[0], char_ys[0] - 135 - 2, char_ys[0] + 135);
var _chars = [prev_character, character];
draw_set_color(c_black);
for (i = 0; i < array_length(_chars); i++)
{
    var _char = _chars[i];
    if (_char.character_script != -1 && (i == 1 || screen_transition < 1))
    {
        var _y_top = char_ys[1 - i] - 135 - 2;
        var _y_bottom = _y_top + 270 + 2;
        var _x1_top = border_y_to_x(_y_top, left_lbox_dist) - 1;
        var _x2_top = border_y_to_x(_y_top, 370) + 1;
        var _x1_bottom = border_y_to_x(_y_bottom, left_lbox_dist) - 1;
        var _x2_bottom = border_y_to_x(_y_bottom, 370) + 1;
        draw_line_width(_x1_top, _y_top, _x2_top, _y_top, 3);
        if (screen_transition < 1)
        {
            draw_line_width(_x1_bottom, _y_bottom, _x2_bottom, _y_bottom, 3);
        }
    }
}
draw_set_color(c_white);
draw_sprite(spr_charselect_title, 0, lerp(-300, 0, menu_in_draw), 0);
draw_sprite(character.name_sprite, 0, pagebtns_x, pagebtns_y);
for (i = 0; i < array_length(pagebtn); i++)
{
    var _btnx = pagebtns_x;
    var _btny = pagebtns_y;
    if (screen_transition < 1)
    {
        var _wantdir = array_get([1, -1], i);
        if (_wantdir == transition_direction)
        {
            var _len = lerp(3, 0, screen_transition);
            var _dir = 63.434949 + (i * 180);
            _btnx += lengthdir_x(_len, _dir);
            _btny += lengthdir_y(_len, _dir);
        }
    }
    draw_sprite(spr_charselect_arrows, i, _btnx, _btny);
}
var menu_open = showing_steam_leaderboard || settings_menu_open;
var mode_str = "";
var _modes = [character.settings.mode, prev_game_mode];
if (game_mode_anim > 0.5)
{
    _modes = array_reverse(_modes);
}
for (i = 0; i < 2; i++)
{
    var _mode = _modes[i];
    var _iscurr = _mode == character.settings.mode;
    var _isprev = _mode == prev_game_mode;
    var _bottom_fade = false;
    if (prev_mode_was_prev_char)
    {
        _bottom_fade = true;
    }
    var topness = -dsin(-90 + (90 * (_iscurr - game_mode_anim)));
    var outness = -sin(pi * game_mode_anim);
    if (_isprev)
    {
        outness *= -1;
    }
    var drawx = 0;
    var drawy = 0;
    var _str = "";
    switch (_mode)
    {
        case 0:
            _str = text.mode_standard;
            drawx = lerp(8, 5, topness);
            drawy = lerp(255, 251, topness);
            break;
        case 1:
            _str = text.mode_endless;
            drawx = lerp(20, 6, topness);
            drawy = lerp(255, 251, topness);
            break;
    }
    drawy += (outness * 5);
    drawx += lerp(-90, 0, menu_in_draw);
    drawx = round(drawx);
    drawy = round(drawy);
    var _crd = [0, 0, 0, 0];
    _crd[0] = drawx - 2;
    _crd[1] = drawy - 2;
    _crd[2] = drawx + string_width(_str);
    _crd[3] = (drawy + string_height(_str) + 1) - 3;
    var fademode = false;
    var _al = 1;
    if (_bottom_fade)
    {
        var _prev_alpha = 1;
        if (prev_mode_was_prev_char && !array_contains(prev_character.allowed_modes, _mode))
        {
            _prev_alpha = 0;
        }
        var _new_alpha = real(array_contains(character.allowed_modes, _mode));
        _al = lerp(_prev_alpha, _new_alpha, game_mode_fade_anim);
        fademode = _al < 1;
    }
    if (_al > 0)
    {
        var recx = _crd[0];
        var recy = _crd[1];
        var recx2 = _crd[2];
        var recy2 = _crd[3];
        var _sf;
        if (fademode)
        {
            _sf = surface_create((recx2 - recx) + 4, (recy2 - recy) + 4);
            surface_set_target(_sf);
            draw_clear_alpha(c_white, 0);
            recx = 1;
            recy = 1;
            recx2 -= (_crd[0] - 1);
            recy2 -= (_crd[1] - 1);
            drawx = recx + 2;
            drawy = recy + 2;
        }
        var _col = merge_color(c_gray, c_white, topness);
        draw_set_color(_col);
        draw_rectangle(recx, recy, recx2, recy2, false);
        draw_set_color(c_black);
        draw_rectangle(recx, recy, recx2, recy2, true);
        draw_set_color(_col);
        draw_text_outline(drawx, drawy, _str);
        draw_set_color(c_white);
        if (fademode)
        {
            surface_reset_target();
            draw_surface_ditherfaded(_sf, _crd[0] - 1, _crd[1] - 1, 1 - _al);
            surface_free(_sf);
        }
    }
    if (game_mode_anim >= 0.7 && i == 1 && array_length(character.allowed_modes) > 1 && !menu_open)
    {
        if (point_in_rectangle(mouse_x, mouse_y, _crd[0], _crd[1], _crd[2], _crd[3]))
        {
            cur_hover = true;
            if (get_input_click())
            {
                switch_game_mode();
                sfx_play(snd_css_modeswap);
                sfx_play(snd_menu_click_minor);
            }
        }
    }
}
draw_set_valign(fa_bottom);
var skip_when_standard_array = ["leaderboard_button", "settings_button", "simple_mode_toggle"];
var options_str = character.options_str;
var options_onclick = character.options_onclick;
var ops_count = min(array_length(options_str), array_length(options_onclick));
draw_set_halign(fa_right);
var _skips = 0;
var i = ops_count - 1;
while (i >= 0)
{
    var _str = options_str[i];
    var _dothis = true;
    if (character.settings.mode == 0 && array_contains(skip_when_standard_array, character.options_str_original[i]))
    {
        _dothis = false;
        _skips++;
    }
    if (_dothis)
    {
        var dx = 470 + ((200 - (i * 15)) * (1 - menu_in_draw));
        dx = 470 + _offset_x;
        var dy = 260 - (20 * (ops_count - (i + _skips) - 1));
        var _scale = 1;
        var outcol = 0;
        if (i == 0)
        {
            _scale = 2;
            var _blend = abs(dcos((obj_mainmenu_controller.current_beat + 0.75) * 180));
            _blend = (1 - (obj_mainmenu_controller.current_beat % 1)) * 0.75;
            outcol = merge_color(c_black, c_fuchsia, _blend);
        }
        var topfill = 16777215;
        var topoutline = 5046318;
        var bottomfill = 14656968;
        var bottomoutline = 0;
        draw_text_outline_splitfill(dx, dy, _str, topfill, topoutline, bottomfill, bottomoutline, false, _scale, _scale, _scale);
        var x2 = dx + 1;
        var y2 = dy - 1;
        var x1 = dx - ((string_width(_str) + 2) * _scale);
        var y1 = dy - ((string_height(_str) + 2) * _scale);
        if (character.options_str_original[i] == "simple_mode_toggle")
        {
            var _size = 5;
            draw_rectangle(x2 - _size - 3, mean(y1, y2) - (_size / 2), x2 - 3, mean(y1, y2) + (_size / 2), true);
            if (!character.settings.gimmicks_enabled)
            {
                draw_rectangle(((x2 - _size) + 1) - 3, (mean(y1, y2) - (_size / 2)) + 1, x2 - 1 - 3, (mean(y1, y2) + (_size / 2)) - 1, false);
            }
        }
        if (!menu_open && point_in_rectangle(mouse_x, mouse_y, x1 - 1, y1 - 1, x2 + 1, y2 + 1))
        {
            draw_rectangle(x1, y1, x2, y2, true);
            cur_hover = can_click;
            if (click)
            {
                options_onclick[i]();
                click = false;
            }
        }
    }
    i--;
}
draw_set_halign(fa_left);
draw_set_valign(fa_top);
if (showing_steam_leaderboard)
{
    steam_leaderboard._draw();
    if (steam_leaderboard.hover)
    {
        cur_hover = true;
    }
}
if (settings_menu_open)
{
    settings_menu._draw();
    if (settings_menu.cursor_hover)
    {
        cur_hover = true;
    }
}
var cframe = cur_hover;
if (cframe == 1 && mouse_check_button(mb_left))
{
    cframe++;
}
draw_sprite(spr_cursor, cframe, mouse_x, mouse_y);

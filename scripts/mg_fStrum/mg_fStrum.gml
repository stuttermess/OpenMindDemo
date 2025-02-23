function mg_fStrum() : minigame_constructor() constructor
{
    name = "Strum";
    prompt = "STRUM!";
    use_prompt = true;
    use_timer = true;
    timer_script = timer_tutorial;
    time_limit = 16;
    show_timer_at = 8;
    music = mf3_mus;
    music_bpm = 128;
    music_loops = false;
    music_ignore_bpm = false;
    efin_skip_amount = 4;
    control_style = build_control_style(["keyboard", "mouse"]);
    gimmick_blacklist = [];
    screen_w = 480;
    screen_h = 270;
    metascript_init = mf3_metascript_init;
    metascript_tick_before = mf3_metascript_tick_before;
    metascript_tick_after = metascript_blank;
    metascript_draw_before = mf3_metascript_draw_before;
    metascript_draw_after = metascript_blank;
    metascript_cleanup = metascript_blank;
}

function mf3_metascript_init()
{
    var key_amount = 3;
    strum_sound = choose(mf3_snd_strum1, mf3_snd_strum2);
    strum_sound_inst = -1;
    controls_fade = 0;
    keys_frames = "QWEASDZXC";
    keys_to_hold_noghosting = [];
    keys_to_hold_ghosting = [];
    keys_to_hold = [];
    keys_held = [];
    keys = "QAWZSEXDC";
    switch (clamp(get_game_difficulty(), 0, 2))
    {
        case 0:
            keys = "QAWSED";
            break;
        case 1:
            keys = "QAWSDC";
            break;
        case 2:
            keys = "QAZEDC";
            break;
    }
    var _str_from = keys;
    for (var i = 0; i < key_amount; i++)
    {
        var _letter = irandom_range(1, string_length(_str_from));
        keys_to_hold_noghosting[i] = string_char_at(_str_from, _letter);
        _str_from = string_delete(_str_from, _letter, 1);
        keys_held[i] = 0;
    }
    array_sort(keys_to_hold_noghosting, function(arg0, arg1)
    {
        return string_pos(arg0, keys) - string_pos(arg1, keys);
    });
    show_debug_message(keys_to_hold_noghosting);
    array_copy(keys_to_hold_ghosting, 0, keys_to_hold_noghosting, 0, 2);
    if (get_key_ghosting_compensation())
    {
        keys_to_hold = keys_to_hold_ghosting;
    }
    else
    {
        keys_to_hold = keys_to_hold_noghosting;
    }
    fingers_held = [0, 0, 0, 0];
    var _break = choose(1, 2);
    key_to_finger = [];
    for (var i = 0; i < array_length(fingers_held); i++)
    {
        if (i != _break)
        {
            array_push(key_to_finger, i);
        }
    }
    strings = [[141, 99, 289, 177], [142, 105, 291, 183], [143, 111, 295, 190], [143, 116, 298, 197], [145, 122, 299, 202], [146, 128, 300, 206]];
    string_middle_mod = [];
    string_middle_spd = [];
    var _string_split_point = 0.8;
    for (var i = 0; i < array_length(strings); i++)
    {
        var _line = strings[i];
        var _lx1 = _line[0];
        var _ly1 = _line[1];
        var _lx2 = _line[2];
        var _ly2 = _line[3];
        var _mid_x = reverse_lerp(_lx1, _lx2, _string_split_point);
        var _mid_y = reverse_lerp(_ly1, _ly2, _string_split_point);
        array_insert(_line, 2, _mid_x);
        array_insert(_line, 3, _mid_y);
        string_middle_mod[i] = [0, 0];
        string_middle_spd[i] = [0, 0];
    }
    var arm_lerp = 0;
    arm1_x = 0;
    arm1_y = 0;
    arm1_xscale = lerp(0.75, 1, arm_lerp);
    arm1_angle = lerp(-10, -49, arm_lerp);
    arm2_x = 0;
    arm2_y = 0;
    arm2_xscale = lerp(0.1, 1, arm_lerp);
    arm2_angle = lerp(-53, -51.5, arm_lerp);
    hand_x = 0;
    hand_y = 0;
    hand_angle = lerp(0, -10, arm_lerp);
    strum_x = 0;
    strum_y = 0;
}

function mf3_metascript_tick_before()
{
    if (get_key_ghosting_compensation())
    {
        keys_to_hold = keys_to_hold_ghosting;
    }
    else
    {
        keys_to_hold = keys_to_hold_noghosting;
    }
    var input = get_input();
    var ikey = input.key;
    var _keys_held = 0;
    for (var i = 0; i < array_length(keys_to_hold); i++)
    {
        var _key = keys_to_hold[i];
        var _finger = key_to_finger[i];
        var _held = keyboard_check(ord(_key));
        keys_held[i] = _held;
        fingers_held[_finger] = _held;
        _keys_held += _held;
    }
    var arm_lerp = mouse_y / 270;
    arm1_x = 0;
    arm1_y = 0;
    arm1_xscale = lerp(0.75, 1, arm_lerp);
    arm1_angle = lerp(-10, -49, arm_lerp);
    arm2_x = 0;
    arm2_y = 0;
    arm2_xscale = lerp(0.1, 1, arm_lerp);
    arm2_angle = lerp(-53, -51.5, arm_lerp);
    hand_angle = lerp(0, -10, arm_lerp);
    var _upper_arm_offx = sprite_get_xoffset(mf3_spr_arm_upper);
    var _upper_arm_offy = sprite_get_yoffset(mf3_spr_arm_upper);
    var _upper_arm_angle = arm1_angle;
    var _upper_arm_angle_offset = 0;
    arm1_x = _upper_arm_offx;
    arm1_y = _upper_arm_offy;
    var _lower_arm_offx = sprite_get_xoffset(mf3_spr_arm_lower);
    var _lower_arm_offy = sprite_get_yoffset(mf3_spr_arm_lower);
    var _len = point_distance(_upper_arm_offx, _upper_arm_offy, _lower_arm_offx, _lower_arm_offy) * arm1_xscale;
    var _dir = point_direction(_upper_arm_offx, _upper_arm_offy, _lower_arm_offx, _lower_arm_offy) + _upper_arm_angle + _upper_arm_angle_offset;
    var _lower_arm_x = _upper_arm_offx + lengthdir_x(_len, _dir);
    var _lower_arm_y = _upper_arm_offy + lengthdir_y(_len, _dir);
    var _lower_arm_angle = arm2_angle;
    var _lower_arm_angle_offset = 0;
    arm2_x = _lower_arm_x;
    arm2_y = _lower_arm_y;
    var _hand_offx = sprite_get_xoffset(mf3_spr_hand);
    var _hand_offy = sprite_get_yoffset(mf3_spr_hand);
    _len = 102 * arm2_xscale;
    _dir = _lower_arm_angle;
    var _hand_x = _lower_arm_x + lengthdir_x(_len, _dir);
    var _hand_y = _lower_arm_y + lengthdir_y(_len, _dir);
    var prev_hand_x = hand_x;
    var prev_hand_y = hand_y;
    var prev_strum_x = strum_x;
    var prev_strum_y = strum_y;
    hand_x = _hand_x;
    hand_y = _hand_y;
    strum_x = hand_x + lengthdir_x(-121.43, 22.09 + hand_angle);
    strum_y = hand_y + lengthdir_y(-121.43, 22.09 + hand_angle);
    strings_strumming = 0;
    for (var i = 0; i < array_length(strings); i++)
    {
        var _line = strings[i];
        _line = strings[i];
        var _lx1 = _line[2];
        var _ly1 = _line[3];
        var _lx2 = _line[4];
        var _ly2 = _line[5];
        var nearest_point = nearest_point_on_line(strum_x, strum_y, _lx1, _ly1, _lx2, _ly2);
        if (_keys_held >= array_length(keys_to_hold) && prev_strum_y < nearest_point[1] && strum_y > nearest_point[1])
        {
            var _strum_spd = clamp(point_distance(prev_strum_x, prev_strum_y, strum_x, strum_y) / 2.5, 0, 2);
            string_middle_spd[i][0] = lengthdir_x(_strum_spd, -119);
            string_middle_spd[i][1] = lengthdir_y(_strum_spd, -119);
            strings_strumming += (abs(_strum_spd) >= 0.3);
        }
        string_middle_mod[i][0] += string_middle_spd[i][0];
        string_middle_mod[i][1] += string_middle_spd[i][1];
        string_middle_spd[i][0] = array_get(spring(string_middle_mod[i][0], string_middle_spd[i][0], 0, 0.6, 0.25), 1);
        string_middle_spd[i][1] = array_get(spring(string_middle_mod[i][1], string_middle_spd[i][1], 0, 0.6, 0.25), 1);
    }
    if (strings_strumming >= (array_length(strings) / 2) && _keys_held >= array_length(keys_to_hold))
    {
        if (get_win_state() == 0)
        {
            if (strum_sound_inst != -1 && audio_is_playing(strum_sound_inst))
            {
                audio_stop_sound(strum_sound_inst);
            }
            strum_sound_inst = sfx_play(strum_sound);
        }
        else
        {
            sfx_play(mf3_snd_deadstrum);
        }
        game_win();
    }
    controls_fade = lerp(controls_fade, get_win_state() == 1, 0.2);
}

function mf3_metascript_draw_before()
{
    var _cf = get_current_frame();
    draw_sprite(mf3_spr_bg, 0, 0, 0);
    draw_sprite(mf3_spr_body, 0, 0, 0);
    draw_sprite_ext(mf3_spr_arm_upper, 0, arm1_x, arm1_y, arm1_xscale, 1, arm1_angle, c_white, 1);
    draw_sprite(mf3_spr_body, 1, 0, 0);
    draw_sprite(mf3_spr_strings, 0, 0, 0);
    draw_sprite(mf3_spr_strings, 1, 0, 0);
    for (var i = 0; i < array_length(strings); i++)
    {
        var _line = strings[i];
        for (var j = 0; j < (array_length(_line) - 2); j += 2)
        {
            var _lx1 = _line[j];
            var _ly1 = _line[j + 1];
            var _lx2 = _line[j + 2];
            var _ly2 = _line[j + 3];
            if (j == 0)
            {
                _lx2 += string_middle_mod[i][0];
                _ly2 += string_middle_mod[i][1];
            }
            else if (j == 2)
            {
                _lx1 += string_middle_mod[i][0];
                _ly1 += string_middle_mod[i][1];
            }
            draw_set_color(#DAC496);
            draw_line(_lx1, _ly1, _lx2, _ly2);
            draw_set_color(#4A652A);
            draw_line(_lx1, _ly1 + 1, _lx2, _ly2 + 1);
        }
    }
    draw_set_color(c_white);
    draw_sprite_ext(mf3_spr_arm_lower, 0, arm2_x, arm2_y, arm2_xscale, 1, arm2_angle, c_white, 1);
    draw_sprite_ext(mf3_spr_hand, 0, hand_x, hand_y, 1, 1, hand_angle, c_white, 1);
    draw_sprite(mf3_spr_fingerpinkie, fingers_held[3], 0, 0);
    draw_sprite(mf3_spr_fingerring, fingers_held[2], 0, 0);
    draw_sprite(mf3_spr_fingermiddle, fingers_held[1], 0, 0);
    draw_sprite(mf3_spr_fingerindex, fingers_held[0], 0, 0);
    var _frame = sprite_get_speed(mf3_spr_key) * (_cf / 60);
    var _keys_held_amt = 0;
    var _keys_amt = array_length(keys_to_hold);
    for (var i = 0; i < _keys_amt; i++)
    {
        var _key = keys_to_hold[i];
        var _letter_frame = string_pos(_key, keys_frames) - 1;
        var _kx = 300 + (((i + 0.5) - (_keys_amt / 2)) * 50);
        var _ky = 50;
        var _spr = mf3_spr_key;
        if (keys_held[i])
        {
            _spr = mf3_spr_keypressed;
            _ky += 2;
            _keys_held_amt++;
        }
        draw_sprite_ditherfaded(_spr, _frame, _kx, _ky, controls_fade);
        draw_sprite_ditherfaded(mf3_spr_keys, _letter_frame, _kx, _ky, controls_fade);
    }
    var _strum_ready = _keys_held_amt >= array_length(keys_to_hold);
    if (!_strum_ready && get_win_state() == 0)
    {
        _frame = sprite_get_speed(mf3_spr_hold) * (_cf / 60);
        draw_sprite_ditherfaded(mf3_spr_hold, _frame, 300, 80, controls_fade);
    }
    if (_strum_ready)
    {
        var _strum_indicator_x = 421;
        var _strum_indicator_y = 159;
        var _mouse_indicator_y = lerp(_strum_indicator_y, _strum_indicator_y + 86, lerp_easeIn(mouse_y / 270));
        var arrow_yscale = 1;
        if (mouse_y > 228 && get_win_state() == 0)
        {
            arrow_yscale = -1;
        }
        _frame = sprite_get_speed(mf3_spr_arrow) * (_cf / 60);
        draw_sprite_ditherfaded(mf3_spr_arrow, _frame, _strum_indicator_x, _strum_indicator_y, controls_fade, 1, arrow_yscale, 0, 16777215, 1);
        _frame = sprite_get_speed(mf3_spr_mouse) * (_cf / 60);
        draw_sprite_ditherfaded(mf3_spr_mouse, _frame, _strum_indicator_x, _mouse_indicator_y, controls_fade);
    }
}

function mf3scr_guy_init()
{
}

function mf3scr_guy_tick()
{
}

function ibt_generic() : inbetween_constructor() constructor
{
    draws_minigame_surface = true;
    intro_length = 12;
    
    get_intro_jingle = function()
    {
        return ibtG_snd_endlessintro;
    };
    
    get_prep_jingle = function()
    {
        return ibtG_snd_prep;
    };
    
    get_win_jingle = function()
    {
        return ibtG_snd_win;
    };
    
    get_lose_jingle = function()
    {
        return ibtG_snd_lose;
    };
    
    get_speedup_jingle = function()
    {
        return ibtG_snd_speedup;
    };
    
    get_boss_jingle = function()
    {
        return ibtG_snd_boss;
    };
    
    minigame_intro_length = 1;
    minigame_outro_length = 1;
    lives_pos = [[39, 70], [120, 45], [360, 45], [441, 70]];
    
    __init = function()
    {
        death_life_x = 0;
        death_life_y = 0;
        death_life_xv = 0;
        death_life_yv = 0;
        cam_bump_in = 0;
        life_lose_sound_play = 0;
        play_elev_close_sound();
        elev_open_sound_play = 0;
    };
    
    __tick = function()
    {
        var beat = obj_minigame_controller.inbetween_length - inbetween_timer;
        cam_bump_in = lerp(cam_bump_in, 0, 0.3);
        if (success_state == -1)
        {
            if (beat >= 1)
            {
                if (death_life_xv == 0)
                {
                    death_life_xv = 5;
                    death_life_yv = -15;
                    cam_bump_in = 1;
                }
                else
                {
                    death_life_x += death_life_xv;
                    death_life_y += death_life_yv;
                    death_life_yv += 1;
                }
            }
        }
    };
    
    __draw = function()
    {
        draw_clear(c_black);
        var beat = obj_minigame_controller.inbetween_length - inbetween_timer;
        beat = max(0, beat);
        var beat1 = beat % 1;
        var elevator_open = 0;
        var elevator_open_nolerp = 0;
        if (inbetween_timer < minigame_intro_length)
        {
            if (obj_minigame_controller.inbetween_type != 3)
            {
                elevator_open_nolerp = (minigame_intro_length - inbetween_timer) / minigame_intro_length;
                elevator_open = lerp_easeIn(elevator_open_nolerp);
                if (elev_open_sound_play == 0)
                {
                    sfx_play(ibtG_voice_elevator_open, 0, 1, 0, get_game_speed());
                    elev_open_sound_play = 1;
                }
            }
        }
        else if (beat < minigame_outro_length)
        {
            elevator_open_nolerp = lerp(1, 0, beat);
            elevator_open = lerp(1, 0, lerp_easeOut(beat));
        }
        elevator_open = clamp(elevator_open, 0, 1);
        var elevator_zoom_end = 6;
        var cam_zoom = lerp(1, elevator_zoom_end + (cam_bump_in * 0.5), elevator_open);
        var cam_y = 0;
        var _speedup_lerp = 0;
        var ibtt = obj_minigame_controller.inbetween_type;
        if (ibtt == 1 || ibtt == 5)
        {
            if (beat >= 3.5 && beat < 8.5)
            {
                var _lerp = 0;
                if (beat >= 3.5 && beat < 4)
                {
                    _lerp = lerp_easeInOut((beat - 3.5) / 0.5);
                }
                else if (beat >= 4 && beat < 7.5)
                {
                    _lerp = 1;
                }
                else if (beat >= 7.5 && beat < 8)
                {
                    _lerp = lerp_easeInOut(1 - ((beat - 7.5) / 0.5));
                }
                else
                {
                    _lerp = 0;
                }
                cam_y = lerp(0, -150, _lerp);
                cam_zoom = lerp(1, 2, _lerp);
                _speedup_lerp = _lerp;
            }
        }
        var default_matrix = matrix_build(240, 135 - cam_y, 0, 0, 0, 0, cam_zoom, cam_zoom, cam_zoom);
        matrix_set(2, default_matrix);
        if (elevator_open > 0)
        {
            var mg_x = 240;
            var elevtop = max(lerp(70, 70 - (34.666666666666664 * elevator_zoom_end), elevator_open), 0);
            var mg_y = lerp(mean(elevtop, 270), 135, elevator_open);
            var mg_scale = lerp((270 - elevtop) / 270, 1, elevator_open);
            matrix_set(2, matrix_build(0, 0, 0, 0, 0, 0, 1, 1, 1));
            draw_minigame_surface(mg_x, mg_y, mg_scale, mg_scale, 0);
            matrix_set(2, default_matrix);
            draw_sprite(ibtG_spr_elevator_inside_mask, 0, 0, 0);
        }
        var row_back_sprite, row_mid_sprite, row_front_sprite, life_sprite;
        if (success_state == -1)
        {
            life_sprite = ibtG_spr_life_sad;
            row_back_sprite = ibtG_spr_row_back_sad;
            row_mid_sprite = ibtG_spr_row_mid_sad;
            row_front_sprite = ibtG_spr_row_front_sad;
        }
        else
        {
            life_sprite = ibtG_spr_life_idle;
            row_back_sprite = ibtG_spr_row_back;
            row_mid_sprite = ibtG_spr_row_mid;
            row_front_sprite = ibtG_spr_row_front;
        }
        matrix_set(2, default_matrix);
        draw_sprite(row_back_sprite, sprite_get_number(row_back_sprite) * beat1, 0, 0);
        draw_sprite(row_mid_sprite, sprite_get_number(row_mid_sprite) * beat1, 0, 0);
        draw_sprite(row_front_sprite, sprite_get_number(row_front_sprite) * beat1, 0, 0);
        var elev_multiplier = 1;
        if ((obj_minigame_controller.inbetween_timer > 1 || obj_minigame_controller.inbetween_type == 3) && !success_state != -1)
        {
            elev_multiplier += ((1 - ((clamp(beat1 - 0.5, -0.5, 0) + 0.5) / 0.5)) * 0.05);
        }
        matrix_set(2, matrix_multiply(matrix_build(0, 0, 0, 0, 0, 0, elev_multiplier, elev_multiplier, elev_multiplier), default_matrix));
        if (_speedup_lerp > 0)
        {
            var prev_mat = matrix_get(2);
            matrix_set(2, matrix_build(240, 135, 0, 0, 0, 0, 1, 1, 1));
            var speedupguys_top_frame = sprite_get_number(ibtG_spr_speedupguys_top) * beat1;
            var speedupguys_top_y = lerp(-120, 0, _speedup_lerp);
            draw_sprite(ibtG_spr_speedupguys_top, speedupguys_top_frame, 0, speedupguys_top_y);
            var speedupguys_frame = sprite_get_number(ibtG_spr_speedupguys) * beat1;
            var speedupguys_x = lerp(160, 0, _speedup_lerp);
            draw_sprite_ext(ibtG_spr_speedupguys, speedupguys_frame, speedupguys_x, 0, 1, 1, 0, c_white, 1);
            draw_sprite_ext(ibtG_spr_speedupguys, speedupguys_frame, -speedupguys_x, 0, -1, 1, 0, c_white, 1);
            matrix_set(2, prev_mat);
        }
        draw_sprite(ibtG_spr_elevator_doors, (sprite_get_number(ibtG_spr_elevator_doors) - 1) * elevator_open, 0, 0);
        draw_sprite(ibtG_spr_elevator, sprite_get_number(ibtG_spr_elevator) * beat1, 0, 0);
        if (_speedup_lerp == 1)
        {
            var _str = "SPEED UP";
            if (ibtt == 5)
            {
                _str = "LEVEL UP";
            }
            if (beat1 <= 0.5)
            {
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_set_color(#FF55FF);
                draw_text(0, -100, _str);
                draw_set_halign(fa_left);
                draw_set_valign(fa_top);
                draw_set_color(c_white);
            }
        }
        else
        {
            draw_sprite(ibtG_spr_numbersL, floor(_round / 10), 0, 0);
            draw_sprite(ibtG_spr_numbersR, _round, 0, 0);
        }
        matrix_set(2, default_matrix);
        _draw_100_stars(-240, -135);
        var _deathanim = bool(success_state == -1);
        for (var i = 0; i < (_lives + _deathanim); i++)
        {
            var pos = lives_pos[i % array_length(lives_pos)];
            var _lx = pos[0] - 240;
            _lx += lerp(0, sign(_lx - 0) * 40, _speedup_lerp);
            var _ly = pos[1] - 120;
            var _lf = sprite_get_number(life_sprite) * beat1;
            if (_deathanim)
            {
                _lf = sprite_get_number(life_sprite) * 2.5 * beat1;
            }
            var _xs = 1;
            var _ys = 1;
            var _r = 0;
            if (i >= 2)
            {
                _xs = -1;
            }
            if (i >= _lives)
            {
                var _current_beat = obj_minigame_controller.inbetween_length - inbetween_timer;
                life_sprite = ibtG_spr_life_die;
                if (_current_beat >= 1)
                {
                    _ly += death_life_y;
                    _lx += (death_life_x * _xs);
                    _r += (death_life_x * _xs);
                    if (life_lose_sound_play == 0)
                    {
                        sfx_play(ibtG_voice_life_lose, 0, 1, 0, get_game_speed());
                        life_lose_sound_play = 1;
                    }
                }
                else
                {
                    life_lose_sound_play = 0;
                }
            }
            draw_sprite_ext(life_sprite, _lf, _lx, _ly, _xs, _ys, _r, c_white, 1);
        }
        var cprompt_time = 3 - inbetween_timer;
        if (cprompt_time > 0 && obj_minigame_controller.inbetween_type != 3)
        {
            var _ele_open = (minigame_intro_length - inbetween_timer) / minigame_intro_length;
            draw_generic_control_prompt(next_control_style, cprompt_time, 0, 0, _ele_open);
        }
        matrix_set(2, matrix_build_identity());
    };
    
    __on_return = function()
    {
        death_life_x = 0;
        death_life_y = 0;
        death_life_xv = 0;
        death_life_yv = 0;
        elev_open_sound_play = 0;
        play_elev_close_sound();
    };
    
    play_elev_close_sound = function()
    {
        sfx_play(ibtG_voice_elevator_close, 0, 1, 0.25, get_game_speed());
    };
}

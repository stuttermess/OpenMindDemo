function ibt_tutorial() : inbetween_constructor() constructor
{
    get_intro_jingle = function()
    {
        return -1;
    };
    
    get_boss_jingle = function()
    {
        return -1;
    };
    
    get_prep_jingle = function()
    {
        return ibtT_mus_prep;
    };
    
    get_win_jingle = function()
    {
        return ibtT_mus_win;
    };
    
    get_lose_jingle = function()
    {
        return ibtT_mus_lose;
    };
    
    get_speedup_jingle = function()
    {
        return ibtT_mus_speedup;
    };
    
    draws_minigame_surface = true;
    minigame_intro_length = 2;
    minigame_outro_length = 2;
    
    __init = function()
    {
        prepare_sound_play = 0;
        if (obj_minigame_controller.endless_mode)
        {
            start_offset = 0;
            scene = 1;
            bg_alpha = 1;
            minigame_intro_length = 3;
            minigame_outro_length = 3;
        }
        else
        {
            start_offset = character.get_start_offset();
            scene = 0;
            bg_alpha = 0;
            sfx_play(snd_ibtT_woosh, false, 0.8);
        }
        overlay_alpha = 0;
        music_gain = 1;
        pandora_y = 540;
        bg_y_start = -10000;
        bg_y = bg_y_start;
        scroll_y = 0;
        bg_scroll = 0;
        move_tut_text = false;
        outro_start_beat = -1;
        outro_end_beat = -1;
        nonstop_mode = false;
        tut_text_in = 0;
        controls_in = 0;
        show_controls = false;
        controls_frame = 0;
        controls_frames = [0];
        speaker_in = 0;
        speaker_tb_in = 0;
        animate_speaker = false;
        do_text = true;
        tb_x = 390;
        tb_y = 202;
        speaker_frame = 0;
        message_entry = 0;
        progress = 0;
        this_mg_losses = 0;
        voice_syllables = [];
        array_shuffle_ext(voice_syllables);
        voice_syllable_num = 0;
        voice_sound = -1;
        first_fail_script = "scripts/0/tutorial/first_fail.mwsc";
        done_loss = false;
        _minigame_controls = [0, 2, 1, 3, 4, 5, -1];
        mwsc = new mwsc_instance();
        mwsc.text_voice = new charvoice_high();
        mwsc.text_voice.sounds = [ibtT_snd_voice];
        mwsc.text_voice._mod = 3;
        mwsc.text_voice.gain = 1;
        mwsc.text_voice.pitch_variance = 0.3;
        mwsc.text_finish_sound = snd_dialogue_textfinish;
        mwsc.add_custom_parse_func("show_controls", function(arg0)
        {
            arg0 = arg0.args;
            array_push(mwsc.events, ["show_controls"]);
        });
        mwsc.add_custom_script_event_func("show_controls", function(arg0)
        {
            show_controls = true;
            controls_frame = _minigame_controls[_round];
        });
        mwsc.add_custom_parse_func("end", function(arg0)
        {
            arg0 = arg0.args;
            array_push(mwsc.events, ["end"]);
        });
        mwsc.add_custom_script_event_func("end", function(arg0)
        {
            start_end_animation();
        });
        mwsc.add_custom_parse_func("nonstop_mode", function(arg0)
        {
            arg0 = arg0.args;
            array_push(mwsc.events, ["nonstop_mode", real(arg0[1])]);
        });
        mwsc.add_custom_script_event_func("nonstop_mode", function(arg0)
        {
            var _ev = arg0.args;
            nonstop_mode = _ev[1];
            obj_minigame_controller.char.next_round_on_lose = !nonstop_mode;
        });
        nonstop_mode = false;
        
        mwsc.on_end = function()
        {
            if (scene == 1)
            {
                start_minigame();
            }
        };
        
        textbox = mwsc.textbox;
        textbox.halign = 1;
        textbox.valign = 1;
        textbox.width = 120;
        textbox.height = 100;
        textbox.color = 0;
        script_gotten = false;
        first_fail = false;
        
        get_round_script = function()
        {
            set_story_flag("_0.tutorial.fails", this_mg_losses);
            var _scriptpath = "";
            if (first_fail && !nonstop_mode)
            {
                _scriptpath = first_fail_script;
            }
            else
            {
                switch (_round)
                {
                    case 0:
                    case 1:
                    case 2:
                    case 3:
                    case 4:
                    case 5:
                    case 6:
                        _scriptpath = "scripts/0/tutorial/" + string(_round) + ".mwsc";
                        if (_round == 12)
                        {
                            nonstop_mode = false;
                        }
                        break;
                    default:
                        break;
                }
            }
            if (_scriptpath == "")
            {
                mwsc.events = [];
                mwsc.script = [];
                mwsc.current_event = 0;
                mwsc.text = "";
            }
            else
            {
                mwsc.load_script_file(_scriptpath);
            }
            script_gotten = true;
            mwsc.perform_current_event();
        };
        
        ibt_len = infinity;
        t = 0;
    };
    
    __on_return = function()
    {
        if (obj_minigame_controller.endless_mode)
        {
            if (success_state == 1)
            {
                minigame_outro_length = 3;
            }
            else
            {
                minigame_outro_length = 4;
            }
        }
        switch (get_win_state())
        {
            case 1:
                sfx_play(ibtT_snd_win, 0, 1, 0, get_sound_pitch());
                break;
            case -1:
                sfx_play(ibtT_snd_lose, 0, 1, 0, get_sound_pitch());
                break;
        }
        prepare_sound_play = 0;
        controls_in = 0;
        show_controls = false;
        scene = 1;
        if (obj_minigame_controller.endless_mode)
        {
            exit;
        }
        ibt_len = infinity;
        obj_minigame_controller.inbetween_length = ibt_len;
        switch (success_state)
        {
            case -1:
            case 0:
                this_mg_losses++;
                break;
            case 1:
                this_mg_losses = 0;
                progress++;
                break;
        }
        first_fail = false;
        if (success_state == -1)
        {
            if (this_mg_losses == 1 && !done_loss)
            {
                first_fail = true;
                done_loss = true;
                this_mg_losses = 0;
            }
        }
        if (!do_text)
        {
            do_text = true;
            get_round_script();
        }
    };
    
    intro_length = 0;
    endless_get_inbetween_length = get_inbetween_length;
    
    get_inbetween_length = function(arg0)
    {
        if (obj_minigame_controller.endless_mode)
        {
            return endless_get_inbetween_length(arg0);
        }
        return ibt_len;
    };
    
    __tick = function()
    {
        var beat = current_beat - obj_minigame_controller.inbetween_start_beat;
        if (obj_minigame_controller.endless_mode)
        {
            move_tut_text = true;
            tut_text_in = 1;
        }
        else
        {
            character._lives = 4;
        }
        switch (scene)
        {
            case 0:
                intro_time = character.intro_time * 5;
                if (intro_time < 5)
                {
                    var p_up = -20;
                    if (intro_time <= 0.5)
                    {
                        pandora_y = 540;
                        bg_y = bg_y_start;
                    }
                    else if (intro_time > 0.5 && intro_time < 4.5)
                    {
                        var prog = (intro_time - 0.5) / 4;
                        prog = clamp(prog, 0, 1);
                        pandora_y = lerp(540, 270 + p_up, lerp_easeOutCubic(prog));
                    }
                    else
                    {
                        var prog = (intro_time - 4.5) / 0.5;
                        prog = clamp(prog, 0, 1);
                        pandora_y = lerp(270 + p_up, 275, lerp_easeInBack(prog));
                    }
                    bg_alpha = clamp((intro_time - 0.5) / 3.5, 0, 1);
                    if (intro_time > 0.5 && intro_time < 4.5)
                    {
                        var prog = (intro_time - 0.5) / 4;
                        prog = clamp(prog, 0, 1);
                        bg_y = lerp(bg_y_start, 10 + (prog * 5), lerp_easeOutQuad(prog));
                    }
                    else
                    {
                        var prog = (intro_time - 4.5) / 0.5;
                        prog = clamp(prog, 0, 1);
                        bg_y = lerp(15, -60, lerp_easeInBack(prog));
                    }
                    if (intro_time > 4.5)
                    {
                        move_tut_text = true;
                    }
                }
                else
                {
                    pandora_y = 270 + (clamp(1 - (current_beat * 2), 0, 1) * 5);
                    bg_y = -60 + (clamp(1 - (current_beat * 0.5), 0, 1) * -10);
                    bg_alpha = 1;
                    scene = 1;
                    move_tut_text = true;
                }
                break;
            case 1:
                pandora_y = 270 + (clamp(1 - (current_beat * 2), 0, 1) * 5);
                speaker_in += (sign(1 - speaker_in) * 0.005555555555555556);
                speaker_tb_in += (sign(1 - speaker_tb_in) * 0.005);
                if (abs(1 - speaker_tb_in) <= 0.005)
                {
                    speaker_tb_in = 1;
                }
                controls_in += (sign(real(show_controls) - controls_in) * 0.011111111111111112);
                break;
            case 2:
                var prev_outro_prog = max((prev_current_beat - outro_start_beat) / (outro_end_beat - outro_start_beat), 0);
                var outro_prog = max((current_beat - outro_start_beat) / (outro_end_beat - outro_start_beat), 0);
                var outro_beat = current_beat - outro_start_beat;
                var prev_bg_y = lerp(-70, -bg_y_start, lerp_easeIn(prev_outro_prog));
                bg_y = lerp(-70, -bg_y_start, lerp_easeIn(outro_prog));
                var prev_scroll_y = scroll_y;
                scroll_y = bg_y + 70;
                var scroll_y_diff = abs(scroll_y - prev_scroll_y);
                if ((270 + scroll_y_diff) > pandora_y)
                {
                    pandora_y = 270 + scroll_y_diff;
                }
                bg_alpha = lerp(1, 0.1, lerp_easeIn(outro_prog));
                overlay_alpha = lerp_easeIn(outro_prog);
                if (outro_prog < 0.5)
                {
                    audio_sound_gain(obj_minigame_controller.game_music, (1 - (outro_prog / 0.5)) * music_gain, 0);
                }
                else
                {
                    var _weird_part_prog = (outro_prog - 0.5) / 0.5;
                    audio_sound_gain(obj_minigame_controller.game_music, _weird_part_prog * music_gain, 0);
                    var _pitch = lerp(1, 3, lerp_easeIn(_weird_part_prog));
                    _pitch *= random_range(0.8, 1.2);
                    audio_sound_pitch(obj_minigame_controller.game_music, _pitch);
                }
                if (outro_prog > 1.1)
                {
                    character._end_game();
                    exit;
                }
                break;
        }
        if (obj_minigame_controller.endless_mode)
        {
            move_tut_text = true;
        }
        if (move_tut_text)
        {
            tut_text_in += (sign(1 - tut_text_in) * (1 / (room_speed * 1)));
        }
        if (animate_speaker)
        {
        }
        if (obj_minigame_controller.endless_mode)
        {
            bg_scroll++;
            t++;
            prev_current_beat = current_beat;
            exit;
        }
        speaker_frame = (current_beat * 4) % 12;
        if (speaker_tb_in >= 0.9 && do_text && (beat > minigame_outro_length || obj_minigame_controller.inbetween_type == 4))
        {
            if (!script_gotten)
            {
                get_round_script();
            }
            animate_speaker = mwsc.current_letter < string_length(mwsc.text) || (animate_speaker && speaker_frame < 2.5);
            if (nonstop_mode)
            {
                start_minigame();
            }
            else
            {
                mwsc.tick();
            }
        }
        bg_scroll++;
        t++;
        prev_current_beat = current_beat;
    };
    
    start_end_animation = function()
    {
        scene = 2;
        outro_start_beat = ceil(current_beat);
        outro_end_beat = outro_start_beat + 12;
        music_gain = audio_sound_get_gain(obj_minigame_controller.game_music);
    };
    
    start_minigame = function()
    {
        with (obj_minigame_controller)
        {
            inbetween_start_beat = ceil(current_beat);
            inbetween_length = minigame_intro_length;
        }
        do_text = false;
    };
    
    __draw = function()
    {
        draw_clear(c_white);
        var beat = current_beat - obj_minigame_controller.inbetween_start_beat;
        beat = max(0, beat);
        var beat1 = beat % 1;
        var speedup_levelup_anim = 1;
        var mg_intro_anim = 0;
        var mg_outro_anim = 1;
        var bg_scale = 1;
        var speedup_interrupt_in = 0;
        if (current_beat > obj_minigame_controller.inbetween_start_beat)
        {
            if (inbetween_timer < minigame_intro_length)
            {
                if (obj_minigame_controller.inbetween_type != 3)
                {
                    mg_intro_anim = (minigame_intro_length - inbetween_timer) / minigame_intro_length;
                    mg_outro_anim = 1;
                    bg_scale = lerp(1, 1.75, lerp_easeIn(clamp((mg_intro_anim - 0.55) / 0.45, 0, 1)));
                }
            }
            else if (beat < minigame_outro_length)
            {
                if (obj_minigame_controller.inbetween_type != 4)
                {
                    mg_intro_anim = 0;
                    mg_outro_anim = clamp(beat / minigame_outro_length, 0, 1);
                }
            }
            var ibtt = obj_minigame_controller.inbetween_type;
            if ((ibtt == 1 || ibtt == 5) || obj_minigame_controller.inbetween_type == 5)
            {
                if (inbetween_timer > 4 && inbetween_timer < 8)
                {
                    speedup_levelup_anim = (8 - inbetween_timer) / 4;
                    var _speedup_beats = speedup_levelup_anim * 4;
                    var _down_how_MUCH = -60;
                    if (_speedup_beats < 1)
                    {
                        speedup_interrupt_in = lerp(0, 1, lerp_easeOutBack(_speedup_beats) / 1);
                    }
                    else if (_speedup_beats < 3)
                    {
                        speedup_interrupt_in = 1;
                    }
                    else
                    {
                        speedup_interrupt_in = lerp(1, 0, lerp_easeIn(_speedup_beats - 3) / 1);
                    }
                    bg_y = -70 + lerp(0, _down_how_MUCH, speedup_interrupt_in);
                }
            }
        }
        mg_intro_anim = clamp(mg_intro_anim, 0, 1);
        mg_outro_anim = clamp(mg_outro_anim, 0, 1);
        speedup_levelup_anim = clamp(speedup_levelup_anim, 0, 1);
        var speedup_or_levelup = 0;
        if (obj_minigame_controller.inbetween_type == 1)
        {
            speedup_or_levelup = 1;
        }
        if (obj_minigame_controller.inbetween_type == 5)
        {
            speedup_or_levelup = 2;
        }
        var draw_idle_pandora = mg_intro_anim <= 0 && mg_outro_anim >= 1 && speedup_levelup_anim >= 1;
        
        var set_scale = function(arg0)
        {
            var _transform_matrix_base = matrix_build_identity();
            _transform_matrix_base = matrix_multiply(_transform_matrix_base, matrix_build(-240, -135, 0, 0, 0, 0, 1, 1, 1));
            _transform_matrix_base = matrix_multiply(_transform_matrix_base, matrix_build(0, 0, 0, 0, 0, 0, arg0, arg0, arg0));
            _transform_matrix_base = matrix_multiply(_transform_matrix_base, matrix_build(240, 135, 0, 0, 0, 0, 1, 1, 1));
            matrix_set(2, _transform_matrix_base);
        };
        
        set_scale(lerp(1, 2, bg_scale - 1));
        draw_sprite_tiled(ibtT_spr_bgthing2, 0, round(bg_scroll / 3), round((bg_scroll / 3) + bg_y));
        set_scale(lerp(1, 2, bg_scale - 1));
        draw_sprite_tiled(ibtT_spr_bgthing1, 0, bg_scroll, -bg_scroll + bg_y);
        if (speedup_levelup_anim < 1)
        {
            var _frame = speedup_or_levelup;
            var _fade = 0;
            var _anim = speedup_levelup_anim;
            if (_anim < 0.1)
            {
                _fade = lerp(1, 0, _anim / 0.1);
            }
            else if (_anim > 0.9)
            {
                _fade = lerp(0, 1, (_anim - 0.9) / 0.1);
            }
            set_scale(lerp(1, 2, bg_scale - 1));
            draw_sprite_tiled_ditherfaded(ibtT_spr_bgthing2, _frame, round(bg_scroll / 3), round((bg_scroll / 3) + bg_y), _fade);
            set_scale(lerp(1, 2, bg_scale - 1));
            draw_sprite_tiled_ditherfaded(ibtT_spr_bgthing1, _frame, bg_scroll, -bg_scroll + bg_y, _fade);
        }
        set_scale(bg_scale);
        draw_set_alpha(1 - bg_alpha);
        draw_rectangle(-1, -1, 481, 481, false);
        draw_set_alpha(1);
        var title_tutorial_y = lerp(-100, 0, lerp_easeOutBack(tut_text_in)) + lerp(0, -100, speedup_interrupt_in);
        var _title_spr = ibtT_spr_title_tutorial;
        if (obj_minigame_controller.endless_mode)
        {
            _title_spr = ibtT_spr_title_endless;
        }
        draw_sprite_ext(_title_spr, current_beat * 2, 0, scroll_y + title_tutorial_y, 1, 1, 0, c_white, 0.7);
        if (speedup_or_levelup)
        {
            var _interrupt_title_spr = ibtT_spr_title_speedup;
            if (speedup_or_levelup == 2)
            {
                _interrupt_title_spr = ibtT_spr_title_levelup;
            }
            draw_sprite_ext(_interrupt_title_spr, current_beat * 2, 0, scroll_y + lerp(-100, 0, speedup_interrupt_in), 1, 1, 0, c_white, 0.7);
        }
        if (obj_minigame_controller.endless_mode)
        {
            var _status_x = 390;
            var _status_y = 202 + lerp(0, -15, speedup_interrupt_in);
            draw_sprite(ibtT_spr_endless_status_box, 0, _status_x, _status_y);
            draw_sprite_ext(ibtT_spr_tutoguy2_solo, current_beat * 2, _status_x, _status_y - 50, -1, 1, 0, c_white, 1);
            draw_sprite(ibtT_spr_endless_status_box_livesnum, _lives, _status_x, _status_y);
            var __round = _round;
            if (__round < 100)
            {
                draw_sprite(ibtT_spr_endless_status_box_roundnum, floor(__round / 10), _status_x, _status_y);
                draw_sprite(ibtT_spr_endless_status_box_roundnum, __round, _status_x + 22, _status_y);
            }
            else
            {
                draw_sprite(ibtT_spr_endless_status_box_roundnum, floor(__round / 100), _status_x - 5, _status_y);
                draw_sprite(ibtT_spr_endless_status_box_roundnum, floor(__round / 10), _status_x + 12, _status_y);
                draw_sprite(ibtT_spr_endless_status_box_roundnum, __round, _status_x + 29, _status_y);
            }
        }
        else
        {
            var speaker_x = lerp(160, 0, lerp_easeInOut(speaker_in));
            var speaker_y = scroll_y + (dsin(((current_beat + 2) / 4) * 360) * 4);
            var textbox_x = lerp(240, 0, lerp_easeInOut(speaker_tb_in));
            var textbox_y = scroll_y;
            var speaker_sprite = ibtT_spr_tutoguy;
            if (animate_speaker)
            {
                speaker_sprite = ibtT_spr_tutoguytalk;
            }
            draw_sprite(ibtT_spr_textbox, 0, textbox_x, textbox_y);
            if (mwsc.current_letter >= string_length(mwsc.text) && mwsc.text != "" && scene == 1 && do_text)
            {
                draw_sprite(ibtT_spr_textbox_arrow, 0, textbox_x, textbox_y + round(dsin((current_beat + 0.5) * 180)));
            }
            draw_sprite(speaker_sprite, speaker_frame, speaker_x, speaker_y);
            draw_set_color(c_black);
            mwsc.draw(textbox_x + tb_x, textbox_y + tb_y);
            draw_set_color(c_white);
        }
        if (draw_idle_pandora)
        {
            draw_sprite(ibtT_spr_pandorapreparing, current_beat * 4, 240, pandora_y);
        }
        else if (speedup_levelup_anim < 1)
        {
            var _fr = sprite_get_number(ibtT_spr_pandoraspeedup) * speedup_levelup_anim;
            draw_sprite(ibtT_spr_pandoraspeedup, _fr, 240, pandora_y);
        }
        var controls_x = lerp(-160, 0, lerp_easeInOut(controls_in));
        var controls_y = scroll_y + (dsin((current_beat / 4) * 360) * 4);
        draw_sprite(ibtT_spr_tutoguy2, current_beat * 4, controls_x, controls_y);
        draw_sprite(ibtT_spr_controls, controls_frame, controls_x + 81, controls_y + 160);
        set_scale(1);
        _draw_100_stars();
        if (mg_intro_anim > 0)
        {
            if (prepare_sound_play == 0)
            {
                sfx_play(ibtT_snd_preparing, 0, 1, 0, get_sound_pitch());
                prepare_sound_play = 1;
            }
            var _intro_frame = clamp(mg_intro_anim * sprite_get_number(ibtT_spr_mgintro), 0, sprite_get_number(ibtT_spr_mgintro) - 1);
            draw_sprite(ibtT_spr_mgintro, _intro_frame, 240, 135);
            var _sf_x = 240;
            var _sf_y = 135;
            var _sf_s = 1;
            var _sf_a = 0;
            var _mg_transition_sf = surface_create(480, 270);
            var _targ = surface_get_target();
            surface_reset_target();
            surface_set_target(_mg_transition_sf);
            draw_clear_alpha(c_white, 0);
            draw_sprite(ibtT_spr_mgintro_mask, _intro_frame, 240, 135);
            gpu_set_colorwriteenable(true, true, true, false);
            draw_minigame_surface(_sf_x, _sf_y, _sf_s, _sf_s, _sf_a);
            gpu_set_colorwriteenable(true, true, true, true);
            surface_reset_target();
            surface_set_target(_targ);
            draw_surface(_mg_transition_sf, 0, 0);
            surface_free(_mg_transition_sf);
        }
        else if (mg_outro_anim > 0 && mg_outro_anim < 1)
        {
            var _sprite_scale_lerp = clamp(mg_outro_anim / 0.3, 0, 1);
            _sprite_scale_lerp = lerp_easeOut(_sprite_scale_lerp);
            var _sprites_scale = lerp(3, 1, _sprite_scale_lerp);
            _sprites_scale = 1;
            var _outro_sprite = ibtT_spr_mgoutro;
            var _outro_mask_sprite = ibtT_spr_mgoutro_mask;
            if (success_state == -1)
            {
                _outro_sprite = ibtT_spr_mgoutro_lose;
                _outro_mask_sprite = ibtT_spr_mgoutro_lose_mask;
            }
            var _outro_frame = clamp(mg_outro_anim * sprite_get_number(_outro_sprite), 0, sprite_get_number(_outro_sprite) - 1);
            draw_sprite_ext(_outro_sprite, _outro_frame, 240, 135, _sprites_scale, _sprites_scale, 0, c_white, 1);
            var _sf_x = 240;
            var _sf_y = 135;
            var _sf_s = 1;
            var _sf_a = 0;
            var _mg_transition_sf = surface_create(480, 270);
            var _targ = surface_get_target();
            surface_reset_target();
            surface_set_target(_mg_transition_sf);
            draw_clear_alpha(c_white, 0);
            draw_sprite_ext(_outro_mask_sprite, _outro_frame, 240, 135, _sprites_scale, _sprites_scale, 0, c_white, 1);
            gpu_set_colorwriteenable(true, true, true, false);
            draw_minigame_surface(_sf_x, _sf_y, _sf_s, _sf_s, _sf_a);
            gpu_set_colorwriteenable(true, true, true, true);
            surface_reset_target();
            surface_set_target(_targ);
            draw_surface(_mg_transition_sf, 0, 0);
            surface_free(_mg_transition_sf);
        }
        if (obj_minigame_controller.endless_mode)
        {
            var cprompt_time = 3 - inbetween_timer;
            if (cprompt_time > 0 && obj_minigame_controller.inbetween_type != 3)
            {
                _draw_control_prompt(next_control_style, cprompt_time);
            }
        }
        if (scene == 0)
        {
            intro_time = character.intro_time * 5;
            var black_alpha = 1 - ((intro_time - 1) / 2);
            draw_set_alpha(black_alpha);
            draw_rectangle(-1, -1, 481, 271, false);
            draw_set_alpha(1);
        }
        if (overlay_alpha > 0)
        {
            draw_set_alpha(overlay_alpha);
            draw_rectangle(-1, -1, 481, 271, false);
            draw_set_alpha(1);
        }
    };
    
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
                        _spr = ibtT_spr_controlprompt_arrows;
                        break;
                    case "spacebar":
                        _spr = ibtT_spr_controlprompt_space;
                        break;
                    case "cursor":
                        _spr = ibtT_spr_controlprompt_mouse;
                        break;
                    case "keyboard":
                        _spr = ibtT_spr_controlprompt_keyboard;
                        break;
                }
                break;
            case 2:
                if (array_contains(styles, "arrows") && array_contains(styles, "spacebar"))
                {
                    _spr = ibtT_spr_controlprompt_arrows_space;
                }
                if (array_contains(styles, "arrows") && array_contains(styles, "cursor"))
                {
                    _spr = ibtT_spr_controlprompt_arrows_space_mouse;
                }
                if (array_contains(styles, "space") && array_contains(styles, "cursor"))
                {
                    _spr = ibtT_spr_controlprompt_arrows_space_mouse;
                }
                if (array_contains(styles, "keyboard") && array_contains(styles, "cursor"))
                {
                    _spr = ibtT_spr_controlprompt_keyboard_mouse;
                }
                break;
            case 3:
                if (array_contains(styles, "arrows") && array_contains(styles, "cursor") && array_contains(styles, "space"))
                {
                    _spr = ibtT_spr_controlprompt_arrows_space_mouse;
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
        draw_sprite_ext(_spr, 0, dx, dy, _s, _s, _r, c_white, 1);
    };
    
    get_sound_pitch = function()
    {
        var _bpm = obj_minigame_controller.char.bpm / 75;
        return _bpm * get_game_speed();
    };
}

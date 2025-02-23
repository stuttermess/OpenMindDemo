function gimmick_combo() : gimmick_constructor() constructor
{
    rounds = 3;
    speedup_multiplier = 1.25;
    ghosting_frames = 7;
    fully_active = false;
    finish_this = false;
    finishing = false;
    shown_prompt = false;
    shown_controls = 0;
    mg_queued = false;
    started = false;
    speed_diff = 0;
    start_speed = 1;
    last_mg = false;
    rounds_lasted = 0;
    ghosting_good = false;
    speed_ramp_real = 0;
    speed_ramp_prog = -1;
    speed_ramp_spd = 1/30;
    speed_ramp_start = 1;
    speed_ramp_end = 1;
    overlay_blend = 0;
    arrow_frame = 0;
    arrow_nudge_x = 0;
    start_beat = 0;
    visuals_in_dest = 0;
    visuals_in = 0;
    prev_frames = array_create(ghosting_frames, -1);
    main_frame = -1;
    prev_mg_sf = -1;
    
    _init = function()
    {
        old_mg_sf = surface_create(480, 270);
        prev_frame_sf = surface_create(480, 270);
        fully_active = false;
    };
    
    _tick_before = function()
    {
        var _cnt = obj_minigame_controller.char;
        var _mg = obj_minigame_controller.current_process_mg;
        if (_cnt._lives == 1 && is_struct(_mg) && _mg.success_state == -1)
        {
            rounds = 0;
            last_mg = true;
        }
        if (finish_this)
        {
            if (abs(visuals_in - visuals_in_dest) <= 0.1 && visuals_in_dest == 0)
            {
                _finish();
            }
        }
        else if (!surface_exists(old_mg_sf))
        {
            old_mg_sf = surface_create(480, 270);
        }
        if (prev_frame_sf != -1)
        {
            if (surface_exists(obj_minigame_controller.mg_container_surface))
            {
                prev_frame_sf = surface_create(480, 270);
                surface_set_target(prev_frame_sf);
                draw_clear_alpha(c_white, 1);
                gpu_set_colorwriteenable(1, 1, 1, 0);
                gpu_set_blendenable(false);
                draw_surface(obj_minigame_controller.mg_container_surface, 0, 0);
                gpu_set_colorwriteenable(1, 1, 1, 1);
                gpu_set_blendenable(true);
                surface_reset_target();
                array_push(prev_frames, prev_frame_sf);
                if (array_length(prev_frames) >= ghosting_frames)
                {
                    if (surface_exists(prev_frames[0]))
                    {
                        surface_free(prev_frames[0]);
                    }
                    array_delete(prev_frames, 0, 1);
                }
                ghosting_good = true;
            }
            else
            {
                ghosting_good = false;
            }
        }
    };
    
    _on_minigame_init = function()
    {
        if (finishing)
        {
            exit;
        }
        mg_queued = false;
        if (rounds == 1)
        {
            last_mg = true;
        }
        if (shown_controls == 1)
        {
            shown_controls = 2;
        }
    };
    
    _on_minigame_start = function()
    {
        visuals_in_dest = 0;
    };
    
    _on_minigame_over = function()
    {
        strip_xoff = 0;
        start_beat = round(obj_minigame_controller.current_beat);
        if (finishing)
        {
            exit;
        }
        if (started)
        {
            rounds--;
            rounds_lasted++;
            var _cnt = obj_minigame_controller.char;
            var _mg = obj_minigame_controller.current_process_mg;
            var _DIED = _cnt._lives <= 1 && is_struct(_mg) && _mg.success_state == -1;
            obj_minigame_controller.char._round--;
            if (_DIED)
            {
                rounds = 0;
                last_mg = true;
            }
            if (rounds <= 0 && speed_ramp_prog == -1)
            {
                obj_minigame_controller.char._round += rounds_lasted;
                finishing = true;
                if (_DIED)
                {
                    visuals_in_dest = 1;
                }
                else
                {
                    visuals_in_dest = 1;
                }
                obj_minigame_controller.combo_mode = false;
                obj_minigame_controller.combo_display_inbetween = true;
                speed_ramp_start = start_speed * speedup_multiplier;
                speed_ramp_end = start_speed;
                speed_ramp_prog = 0;
                var _sspd = start_speed;
                with (obj_minigame_controller)
                {
                    combo_mode = false;
                    queue_next_mg();
                }
            }
            else
            {
                surface_set_target(old_mg_sf);
                draw_clear_alpha(c_white, 1);
                gpu_set_colorwriteenable(1, 1, 1, 0);
                gpu_set_blendenable(false);
                draw_surface(obj_minigame_controller.mg_container_surface, 0, 0);
                gpu_set_colorwriteenable(1, 1, 1, 1);
                gpu_set_blendenable(true);
                surface_reset_target();
                if (!finishing)
                {
                    obj_minigame_controller.skipib = true;
                }
            }
        }
    };
    
    start = function()
    {
        start_beat = round(obj_minigame_controller.current_beat);
        set_base_speed();
        speed_ramp_prog = 0;
        speed_ramp_real = 0;
        started = true;
        shown_prompt = false;
        shown_controls = 0;
        mg_queued = false;
        strip_xoff = 0;
    };
    
    set_base_speed = function(arg0 = -1)
    {
        if (arg0 == -1)
        {
            arg0 = obj_minigame_controller.music_pitch_base;
        }
        start_speed = arg0;
        if (finishing)
        {
            speed_ramp_start = start_speed * speedup_multiplier;
            speed_ramp_end = start_speed;
        }
        else
        {
            speed_ramp_start = start_speed;
            speed_ramp_end = start_speed * speedup_multiplier;
        }
    };
    
    _tick_after = function()
    {
        if (visuals_in > 0)
        {
            strip_xoff += get_game_speed();
        }
        var _beat = obj_minigame_controller.current_beat - start_beat;
        if (speed_ramp_prog >= 0 && speed_ramp_prog < 1)
        {
            set_base_speed();
            speed_ramp_prog += speed_ramp_spd;
            speed_ramp_real = speed_ramp_prog;
            if (speed_ramp_start < speed_ramp_end)
            {
                overlay_blend = speed_ramp_prog;
            }
            else
            {
                overlay_blend = 1 - speed_ramp_prog;
            }
            var _spd = lerp(speed_ramp_start, speed_ramp_end, speed_ramp_prog);
            obj_minigame_controller.set_game_speed(_spd, false, true);
            if (!fully_active)
            {
                set_base_speed();
            }
            if (speed_ramp_prog >= 1)
            {
                speed_ramp_prog = -1;
                if (speed_ramp_end == start_speed || (finishing && visuals_in == 0))
                {
                    finish_this = true;
                }
            }
        }
        else
        {
        }
        arrow_nudge_x = lerp(arrow_nudge_x, 0, 0.3);
        if (!fully_active)
        {
            if (floor(_beat) == 3 && arrow_frame == 0)
            {
                arrow_frame = 1;
                arrow_nudge_x = 5;
            }
        }
        else if (finishing)
        {
            if (floor(_beat) == 2 && arrow_frame == 1)
            {
                arrow_frame = 0;
                arrow_nudge_x = -5;
            }
        }
        if (finishing)
        {
            if (_beat > 4)
            {
                visuals_in_dest = 0;
            }
        }
        else if (_beat < 1)
        {
            if (speed_ramp_prog >= 0)
            {
                visuals_in_dest = 1;
            }
        }
        if (abs(visuals_in - visuals_in_dest) <= 0.01)
        {
            visuals_in = visuals_in_dest;
        }
        visuals_in = lerp(visuals_in, visuals_in_dest, 0.3);
        visuals_in = round_to_multiple(visuals_in, 0.01 * get_game_speed());
        if (finishing)
        {
            exit;
        }
        var active_mgs = obj_minigame_controller.active_mgs;
        var inbetween_timer = obj_minigame_controller.inbetween_timer;
        var inbetween_length = obj_minigame_controller.inbetween_length;
        var _speedup_start_beat = floor(inbetween_length / 2) + 2;
        if (!started)
        {
            if (inbetween_timer > 0)
            {
                if (ceil(inbetween_timer) == _speedup_start_beat)
                {
                    start();
                }
            }
            exit;
        }
        var _me = self;
        if (last_mg)
        {
            if (array_length(active_mgs) > 0)
            {
                if (active_mgs[0].time < 1)
                {
                    obj_minigame_controller.combo_display_inbetween = true;
                }
            }
            else
            {
                obj_minigame_controller.combo_display_inbetween = true;
            }
        }
        else if (fully_active)
        {
            with (obj_minigame_controller)
            {
                if (array_length(active_mgs) > 0)
                {
                    switch (ceil(active_mgs[0].time))
                    {
                        case 3:
                            combo_display_inbetween = false;
                            combo_mode = true;
                            if (!_me.mg_queued)
                            {
                                queue_next_mg();
                                _me.mg_queued = true;
                            }
                            _me.shown_prompt = false;
                            break;
                        case 2:
                            _me.shown_controls = 1;
                            break;
                        case 1:
                            if (!_me.shown_prompt)
                            {
                                display_prompt();
                            }
                            _me.shown_prompt = true;
                            break;
                    }
                }
            }
        }
        else if (obj_minigame_controller.inbetween_timer <= 0)
        {
            fully_active = true;
            obj_minigame_controller.combo_mode = true;
        }
    };
    
    _draw_before = function()
    {
    };
    
    _draw_before_prompt = function()
    {
        if (finish_this && visuals_in <= 0)
        {
            exit;
        }
        var _sf_scale = 1;
        if (obj_minigame_controller.inbetween_timer > 0 || !fully_active)
        {
            _sf_scale = 0;
        }
        var _sf_x = 240;
        var _sf_y = 135;
        _sf_x -= (_sf_scale * 240);
        _sf_y -= (_sf_scale * 135);
        for (var i = 0; i < array_length(prev_frames); i++)
        {
            var _prev_frame_sf = prev_frames[i];
            var _ghosting_good = ghosting_good;
            var _gframes = ghosting_frames;
            if (ghosting_good && surface_exists(_prev_frame_sf) && _prev_frame_sf != -1)
            {
                with (obj_minigame_controller)
                {
                    draw_surface_ext(_prev_frame_sf, _sf_x, _sf_y, _sf_scale, _sf_scale, 0, c_white, 1 / _gframes);
                }
            }
        }
        if (shown_controls == 1 && visuals_in == 0)
        {
            var ibt = obj_minigame_controller.char.inbetween;
            var controlstyle = obj_minigame_controller.next_mg.control_style;
            var cprompt_time = 0;
            if (array_length(obj_minigame_controller.active_mgs) > 0)
            {
                cprompt_time = 2 - obj_minigame_controller.active_mgs[0].time;
            }
            show_debug_message("cprompt time " + string(cprompt_time));
            draw_generic_control_prompt(controlstyle, cprompt_time, 240, 135);
        }
        if (visuals_in > 0)
        {
            var _arrow_y = lerp(-60, 30, visuals_in);
            var _arrow_frame = arrow_frame;
            draw_sprite_ext(spr_gimmick_combo_ffwd, _arrow_frame, 8 + arrow_nudge_x, _arrow_y, 1, 1, 0, c_white, 1);
            var _top_strip_y = lerp(-25, 0, visuals_in);
            var _xscale = 6.341463414634147;
            draw_sprite_ext(spr_gimmick_combo_strip, finishing, strip_xoff - 205, _top_strip_y, _xscale, 1, 0, c_white, 1);
            draw_sprite_ext(spr_gimmick_combo_strip, finishing, -strip_xoff - 205, 248 - _top_strip_y, _xscale, 1, 0, c_white, 1);
        }
    };
    
    _draw_after = function()
    {
    };
    
    _draw_combo_prevmg = function()
    {
        if (surface_exists(old_mg_sf))
        {
            draw_surface(old_mg_sf, 0, 0);
        }
        if (shown_controls == 2)
        {
            var ibt = obj_minigame_controller.char.inbetween;
            var controlstyle = obj_minigame_controller.next_mg.control_style;
            ibt._draw_control_prompt(controlstyle);
        }
    };
    
    _finish = function()
    {
        obj_minigame_controller.combo_mode = false;
        obj_minigame_controller.combo_display_inbetween = true;
        __deleted = true;
        if (surface_exists(old_mg_sf))
        {
            surface_free(old_mg_sf);
        }
        if (surface_exists(prev_frame_sf))
        {
            surface_free(prev_frame_sf);
        }
        if (surface_exists(prev_mg_sf))
        {
            surface_free(prev_mg_sf);
        }
        if (surface_exists(main_frame))
        {
            surface_free(main_frame);
        }
        old_mg_sf = -1;
        prev_frame_sf = -1;
        prev_mg_sf = -1;
        main_frame = -1;
        for (var i = 0; i < array_length(prev_frames); i++)
        {
            if (surface_exists(prev_frames[i]))
            {
                surface_free(prev_frames[i]);
            }
        }
    };
}

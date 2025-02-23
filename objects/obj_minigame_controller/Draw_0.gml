var _frame_start_font = draw_get_font();
if (!surface_exists(ibt_surface))
{
    ibt_surface = surface_create(char.inbetween.screen_w, char.inbetween.screen_h);
}
surface_set_target(ibt_surface);
draw_clear(c_black);
if (combo_mode && !combo_display_inbetween)
{
    gimmick_event("_draw_combo_prevmg");
}
else
{
    with (char)
    {
        _draw();
    }
}
surface_reset_target();
var timerfill = 0;
if (!surface_exists(mg_container_surface))
{
    mg_container_surface = surface_create(480, 270);
}
var this_mg = -1;
if (array_length(active_mgs) > 0 && active_mgs[0].time > -1)
{
    if (!surface_exists(mg_surface))
    {
        mg_surface = surface_create(active_mgs[0].screen_w, active_mgs[0].screen_h);
    }
    surface_set_target(mg_surface);
    draw_clear(c_black);
    for (var i = 0; i < array_length(active_mgs); i++)
    {
        this_mg = active_mgs[i];
        current_process_mg = active_mgs[i];
        draw_clear(c_black);
        with (this_mg)
        {
            _draw();
        }
        current_process_mg = -1;
    }
    surface_reset_target();
    surface_set_target(mg_container_surface);
    draw_clear(c_white);
    var sfscale = 270 / surface_get_height(mg_surface);
    gpu_set_blendenable(false);
    draw_surface_ext(mg_surface, 0, 0, sfscale, sfscale, 0, c_white, 1);
    gpu_set_blendenable(true);
    if (this_mg.time <= this_mg.show_timer_at && this_mg.use_timer && show_timer)
    {
        timerfill = (this_mg.time - 1) / min(this_mg.time_limit, this_mg.show_timer_at);
        var _tscript = this_mg.timer_script;
        if (!script_exists(_tscript))
        {
            _tscript = char.timer_script;
        }
        if (script_exists(_tscript))
        {
            _tscript(0, 0, 480, 270, timerfill);
        }
    }
    surface_reset_target();
}
else if (!surface_exists(mg_surface))
{
    mg_surface = surface_create(480, 270);
}
gimmick_event("_draw_before");
if (game_active)
{
    if (view_current != 0)
    {
        view_visible[view] = false;
    }
    var ibt_upscale = 270 / surface_get_height(ibt_surface);
    draw_clear_alpha(c_white, 1);
    gpu_set_blendenable(false);
    draw_surface_ext(ibt_surface, 0, 0, 1 * ibt_upscale, 1 * ibt_upscale, 0, c_white, 1);
    gpu_set_blendenable(true);
    var _drawit = false;
    if (inbetween_timer <= minigame_intro_length && inbetween_timer >= 0)
    {
        _drawit = !char.inbetween.draws_minigame_surface;
    }
    else if (array_length(active_mgs) > 0)
    {
        if (active_mgs[0].time >= 0)
        {
            _drawit = true;
        }
        else if (minigame_initialized)
        {
            _drawit = true;
        }
        else
        {
            _drawit = !char.inbetween.draws_minigame_surface;
        }
    }
    else
    {
        _drawit = !char.inbetween.draws_minigame_surface;
    }
    if (show_results_screen && inbetween_timer <= 0)
    {
        _drawit = false;
    }
    if (_drawit)
    {
        draw_minigame_surface();
    }
}
draw_set_font(_frame_start_font);
gimmick_event("_draw_before_prompt");
if (prompt_time <= room_speed && prompt_time > -1)
{
    this_mg = prompt_mg;
    var prompt_scale = set_prompt_scale(prompt_time) * 3;
    var fnt = draw_get_font();
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(fnt_prompt);
    var _lerp = 0;
    if (inbetween_timer < 0.5)
    {
        _lerp = lerp_easeInOut(clamp(1 - (inbetween_timer / 0.5), 0, 1));
    }
    var _yoff = lerp(0, this_mg.prompt_y_offset, _lerp);
    draw_text_outline(240, 135 + _yoff, this_mg.prompt, 0, false, prompt_scale, prompt_scale, prompt_scale, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(fnt);
}
gimmick_event("_draw_after", true);
if (paused && game_active && !game_end_freeze)
{
    var _pause_overlay_alpha = 1;
    if (pause_countdown > 0)
    {
    }
    draw_set_alpha(_pause_overlay_alpha);
    draw_set_color(c_black);
    draw_rectangle(-1, -1, 900, 900, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    if (pause_countdown > 0)
    {
        draw_text_outline(240, 135, ceil(pause_countdown));
    }
    else
    {
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    var hover = false;
    pause_menu.draw();
    hover = pause_menu.cursor_hover > -1;
    if (!pause_menu.options_open)
    {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        if (char.use_skip_button)
        {
            var _str = pause_skip_str;
            var _wid = string_width(_str) + 6;
            var _hei = (string_height(_str) + 6) - 2;
            var _sc = [5, 5, 5 + _wid, 5 + _hei];
            draw_rectangle(_sc[0], _sc[1], _sc[2], _sc[3], true);
            draw_text(mean(_sc[0], _sc[2]), mean(_sc[1], _sc[3]) + 1, _str);
            if (point_in_rectangle(mouse_x, mouse_y, _sc[0], _sc[1], _sc[2], _sc[3]))
            {
                hover = true;
                if (get_input_click())
                {
                    char.on_skip();
                }
            }
        }
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
    draw_set_font(fnt_pixel);
    draw_sprite(spr_cursor, hover + (hover && mouse_check_button(mb_left)), mouse_x, mouse_y);
}
if (show_results_screen && inbetween_timer <= 0)
{
    if (next_cutscene != -1)
    {
        if (is_struct(next_cutscene))
        {
            instance_destroy();
            play_cutscene_struct(next_cutscene);
        }
        else if (script_exists(next_cutscene))
        {
            instance_destroy();
            play_cutscene(next_cutscene);
        }
    }
    else
    {
        var framemod = 36.734693877551024;
        var beat1 = 0 * framemod;
        var beat2a = floor(1 * framemod);
        var beat2 = floor(1.5 * framemod);
        var beat3a = floor(2.5 * framemod);
        var beat3 = floor(3 * framemod);
        beat1 = 0 * framemod;
        beat2 = 1 * framemod;
        beat2a = 1 * framemod;
        beat3 = 2 * framemod;
        beat3a = 2 * framemod;
        var playsnd = false;
        var sndvol = 1;
        if (!instance_exists(transition_controller))
        {
            audio_sound_gain(mus_endlessresults, 1, 0);
        }
        switch (results_screen_phase)
        {
            case -1:
                results_screen_phase = 0;
                playsnd = true;
                break;
            case 0:
                if (endless_mode)
                {
                    if (!audio_is_playing(mus_endlessresults))
                    {
                        set_game_speed(98 / base_bpm);
                        audio_sound_loop_start(mus_endlessresults, 14.723);
                        audio_sound_loop_end(mus_endlessresults, 34.314);
                        var _mus = audio_play_sound_on(master.emit_mus, mus_endlessresults, true, 100, 1);
                        audio_sound_gain(_mus, 1, 0);
                    }
                }
                if (results_screen_time >= beat2a)
                {
                    results_screen_phase = 0.5;
                    sndvol = 0.5;
                }
                break;
            case 0.5:
                if (results_screen_time >= beat2)
                {
                    results_screen_phase = 1;
                    playsnd = true;
                }
                break;
            case 1:
                if (results_screen_time >= beat3a)
                {
                    results_screen_phase = 1.5;
                    sndvol = 0.5;
                }
                break;
            case 1.5:
                if (results_screen_time >= beat3)
                {
                    results_screen_phase = 2;
                    playsnd = true;
                }
                break;
        }
        blendmode_set_multiply();
        draw_sprite(spr_endlessresults_overlay, 0, 0, 0);
        blendmode_reset();
        char.results_screen_draw();
        var hover = false;
        hover = char.results_screen_menu.cursor_hover != -1;
        if (showing_steam_leaderboard)
        {
            steam_leaderboard._draw();
            hover = steam_leaderboard.hover;
        }
        hover = bool(hover);
        if (hover && mouse_check_button(mb_left))
        {
            hover = 2;
        }
        draw_sprite(spr_cursor, hover, mouse_x, mouse_y);
        results_screen_time++;
    }
}
if (dev_mode)
{
}
if (show_speed_message > 0)
{
    draw_text_outline(5, 5, "Speed: " + string(music_pitch));
    show_speed_message--;
}

if (!game_active)
{
    exit;
}
var _sound_arrs = [game_music, sfx_pause_array];
for (var i = 0; i < array_length(_sound_arrs); i++)
{
    var _arr = _sound_arrs[i];
    for (var j = 0; j < array_length(_arr); j++)
    {
        if (!audio_is_playing(_arr[j]))
        {
            audio_stop_sound(_arr[j]);
            array_delete(_arr, j, 1);
            j--;
        }
    }
}
if (keyboard_check_pressed(vk_backspace))
{
}
if (pause_delay > 0)
{
    pause_delay--;
    if (pause_delay == 0)
    {
        game_set_pause(!paused);
    }
}
if ((keyboard_check_pressed(vk_escape) || (master.settings.pause_on_lose_focus && !master.game_focused)) && !game_ended && allow_pause)
{
    if (game_get_pause())
    {
    }
    else if (pause_delay == 0)
    {
        pause_delay = pause_delay_max;
    }
}
if (paused)
{
    pause_menu.tick();
}
if (pause_countdown > 0)
{
    var prev_pc = pause_countdown + 0.001;
    pause_countdown -= (1/30);
    if (ceil(prev_pc) != ceil(pause_countdown))
    {
        sfx_play(sfx_tick1);
    }
    if (pause_countdown <= 0)
    {
        game_set_pause(false);
    }
}
master.mouselock = false;
if (game_active && !game_ended)
{
    master.mouselock = true;
}
if (paused)
{
    play_stats.pauses[array_length(play_stats.pauses) - 1].length += delta_time / 1000000;
    master.mouselock = false;
    exit;
}
play_stats.playtime_seconds += delta_time / 1000000;
if (char != -1)
{
    play_stats._lives = char._lives;
    play_stats._score = char._round;
    play_stats.max_speed = max(play_stats.max_speed, get_game_speed());
}
if (inbetween_timer > 0 && dev_mode)
{
    var pitch_change = (keyboard_check_pressed(187) - keyboard_check_pressed(189)) * 0.1;
    if (pitch_change != 0)
    {
        var startpitch = audio_sound_get_pitch(tempo_track);
        music_pitch = startpitch + pitch_change;
        prev_speed = music_pitch;
        goal_speed = music_pitch;
        audio_sound_pitch(tempo_track, music_pitch);
        show_speed_message = 60;
    }
}
if (tempo_track != -1)
{
    var prev_tempo_pos = tempo_pos;
    tempo_pos = audio_sound_get_track_position(tempo_track);
    if (tempo_pos < prev_tempo_pos)
    {
        tempo_loops++;
    }
    tempo_time = tempo_pos + (audio_sound_length(tempo_sound) * tempo_loops);
    var pcbm = current_beat_mod;
    set_current_beat();
    if (floor(pcbm) != floor(current_beat_mod) && play_tick_sounds)
    {
        switch (floor(current_beat_mod))
        {
            case 0:
                sfx_play(sfx_tick1);
                break;
            default:
                sfx_play(sfx_tick2);
                break;
        }
    }
}
if ((inbetween_timer > 0 || game_ended) && char.intro_time >= 1)
{
    var _skipped = false;
    if ((skipib && current_beat >= 0.5) || (keyboard_check_pressed(vk_shift) && dev_mode))
    {
        skip_inbetween();
        _skipped = true;
    }
    var prevtimer = inbetween_timer;
    update_inbetween_timer();
    if (floor(prevtimer) > floor(inbetween_timer))
    {
        var ibt_jingle = -1;
        var _ibtt = inbetween_type;
        var _ibt_timer = inbetween_timer;
        var _ibt_len = inbetween_length;
        with (char.inbetween)
        {
            switch (_ibtt)
            {
                case 4:
                    break;
                case 0:
                    if (floor(_ibt_timer) == (_ibt_len - 4 - 1))
                    {
                        ibt_jingle = get_prep_jingle();
                    }
                    break;
                case 1:
                case 5:
                    if (floor(_ibt_timer) == (_ibt_len - 4 - 1))
                    {
                        ibt_jingle = get_speedup_jingle();
                    }
                    if (floor(_ibt_timer) == (_ibt_len - 8 - 1))
                    {
                        ibt_jingle = get_prep_jingle();
                    }
                    break;
                case 2:
                    if (floor(_ibt_timer) == (_ibt_len - 4 - 1))
                    {
                        ibt_jingle = get_boss_jingle();
                    }
                    if (floor(_ibt_timer) == (_ibt_len - 12 - 1))
                    {
                    }
                    break;
            }
        }
        if (ibt_jingle != -1)
        {
            play_inbetween_jingle(ibt_jingle);
        }
    }
    var dospeedup = false;
    var speedupprog = 0;
    if (inbetween_type == 2)
    {
        if ((inbetween_timer - 2) < (measure_length * 2.5))
        {
            dospeedup = true;
            speedupprog = 1;
        }
    }
    if (inbetween_type == 1 || inbetween_type == 5)
    {
        if (inbetween_timer < (measure_length * 2) && inbetween_timer > measure_length)
        {
            dospeedup = true;
            speedupprog = 1;
        }
    }
    if (dospeedup)
    {
        if (!spedup_this_round)
        {
            prev_speed = music_pitch;
        }
        spedup_this_round = true;
        var startpitch = prev_speed;
        var endpitch = goal_speed;
        var pitchchange = endpitch - startpitch;
        set_game_speed(endpitch);
        audio_sound_pitch(tempo_track, music_pitch);
        for (var i = 0; i < array_length(jingles); i++)
        {
            audio_sound_pitch(jingles[i].sound_inst, music_pitch);
            var _curbeat = get_current_beat();
            var _beat_diff = _curbeat - jingles[i].start_beat;
            var _jing_pos = _beat_diff / (base_bpm / room_speed);
            if (abs(audio_sound_get_track_position(jingles[i].sound_inst) - _jing_pos) > 0.01)
            {
                audio_sound_set_track_position(jingles[i].sound_inst, _jing_pos);
            }
        }
    }
    else if (spedup_this_round)
    {
        spedup_this_round = false;
    }
    if ((!combo_mode || (combo_mode && combo_display_inbetween)) && inbetween_timer <= 1 && inbetween_timer > -1 && next_mg.use_timer && prompt_time == -1 && char._lives > 0 && (char._round != char.game_end_round || endless_mode))
    {
        display_prompt();
    }
    if (game_ended && inbetween_timer <= 0)
    {
        play_stats.finished = true;
        if (!game_end_freeze)
        {
            if (freeze_on_game_end)
            {
                audio_pause_sound(tempo_track);
            }
            if (is_array(game_music))
            {
                for (var i = 0; i < array_length(game_music); i++)
                {
                    audio_sound_loop(game_music[i], false);
                    audio_sound_gain(game_music[i], 0, 5000);
                    audio_sound_end_on_fade(game_music[i]);
                }
            }
            else
            {
                audio_sound_loop(game_music, false);
                audio_sound_gain(game_music, 0, 5000);
            }
            char._end_game();
            game_end_freeze = true;
        }
    }
    minigame_intro_length = char.inbetween.minigame_intro_length;
    minigame_outro_length = char.inbetween.minigame_outro_length;
    if (combo_mode || _skipped)
    {
        minigame_intro_length = 0;
    }
    if (inbetween_timer <= minigame_intro_length)
    {
        init_mg();
    }
    var _mg_time_threshold = -minigame_outro_length;
    if (combo_mode)
    {
        _mg_time_threshold = 0;
    }
    if (inbetween_timer > 0 || game_ended)
    {
        if (array_length(active_mgs) > 0 && active_mgs[0].time < _mg_time_threshold)
        {
            with (active_mgs[0])
            {
                _cleanup();
            }
            gimmick_event("_on_minigame_end");
            active_mgs = [];
        }
    }
    else if (!game_ended)
    {
        if (music_pitch != goal_speed)
        {
            music_pitch = goal_speed;
            audio_sound_pitch(tempo_track, music_pitch);
        }
        audio_sound_gain(tempo_track, 0, 0);
        if (next_mg == -1)
        {
            queue_mg(char.pick_next_minigame());
        }
        prompt_scale = 0;
        view = 0;
        start_mg();
        active_mgs[0].beat_start += inbetween_timer;
    }
}
gimmick_event("_tick_before");
if (showing_steam_leaderboard)
{
    steam_leaderboard._tick();
}
else if (show_results_screen && !instance_exists(transition_controller))
{
    char.results_screen_menu._tick();
}
if (!is_struct(char) || !instance_exists(self))
{
    exit;
}
var ibt = char.inbetween;
if (ibt != -1)
{
    ibt.inbetween_timer = inbetween_timer;
    ibt.current_beat = current_beat;
    char._tick();
    ibt.next_control_style = next_mg.control_style;
}
if (game_end_freeze)
{
    exit;
}
var cb = current_beat;
var sp = base_bpm * music_pitch;
for (var i = 0; i < array_length(active_mgs); i++)
{
    var ibtt = inbetween_timer;
    current_process_mg = active_mgs[i];
    with (active_mgs[i])
    {
        _tick();
        beat_current = cb;
    }
    current_process_mg = -1;
}
if (prompt_time >= 0)
{
    prompt_time += (music_pitch * clamp(base_bpm / 128, 0.75, 1));
}
gimmick_event("_tick_after", true);
for (var i = 0; i < array_length(jingles); i++)
{
    if (!audio_is_playing(jingles[i].sound_inst))
    {
        array_delete(jingles, i, 1);
        i--;
    }
}

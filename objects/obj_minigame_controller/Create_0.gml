active_mgs = [];
current_process_mg = -1;
settings_preset = "default";
settings = 
{
    gimmicks_enabled: true,
    levelup_enabled: true,
    max_speed: -1
};
gimmicks = [];
gimmicks_last_appeared = {};

get_gimmick_last_appeared = function(arg0)
{
    arg0 = script_get_name(arg0);
    if (struct_exists(gimmicks_last_appeared, arg0))
    {
        return struct_get(gimmicks_last_appeared, arg0);
    }
    else
    {
        return -1;
    }
};

gimmick_event = function(arg0, arg1 = false)
{
    if (arg1)
    {
        array_reverse(gimmicks, 0, array_length(gimmicks));
    }
    for (var i = 0; i < array_length(gimmicks); i++)
    {
        var _gimmick = gimmicks[i];
        if (struct_exists(_gimmick, arg0))
        {
            var _ev = struct_get(_gimmick, arg0);
            if (is_method(_ev))
            {
                _ev();
            }
            if (_gimmick.__deleted)
            {
                show_debug_message("gimmick " + instanceof(_gimmick) + " deleted");
                array_delete(gimmicks, i, 1);
                i--;
            }
        }
    }
    if (arg1)
    {
        array_reverse(gimmicks, 0, array_length(gimmicks));
    }
};

start_gimmick = function(arg0, arg1 = {})
{
    if (!settings.gimmicks_enabled)
    {
        return false;
    }
    var on_blacklist = false;
    if (is_struct(next_mg))
    {
        on_blacklist = array_contains(next_mg.gimmick_blacklist, arg0);
    }
    if (on_blacklist)
    {
        show_debug_message("Gimmick (" + script_get_name(arg0) + ") not started. Blacklisted by queued minigame: " + instanceof(next_mg));
        return false;
    }
    var _gim = new arg0();
    var _args = struct_get_names(arg1);
    for (var i = 0; i < array_length(_args); i++)
    {
        struct_set(_gim, _args[i], struct_get(arg1, _args[i]));
    }
    _gim._init();
    array_push(gimmicks, _gim);
    struct_set(gimmicks_last_appeared, script_get_name(arg0), char._round);
    return true;
};

clear_gimmicks = function()
{
    gimmick_event("_finish");
};

gimmick_find = function(arg0, arg1 = 0)
{
    if (script_exists(arg0))
    {
        arg0 = script_get_name(arg0);
    }
    else
    {
        return false;
    }
    var _matches = 0;
    for (var i = 0; i < array_length(gimmicks); i++)
    {
        if (instanceof(gimmicks[i]) == arg0)
        {
            _matches++;
            if (_matches > arg1)
            {
                return gimmicks[i];
            }
        }
    }
    return false;
};

gimmick_apply_arguments = function(arg0, arg1)
{
    var _gimmick_inst = arg0;
    if (!is_struct(_gimmick_inst))
    {
        _gimmick_inst = gimmick_find(_gimmick_inst);
    }
    var _args = struct_get_names(arg1);
    for (var i = 0; i < array_length(_args); i++)
    {
        struct_set(_gimmick_inst, _args[i], struct_get(arg1, _args[i]));
    }
};

combo_mode = false;
combo_display_inbetween = true;
dev_mode = false;
next_cutscene = -1;
next_mg = -1;
next_mg_script = -1;
prompt_mg = -1;
mg_amount = 10;
show_results_screen = false;
endless_mode = false;
story_mode = false;
tries = 0;
game_ended = false;
game_end_freeze = false;
freeze_on_game_end = false;
results_screen_time = 0;
results_screen_phase = 0;
allow_pause = true;
char_script = gamechar_constructor;
char = new char_script();
preloading = false;
preloads_default = 
{
    smf_obj: {}
};
preloads = struct_copy(preloads_default);

start_exit = function()
{
    allow_pause = false;
    exiting = true;
    audio_sound_gain(mus_endlessresults, 0, 1000);
    audio_sound_end_on_fade(mus_endlessresults);
    var _transition = start_transition_perlin(on_exit);
};

exiting = false;

on_exit = function()
{
    stop_sounds();
    audio_stop_sound(mus_endlessresults);
    instance_destroy();
    instance_create_depth(0, 0, 0, obj_mainmenu_controller);
    with (obj_mainmenu_controller)
    {
        audio_sound_gain(music, 0, 0);
        audio_sound_gain(music, 1, 1000);
        if (variable_global_exists("mainmenu_muspos_save"))
        {
            audio_sound_set_track_position(music, global.mainmenu_muspos_save);
        }
    }
};

before_start = function()
{
};

after_start = function()
{
};

play_stats_folder = "play_stats";
save_play_stats = false;
start_playing_timestamp = 0;
default_play_stats = 
{
    start_time: 0,
    playtime_seconds: 0,
    _score: 0,
    endless: false,
    max_speed: 1,
    _lives: 4,
    pauses: [],
    finished: false,
    lost_minigames: [],
    played_minigames: {}
};
play_stats = struct_copy(default_play_stats);
minigame_interoperate_structs = {};
steam_leaderboard_id = -1;
showing_steam_leaderboard = false;
steam_leaderboard = -1;

open_steam_leaderboard = function()
{
    showing_steam_leaderboard = true;
    steam_leaderboard = new leaderboard_menu_constructor(steam_leaderboard_id, char.endless_score_id, settings_preset);
    steam_leaderboard.request_list();
    steam_leaderboard.close_func = close_steam_leaderboard;
    steam_leaderboard.leaderboard_display_name = leaderboard_display_name;
};

close_steam_leaderboard = function()
{
    showing_steam_leaderboard = false;
    steam_leaderboard.free();
};

leaderboard_display_name = "";
sfx_array = [];
sfx_pause_array = [];
sfx_add_to_mg_end = true;
ibt_surface = surface_create(480, 270);
skipib = false;

skip_inbetween = function()
{
    skipib = false;
    if (inbetween_timer > 0)
    {
        var increment = inbetween_timer / (base_bpm / room_speed);
        var newpos;
        if ((tempo_pos + increment) >= audio_sound_length(tempo_sound))
        {
            newpos = (tempo_pos + increment) % audio_sound_length(tempo_sound);
            tempo_loops++;
        }
        else
        {
            newpos = tempo_pos + increment;
        }
        audio_sound_set_track_position(tempo_track, newpos);
        tempo_pos = audio_sound_get_track_position(tempo_track);
        tempo_time = tempo_pos + (audio_sound_length(tempo_sound) * tempo_loops);
        set_current_beat();
        for (var i = 0; i < array_length(jingles); i++)
        {
            audio_stop_sound(jingles[i].sound_inst);
        }
    }
};

update_inbetween_timer = function()
{
    inbetween_timer = inbetween_length - (current_beat - inbetween_start_beat);
};

start_game = function(arg0 = true)
{
    steam_create_leaderboard(steam_leaderboard_id, lb_sort_descending, lb_disp_numeric);
    audio_stop_sound(mus_endlessresults);
    instance_destroy(obj_collider);
    clear_gimmicks();
    stop_sounds();
    before_start();
    play_stats = struct_copy(default_play_stats);
    start_playing_timestamp = date_current_datetime();
    play_stats.start_time = date_datetime_string(start_playing_timestamp);
    minigame_interoperate_structs = {};
    minigame_initialized = false;
    minigame_started = false;
    game_active = true;
    game_ended = false;
    show_results_screen = false;
    game_end_freeze = false;
    results_screen_time = 0;
    minigame_highest_difficulties = {};
    minigame_difficulties_times_seen = {};
    gimmicks = [];
    combo_mode = false;
    combo_display_inbetween = true;
    tries++;
    inbetween_timer = inbetween_timer_max;
    inbetween_start_beat = 0;
    inbetween_length = 8;
    if (endless_mode)
    {
        inbetween_type = 0;
    }
    else
    {
        inbetween_type = 4;
    }
    inbetween_type = 4;
    play_stats.endless = endless_mode;
    start_speed = 1;
    goal_speed = start_speed;
    prev_speed = start_speed;
    spedup_this_round = false;
    preboss_speed = start_speed;
    jingles = [];
    jingle_prog = 0;
    set_current_beat();
    current_beat = 0;
    active_mgs = [];
    results_screen_phase = -1;
    if (surface_exists(mg_surface))
    {
        surface_set_target(mg_surface);
        draw_clear(c_black);
        surface_reset_target();
    }
    if (surface_exists(mg_container_surface))
    {
        surface_set_target(mg_container_surface);
        draw_clear(c_black);
        surface_reset_target();
    }
    sfx_array = [];
    start_timestamp = date_current_datetime();
    if (arg0)
    {
        char = new char_script();
    }
    base_bpm = char.bpm;
    inbetween_timer_max = (base_bpm / 60) * room_speed;
    preloads = struct_copy(preloads_default);
    preloading = true;
    var _preload_mgs = [];
    array_copy(_preload_mgs, 0, char.available_minigames, 0, array_length(char.available_minigames));
    array_push(_preload_mgs, char.boss_minigame);
    for (var i = 0; i < array_length(_preload_mgs); i++)
    {
        if (script_exists(_preload_mgs[i]))
        {
            var _preload_mg = new _preload_mgs[i]();
        }
    }
    var _struct = preloads.smf_obj;
    var _arr = struct_get_names(_struct);
    for (var i = 0; i < array_length(_arr); i++)
    {
        var _path = _arr[i];
        var _model = smf_model_load_obj(_path);
        struct_set(_struct, _path, _model);
    }
    preloading = false;
    current_process_mg = -1;
    with (char)
    {
        init();
    }
    if (endless_mode)
    {
        with (char)
        {
            results_screen_draw = function()
            {
                var cx = 240;
                var cy = 135;
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_sprite(spr_endlessresults_title, 0, 0, 0);
                if (obj_minigame_controller.results_screen_phase >= 1)
                {
                    var roundstr = string(_round);
                    var _textfx = 
                    {
                        splitfill: 
                        {
                            bottom_color: 14656968,
                            y_threshold: 0.4166666666666667
                        },
                        outline: 
                        {
                            color: 0,
                            width: 3,
                            extra_layers_amount: 1,
                            layers: [
                            {
                                color: 16777215,
                                width: 1
                            }]
                        }
                    };
                    draw_text_special(cx, cy - 30, roundstr, _textfx, 3, 3);
                }
                draw_set_halign(fa_left);
                draw_set_valign(fa_top);
                if (obj_minigame_controller.results_screen_phase >= 2)
                {
                    results_screen_menu._draw();
                    draw_local_highscores(390, 160, endless_score_id, obj_minigame_controller.settings_preset);
                }
            };
        }
    }
    inbetween_length = char.inbetween.get_inbetween_length(inbetween_type);
    queue_next_mg();
    tempo_pos = 0;
    tempo_loops = 0;
    tempo_time = 0;
    tempo_track = -1;
    music_pitch = 1;
    music_pitch_base = music_pitch;
    music_pitch_mod = 0;
    if (is_array(game_music))
    {
        for (var i = 0; i < array_length(game_music); i++)
        {
            audio_stop_sound(game_music[i]);
        }
    }
    else
    {
        audio_stop_sound(game_music);
    }
    game_music = -1;
    use_minigame_music = true;
    after_start();
};

start_timer = function()
{
    tempo_track = audio_play_sound(tempo_sound, true, 10, 0, 0, start_speed);
    music_pitch = audio_sound_get_pitch(tempo_track);
    if (game_music != -1)
    {
        if (is_array(game_music))
        {
            for (var i = 0; i < array_length(game_music); i++)
            {
                audio_sound_set_track_position(game_music[i], -char.music_offset);
            }
        }
        else
        {
            audio_sound_set_track_position(game_music, -char.music_offset);
        }
    }
    if (char.music_id != -1 && game_music == -1)
    {
        game_music = audio_play_sound_on(master.emit_mus, char.music_id, true, 10, 1, -char.music_offset);
        use_minigame_music = false;
    }
    play_inbetween_jingle(char.inbetween.get_intro_jingle());
};

play_inbetween_jingle = function(arg0)
{
    if (arg0 == -1)
    {
        exit;
    }
    if (game_music != -1)
    {
        exit;
    }
    if (combo_mode && !combo_display_inbetween)
    {
        exit;
    }
    var _snd = audio_play_sound_on(master.emit_mus, arg0, false, 10, 1, 0, music_pitch);
    var _newjin = new jingle_const(_snd);
    _newjin.start_beat = round(get_current_beat());
    array_insert(jingles, 0, _newjin);
    return _snd;
};

jingle_const = function(arg0) constructor
{
    sound_inst = arg0;
    start_beat = 0;
};

queue_mg = function(arg0)
{
    var _prev_current_process_mg = current_process_mg;
    next_mg_script = arg0;
    next_mg = new arg0();
    prompt_mg = next_mg;
    next_mg.choose_difficulty();
    next_mg.after_queued();
    current_process_mg = _prev_current_process_mg;
};

minigame_intro_length = 1;
minigame_outro_length = 1;
minigame_initialized = false;
minigame_started = false;

init_mg = function()
{
    if (minigame_initialized)
    {
        exit;
    }
    video_close();
    var this_mg = next_mg;
    if (surface_exists(mg_surface))
    {
        if (this_mg.screen_w != surface_get_width(mg_surface) || this_mg.screen_h != surface_get_height(mg_surface))
        {
            surface_resize(mg_surface, this_mg.screen_w, this_mg.screen_h);
        }
    }
    active_mgs = [this_mg];
    set_current_beat();
    var cb = round_to_multiple(current_beat, 0.5);
    if (!combo_mode)
    {
        cb += char.inbetween.minigame_intro_length;
    }
    this_mg._controller = char;
    current_process_mg = this_mg;
    with (this_mg)
    {
        beat_start = cb;
        _init();
    }
    current_process_mg = -1;
    var scriptname = script_get_name(next_mg_script);
    if (struct_exists(play_stats.played_minigames, scriptname))
    {
        struct_set(play_stats.played_minigames, scriptname, struct_get(play_stats.played_minigames, scriptname) + 1);
    }
    else
    {
        struct_set(play_stats.played_minigames, scriptname, 1);
    }
    struct_set(minigame_highest_difficulties, scriptname, this_mg.difficulty);
    if (struct_exists(minigame_difficulties_times_seen, scriptname))
    {
        var _this_mg_diffs_times_seen = struct_get(minigame_difficulties_times_seen, scriptname);
        var _this_diff_times_seen = 0;
        if (struct_exists(_this_mg_diffs_times_seen, this_mg.difficulty))
        {
            _this_diff_times_seen = struct_get(_this_mg_diffs_times_seen, this_mg.difficulty);
        }
        _this_diff_times_seen++;
        struct_set(_this_mg_diffs_times_seen, this_mg.difficulty, _this_diff_times_seen);
    }
    else
    {
        var __struct = {};
        struct_set(__struct, this_mg.difficulty, 1);
        struct_set(minigame_difficulties_times_seen, scriptname, __struct);
    }
    var center_mouse = true;
    var active_popup = gimmick_is_active(gimmick_popup);
    if (active_popup)
    {
        active_popup = gimmicks[active_popup - 1];
        if (array_length(active_popup.popups) > 0)
        {
            center_mouse = false;
        }
    }
    if (center_mouse)
    {
        window_mouse_set(window_get_width() / 2, window_get_height() / 2);
    }
    gimmick_event("_on_minigame_init");
    minigame_initialized = true;
};

start_mg = function()
{
    minigame_started = true;
    audio_stop_sound(snd_endlesswindup);
    var this_mg = next_mg;
    current_process_mg = this_mg;
    with (this_mg)
    {
        _start();
    }
    current_process_mg = -1;
    gimmick_event("_on_minigame_start");
};

return_to_inbetween = function(arg0)
{
    var cnt = char;
    var suc = arg0;
    inbetween_start_beat = active_mgs[0].beat_end;
    minigame_initialized = false;
    minigame_started = false;
    inbetween_timer = -1;
    inbetween_start_beat = round(current_beat);
    ds_list_copy(master.input_keys_check, master.default_input_keys_check);
    for (var i = 0; i < array_length(sfx_array); i++)
    {
        audio_stop_sound(sfx_array[i]);
    }
    sfx_array = [];
    if (!(combo_mode && !combo_display_inbetween))
    {
        prompt_time = -1;
    }
    if (game_ended)
    {
        inbetween_type = 3;
        results_flash = 1;
    }
    else
    {
        inbetween_type = 0;
        prev_speed = music_pitch;
        var _isboss = cnt.round_is_boss(cnt._round);
        if (_isboss)
        {
            inbetween_type = 2;
            if (goal_speed != 1)
            {
                preboss_speed = goal_speed;
            }
            goal_speed = 1;
            cnt.round_was_boss = true;
        }
        else
        {
            var _speedup = 0;
            var _levelup = cnt.choose_levelup(cnt._round);
            if (_levelup == 0)
            {
                _speedup = cnt.choose_speedup(cnt._round);
            }
            if (preboss_speed != 1)
            {
                _speedup += (preboss_speed - music_pitch);
                preboss_speed = 1;
            }
            var newlevel = clamp(cnt.level + _levelup, 0, cnt.max_level);
            if (newlevel != cnt.level)
            {
                cnt.level = newlevel;
                inbetween_type = 5;
                goal_speed = cnt.levelup_base_speed;
            }
            else
            {
                var _max_speed = cnt.max_speed;
                if (settings.max_speed != -1)
                {
                    _max_speed = settings.max_speed;
                }
                var newspeed = clamp(prev_speed + _speedup, 0.1, _max_speed);
                if (newspeed != prev_speed)
                {
                    goal_speed = newspeed;
                    inbetween_type = 1;
                }
            }
        }
        if (!combo_mode)
        {
            queue_next_mg();
        }
    }
    cnt.inbetween.success_state = suc;
    cnt.inbetween._lives = cnt._lives;
    cnt.inbetween._round = cnt._round;
    var prcs_save = current_process_mg;
    current_process_mg = -1;
    cnt.inbetween.__on_return();
    current_process_mg = prcs_save;
    inbetween_length = cnt.inbetween.get_inbetween_length(inbetween_type);
    inbetween_timer = inbetween_length;
    cnt.choose_next_gimmick();
    play_return_jingle(arg0);
};

play_return_jingle = function(arg0)
{
    var ibt_jingle = -1;
    var cnt = char;
    var suc = arg0;
    switch (inbetween_type)
    {
        case 4:
            break;
        case 0:
        default:
            if (suc == -1)
            {
                ibt_jingle = cnt.inbetween.get_lose_jingle();
            }
            else
            {
                ibt_jingle = cnt.inbetween.get_win_jingle();
            }
            break;
    }
    if (ibt_jingle != -1)
    {
        play_inbetween_jingle(ibt_jingle);
    }
    jingle_prog = 0;
};

stop_sounds = function()
{
    var _sound_arrs = [game_music, sfx_pause_array];
    for (var i = 0; i < array_length(_sound_arrs); i++)
    {
        var _arr = _sound_arrs[i];
        for (var j = 0; j < array_length(_arr); j++)
        {
            audio_stop_sound(_arr[j]);
            array_delete(_arr, j, 1);
            j--;
        }
    }
};

on_game_end = function()
{
    clear_gimmicks();
};

queue_next_mg = function()
{
    var on_blacklist = true;
    var _next_mg;
    while (on_blacklist)
    {
        _next_mg = char.pick_next_minigame();
        queue_mg(_next_mg);
        on_blacklist = false;
        var _blacklist = next_mg.gimmick_blacklist;
        for (var i = 0; i < array_length(gimmicks) && !on_blacklist; i++)
        {
            var _gim = gimmicks[i];
            var _script = asset_get_index(instanceof(_gim));
            _gim.blacklisted_by_minigame = array_contains(_blacklist, _script);
            if (_gim.blacklisted_by_minigame)
            {
                on_blacklist = _gim.blacklistable;
            }
        }
        if (on_blacklist)
        {
            show_debug_message("Gimmick Blacklisted for minigame: \"" + next_mg.name + "\". Skipping.");
        }
    }
    array_push(char.last_few_mgs, _next_mg);
    if (array_length(char.last_few_mgs) > 7)
    {
        array_delete(char.last_few_mgs, 0, 1);
    }
};

mg_container_surface = -1;
mg_surface = -1;
prompt_scale = 0;
prompt_time = -1;

set_prompt_scale = function(arg0)
{
    if (arg0 < 10)
    {
        return (arg0 / 10) * 1.1;
    }
    else if (arg0 < 25)
    {
        return 1.1 - (0.1 * ((arg0 - 15) / 10));
    }
    return 1;
};

base_bpm = 128;
music_pitch = 1;
music_pitch_base = 1;
music_pitch_mod = 0;
measure_length = 4;
game_active = false;
inbetween_start_beat = 0;
inbetween_length = 8;
inbetween_timer = 0;
inbetween_timer_max = (base_bpm / 60) * room_speed;
inbetween_type = 0;
game_music = -1;
use_minigame_music = true;
tempo_sound = sfx_none;
tempo_track = -1;
tempo_pos = 0;
tempo_loops = 0;
tempo_time = 0;

set_current_beat = function()
{
    current_beat = get_current_beat();
    current_beat_mod = current_beat % measure_length;
};

get_current_beat = function()
{
    return tempo_time * (base_bpm / room_speed);
};

set_current_beat();
current_beat_mod = -1;
start_speed = 1;
goal_speed = 1;
prev_speed = 1;
spedup_this_round = false;
preboss_speed = 1;
show_speed_message = 0;
show_timer = true;
play_tick_sounds = false;
start_timestamp = -1;
paused = false;
pause_delay_max = 10;
pause_delay = 0;
pause_menu = new story_pause_menu_constructor();

pause_menu.on_resume_click = function()
{
    if (pause_countdown == 0)
    {
        pause_countdown = 3;
        pause_menu.close();
    }
};

pause_menu.on_quit_click = function()
{
    if (allow_pause && pause_countdown == 0)
    {
        start_exit();
    }
};

pause_countdown = 0;
results_flash = 0;
pause_skip_str = strloc("system/cutscene/skip_button");
text = 
{
    paused_text: strloc("system/gameplay/pause_screen/paused_text"),
    exit_button: strloc("system/gameplay/pause_screen/exit_button")
};
view = 0;

set_game_speed = function(arg0, arg1 = false, arg2 = false)
{
    var pitch_change = arg0 - music_pitch;
    if (pitch_change != 0)
    {
        startpitch = audio_sound_get_pitch(tempo_track);
        if (arg2)
        {
            music_pitch_mod = (startpitch + pitch_change) - music_pitch_base;
        }
        else
        {
            music_pitch_base = startpitch + pitch_change;
        }
        music_pitch = music_pitch_base + music_pitch_mod;
        prev_speed = music_pitch;
        goal_speed = music_pitch;
        audio_sound_pitch(tempo_track, music_pitch);
        for (var i = 0; i < array_length(jingles); i++)
        {
            audio_sound_pitch(jingles[i].sound_inst, music_pitch);
        }
        show_debug_message("______");
        show_debug_message("pitch base: " + string(music_pitch_base));
        show_debug_message("pitch mod: " + string(music_pitch_mod));
        show_debug_message("pitch: " + string(music_pitch));
        if (arg1)
        {
            show_speed_message = 60;
        }
    }
};

dbg_view("Minigames", false);
dbgcontrols = dbg_section("Controls");
dbg_button("Restart", start_game);
dbg_watch(ref_create(self, "music_pitch"), "Game Speed");
dbg_button("Decrease", function()
{
    set_game_speed(music_pitch - 0.1, true);
});
dbg_same_line();
dbg_button("Increase", function()
{
    set_game_speed(music_pitch + 0.1, true);
});
dbg_button("Skip Inbetween", skip_inbetween);
show_debug_overlay(false);

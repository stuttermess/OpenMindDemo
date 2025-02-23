function charselect_character_constructor() constructor
{
    character_script = -1;
    leaderboard_id = -1;
    local_leaderboard_id = -1;
    name_sprite = spr_charselect_sparkle_name;
    name = "Character";
    letterbox_color = 0;
    allowed_modes = [0, 1];
    settings = 
    {
        mode: 1,
        gimmicks_enabled: true,
        levelup_enabled: true,
        max_speed: 2.8
    };
    settings_presets = 
    {
        Default: 
        {
            gimmicks_enabled: true,
            levelup_enabled: true
        },
        no_gimmicks: 
        {
            gimmicks_enabled: false,
            levelup_enabled: false,
            max_speed: 99
        }
    };
    settings_presets_array = ["default", "no_gimmicks"];
    settings_preset = "default";
    start_cutscene = -1;
    mmbgthings_spr = spr_mmbg_8stuff;
    mmbgthings_ind = 0;
    background_sf = -1;
    time = 0;
    char_sprite = -1;
    char_frame = 0;
    char_loop_frame = 0;
    
    _tick = function()
    {
        time++;
        if (sprite_exists(char_sprite))
        {
            char_frame += (sprite_get_speed(char_sprite) / 60);
            if (char_frame >= sprite_get_number(char_sprite))
            {
                char_frame -= (floor(char_frame) - char_loop_frame);
            }
        }
    };
    
    draw_background = function()
    {
    };
    
    cleanup = function()
    {
    };
    
    _draw_background = function(arg0, arg1, arg2)
    {
        if (character_script != -1 && !surface_exists(background_sf))
        {
            background_sf = surface_create(470, 270);
        }
        if (surface_exists(background_sf))
        {
            surface_set_target(background_sf);
            draw_clear_alpha(c_white, 0);
            var matrix_translate_origin = matrix_build(100, 0, 0, 0, 0, 0, 1, 1, 1);
            matrix_set(2, matrix_translate_origin);
            draw_sprite(spr_charselect_mask, 0, 0, 0);
            gpu_set_colorwriteenable(1, 1, 1, 0);
            draw_background();
            gpu_set_colorwriteenable(1, 1, 1, 1);
            matrix_set(2, matrix_build_identity());
            surface_reset_target();
            draw_surface(background_sf, arg0 - 100 - 240, arg1 - 135);
        }
    };
    
    _draw_character = function(arg0, arg1, arg2)
    {
        if (sprite_exists(char_sprite))
        {
            draw_sprite(char_sprite, char_frame, arg0, arg1);
        }
    };
    
    minigame_count = 16;
    options_str_original = ["play_button", "leaderboard_button", "simple_mode_toggle", "back_button"];
    for (var i = 0; i < array_length(options_str_original); i++)
    {
        options_str[i] = strloc("menus/character_select/" + options_str_original[i]);
    }
    options_onclick = [function()
    {
        enter_game();
    }, function()
    {
        obj_charselect_menu.open_steam_leaderboard();
        sfx_play(snd_menu_click);
    }, function()
    {
        var __preset = "default";
        switch (settings_preset)
        {
            case "default":
                __preset = "no_gimmicks";
                break;
            case "no_gimmicks":
                __preset = "default";
                break;
        }
        set_settings_preset(__preset);
        var _slot = 1;
        if (obj_charselect_menu.character_num == 1)
        {
            _slot = 2;
        }
        obj_charselect_menu.character_settings_save[_slot] = 
        {
            preset: __preset,
            settings: {}
        };
        obj_charselect_menu.character_settings_save[_slot].settings = struct_copy(settings);
        sfx_play(snd_menu_click_minor);
    }, function()
    {
        if (variable_instance_exists(obj_charselect_menu, "back_to_main_menu"))
        {
            obj_charselect_menu.back_to_main_menu();
        }
    }];
    on_game_end = -1;
    
    on_game_exit = function()
    {
        if (instance_exists(obj_minigame_controller))
        {
            obj_minigame_controller.char.on_game_end = function()
            {
            };
            
            instance_destroy(obj_minigame_controller);
        }
        global.main_menu_music_gain = 0;
        instance_create_depth(0, 0, 0, obj_mainmenu_controller);
        with (obj_mainmenu_controller)
        {
            active_menu = menu_main;
            logo_lerp = 0;
            main_lerp = 1;
        }
        instance_create_depth(0, 0, 0, obj_charselect_menu);
        with (obj_charselect_menu)
        {
            menu_in = 1;
            screen_transition = 1;
        }
        instance_destroy(cutscene_controller);
    };
    
    get_enter_transition = function()
    {
        return start_transition(transition_perlin);
    };
    
    enter_game = function()
    {
        var _cont = get_enter_transition();
        obj_charselect_menu.can_click = false;
        audio_sound_gain(obj_mainmenu_controller.music, 0, 1000);
        global.mainmenu_muspos_save = audio_sound_get_track_position(obj_mainmenu_controller.music);
        audio_sound_end_on_fade(obj_mainmenu_controller.music);
        sfx_play(snd_menu_click_major);
        
        _cont.on_intro_end = function()
        {
            var _use_cutscene = is_struct(start_cutscene) || script_exists(start_cutscene);
            if (_use_cutscene)
            {
                var _cs = start_cutscene;
                if (script_exists(_cs))
                {
                    _cs = new _cs();
                }
                _cs._on_finish = start_game;
                _cs.events[0].pause_menu.on_quit = on_game_exit;
                destroy_css();
                play_cutscene_struct(_cs);
            }
            else
            {
                destroy_css();
                start_game();
            }
        };
    };
    
    destroy_css = function()
    {
        obj_charselect_menu.save();
        var _music = obj_mainmenu_controller.music;
        if (audio_is_playing(_music))
        {
            audio_stop_sound(_music);
        }
        instance_destroy(obj_mainmenu_controller);
        instance_destroy(obj_charselect_menu);
    };
    
    start_game = function()
    {
        if (instance_exists(obj_minigame_controller))
        {
            exit;
        }
        var mgc = instance_create_depth(0, 0, 0, obj_minigame_controller);
        mgc.start_speed = 1;
        mgc.char_script = character_script;
        mgc.char = new mgc.char_script();
        mgc.endless_mode = settings.mode == 1;
        mgc.story_mode = settings.mode == 0;
        if (settings.max_speed != -1)
        {
            mgc.max_speed = settings.max_speed;
        }
        mgc.settings_preset = settings_preset;
        mgc.settings = struct_merge(mgc.settings, settings, true, false, false);
        if (mgc.endless_mode)
        {
            mgc.steam_leaderboard_id = get_steam_leaderboard_name();
            mgc.leaderboard_display_name = get_leaderboard_display_name();
            
            mgc.after_start = function()
            {
                if (on_game_end != -1)
                {
                    obj_minigame_controller.char.on_game_end = on_game_end;
                }
                obj_minigame_controller.char.on_exit = on_game_exit;
                with (obj_minigame_controller)
                {
                    use_minigame_music = true;
                    char.music_id = -1;
                    game_music = -1;
                    with (char)
                    {
                        results_screen_menu = new menu_constructor();
                        results_screen_menu.add_sprite_button(spr_endlessbtn_retry, function()
                        {
                            audio_sound_gain(mus_endlessresults, 0, 1000);
                            audio_sound_end_on_fade(mus_endlessresults);
                            start_transition_perlin(obj_minigame_controller.start_game, false);
                        }, 0, 0);
                        results_screen_menu.add_sprite_button(spr_endlessbtn_leaderboard, function()
                        {
                            obj_minigame_controller.open_steam_leaderboard();
                        }, 0, 0);
                        results_screen_menu.add_sprite_button(spr_endlessbtn_exit, function()
                        {
                            obj_minigame_controller.start_exit();
                        }, 0, 0);
                        for (var i = 0; i < array_length(results_screen_menu.buttons); i++)
                        {
                            var _btn = results_screen_menu.buttons[i];
                            with (_btn)
                            {
                                onhover = function()
                                {
                                    var buh = 0;
                                };
                                
                                onpress = function()
                                {
                                    image_index = 1;
                                };
                                
                                onunhover = function()
                                {
                                    image_index = 0;
                                };
                                
                                onrelease = function()
                                {
                                    image_index = 0;
                                };
                            }
                        }
                    }
                }
            };
        }
        else
        {
            mgc.after_start = function()
            {
                if (on_game_end != -1)
                {
                    obj_minigame_controller.char.on_game_end = on_game_end;
                }
            };
        }
        mgc.on_exit = on_game_exit;
        mgc.start_game(false);
    };
    
    get_leaderboard_display_name = function()
    {
        var _str = name;
        var _preset_name = "";
        switch (settings_preset)
        {
            case "custom":
                _preset_name = "custom";
                break;
            case "default":
                _preset_name = "";
                break;
            case "no_gimmicks":
                _preset_name = "no_gimmicks";
                break;
        }
        if (_preset_name != "")
        {
            _preset_name = strloc("menus/character_select/presets/" + _preset_name);
            _str = string_replace(strloc("menus/character_select/presets/leaderboard_name_template"), "#CHARACTER_NAME#", _str);
            _str = string_replace(_str, "#PRESET_NAME#", _preset_name);
        }
        return _str;
    };
    
    get_steam_leaderboard_name = function()
    {
        if (is_string(leaderboard_id))
        {
            switch (settings_preset)
            {
                case "custom":
                    return "null";
                    break;
                case "default":
                default:
                    var _str = leaderboard_id + "__" + settings_preset;
                    return _str;
                    break;
            }
        }
    };
    
    set_settings_preset = function(arg0)
    {
        var _preset = struct_get(settings_presets, arg0);
        settings = struct_merge(settings, _preset);
        settings_preset = arg0;
    };
}

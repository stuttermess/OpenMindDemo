function gamechar_constructor() constructor
{
    name = "Character";
    endless_score_id = "";
    
    on_game_end = function()
    {
        with (obj_minigame_controller)
        {
            if (char._lives <= 0 || endless_mode)
            {
                results_screen_time = 0;
                show_results_screen = true;
                if (endless_mode)
                {
                    char.end_endless_mode();
                }
            }
        }
    };
    
    after_game = function()
    {
    };
    
    end_endless_mode = function()
    {
        var _round = self._round;
        with (obj_minigame_controller)
        {
            results_screen_time = 0;
            show_results_screen = true;
            steam_upload_score(steam_leaderboard_id, _round);
        }
        update_local_endless_score(endless_score_id, obj_minigame_controller.settings_preset, _round);
    };
    
    results_screen_menu = new menu_constructor();
    
    results_screen_draw = function()
    {
        results_screen_menu._draw();
    };
    
    get_start_offset = function()
    {
        return 0;
    };
    
    bpm = 128;
    available_minigames = [mg_template];
    gimmick_chance = 0.5;
    gimmicks_start_round = 30;
    gimmicks_pool = [gimmick_popup, gimmick_combo, gimmick_flip];
    
    pick_next_minigame = function()
    {
        if (round_is_boss(_round))
        {
            return boss_minigame;
        }
        else
        {
            if (array_length(minigame_queue) == 0)
            {
                array_copy(minigame_queue, 0, available_minigames, 0, array_length(available_minigames));
                array_shuffle_ext(minigame_queue);
                var move_to_back = [];
                for (var i = 0; i < min(array_length(minigame_queue), array_length(last_few_mgs)); i++)
                {
                    if (array_contains(last_few_mgs, minigame_queue[i]))
                    {
                        array_push(move_to_back, i);
                    }
                }
                if (array_length(move_to_back) > 0)
                {
                    var i = array_length(move_to_back) - 1;
                    while (i >= 0)
                    {
                        array_push(minigame_queue, minigame_queue[move_to_back[i]]);
                        array_delete(minigame_queue, move_to_back[i], 1);
                        i--;
                    }
                }
                last_few_mgs = [];
            }
            var this_mg = minigame_queue[0];
            array_delete(minigame_queue, 0, 1);
            return this_mg;
        }
    };
    
    minigames_check_back = 7;
    next_round_on_lose = true;
    
    choose_minigame_difficulty = function()
    {
        return floor(_round / 15);
    };
    
    boss_minigame = mg_template;
    rounds_per_boss = 15;
    
    round_is_boss = function(arg0)
    {
        var isboss = (arg0 % rounds_per_boss) == 0 && arg0 > 0;
        return isboss;
    };
    
    max_speed = 2.18;
    rounds_per_speedup = 5;
    speedup_amount = 0.07;
    
    choose_speedup = function(arg0)
    {
        if (arg0 == 0)
        {
            return 0;
        }
        if ((arg0 % rounds_per_speedup) == 0 || round_is_boss(arg0 - 1))
        {
            return speedup_amount;
        }
        else
        {
            return 0;
        }
    };
    
    rounds_per_levelup = gimmicks_start_round;
    max_level = 1;
    levelup_base_speed = 1.2;
    
    choose_levelup = function(arg0)
    {
        if (arg0 == 0)
        {
            return 0;
        }
        if (!obj_minigame_controller.endless_mode)
        {
            return 0;
        }
        if (!obj_minigame_controller.settings.levelup_enabled)
        {
            return 0;
        }
        if ((arg0 % rounds_per_levelup) == 0 && (level + 1) <= max_level)
        {
            return 1;
        }
        else
        {
            return 0;
        }
    };
    
    game_end_round = 16;
    music_offset = 0;
    music_id = -1;
    music_bpm = 128;
    timer_script = timer_tutorial;
    ibt_script = inbetween_constructor;
    win_lose_sound_bpm = -1;
    
    choose_win_sound = function()
    {
        return -1;
    };
    
    choose_lose_sound = function()
    {
        return -1;
    };
    
    choose_next_gimmick_basic = function()
    {
        if (!instance_exists(obj_minigame_controller))
        {
            exit;
        }
        if (obj_minigame_controller.endless_mode && _round >= gimmicks_start_round && random(1) <= gimmick_chance)
        {
            if (array_length(obj_minigame_controller.gimmicks) == 0)
            {
                if (array_length(gimmicks_queue) == 0)
                {
                    array_copy(gimmicks_queue, 0, gimmicks_pool, 0, array_length(gimmicks_pool));
                    array_shuffle_ext(gimmicks_queue);
                }
                if (array_length(gimmicks_queue) > 0)
                {
                    var _success = obj_minigame_controller.start_gimmick(gimmicks_queue[0]);
                    if (_success)
                    {
                        array_delete(gimmicks_queue, 0, 1);
                    }
                }
            }
        }
    };
    
    choose_next_gimmick = function()
    {
        if (!instance_exists(obj_minigame_controller))
        {
            exit;
        }
        var _mgc = obj_minigame_controller;
        var _round = _mgc.char._round;
        if (!(_mgc.endless_mode && _round >= gimmicks_start_round))
        {
            exit;
        }
        var _start_round = gimmicks_start_round;
        var __round = _round - _start_round;
        var get_gimmick_last_appeared = _mgc.get_gimmick_last_appeared;
        var tier1 = 0;
        var tier2 = 15;
        var tier3 = 30;
        var tier4 = 50;
        var tier5 = 60;
        var _round_length_frames = (4 * room_speed) / get_game_speed();
        if (__round >= 0 && __round <= tier2)
        {
            if (!gimmick_is_active(gimmick_popup))
            {
                var _args = 
                {
                    set_appear_timer_speed: function()
                    {
                        appear_timer_speed = 1;
                        return appear_timer_speed;
                    },
                    
                    appear_time_lower: _round_length_frames * 2,
                    appear_time_upper: _round_length_frames * 5,
                    first_popup_appear_time: _round_length_frames * 2,
                    finish_round: _round + 15,
                    amount_to_bust: infinity
                };
                _mgc.start_gimmick(gimmick_popup, _args);
            }
        }
        else if (__round > tier2 && __round <= tier3)
        {
            if ((_round - get_gimmick_last_appeared(gimmick_flip)) >= 5)
            {
                if (choose(0, 0, 1))
                {
                    var _args = 
                    {
                        minigames_length: 1
                    };
                    _mgc.start_gimmick(gimmick_flip, _args);
                }
            }
        }
        else if (__round > tier3 && __round < tier4)
        {
            switch (__round - tier3)
            {
                case 0:
                case 10:
                case 20:
                    if (!gimmick_is_active(gimmick_combo))
                    {
                        _mgc.start_gimmick(gimmick_combo);
                    }
                    break;
            }
        }
        else if (__round >= tier4 && __round < tier5)
        {
            if (__round == tier4)
            {
                var _args = 
                {
                    set_appear_timer_speed: function()
                    {
                        appear_timer_speed = 1;
                        return appear_timer_speed;
                    },
                    
                    appear_time_lower: _round_length_frames * 1,
                    appear_time_upper: _round_length_frames * 3,
                    finish_round: _round + 50,
                    amount_to_bust: infinity
                };
                if (gimmick_is_active(gimmick_popup))
                {
                    obj_minigame_controller.gimmick_apply_arguments(gimmick_popup, _args);
                }
                else
                {
                    _mgc.start_gimmick(gimmick_popup, _args);
                }
            }
            if ((_round - get_gimmick_last_appeared(gimmick_flip)) >= 5)
            {
                if (choose(0, 0, 1))
                {
                    var _args = 
                    {
                        minigames_length: 1
                    };
                    _mgc.start_gimmick(gimmick_flip, _args);
                }
            }
            if ((__round % 13) == 0 && __round > 53)
            {
                if (!gimmick_is_active(gimmick_combo))
                {
                    _mgc.start_gimmick(gimmick_combo);
                }
            }
        }
        else
        {
            if (__round == tier5)
            {
                var _args = 
                {
                    set_appear_timer_speed: function()
                    {
                        appear_timer_speed = 1;
                        return appear_timer_speed;
                    },
                    
                    appear_time_lower: _round_length_frames * 1,
                    appear_time_upper: _round_length_frames * 3,
                    finish_round: infinity,
                    amount_to_bust: infinity
                };
                if (gimmick_is_active(gimmick_popup))
                {
                    obj_minigame_controller.gimmick_apply_arguments(gimmick_popup, _args);
                }
                else
                {
                    _mgc.start_gimmick(gimmick_popup, _args);
                }
            }
            if ((_round - get_gimmick_last_appeared(gimmick_flip)) >= 5)
            {
                if (choose(0, 0, 1))
                {
                    var _args = 
                    {
                        minigames_length: choose(1, 2)
                    };
                    _mgc.start_gimmick(gimmick_flip, _args);
                }
            }
            if ((__round % 10) == 0 && __round > tier5)
            {
                if (!gimmick_is_active(gimmick_combo))
                {
                    _mgc.start_gimmick(gimmick_combo);
                }
            }
        }
    };
    
    use_skip_button = false;
    
    on_skip = function()
    {
        _end_game();
    };
    
    _tick = function()
    {
        if (intro_time < 1)
        {
            var offs = get_start_offset();
            if (offs <= 0 && 0)
            {
                intro_time = 1;
            }
            else
            {
                intro_time += (1 / (offs * room_speed));
            }
            if ((intro_time * offs) > ((offs + music_offset) - 0.025) && obj_minigame_controller.game_music == -1)
            {
                with (obj_minigame_controller)
                {
                    if (char.music_id != -1 && game_music == -1)
                    {
                        game_music = audio_play_sound_on(master.emit_mus, char.music_id, true, 10, 0.75, 0);
                        use_minigame_music = false;
                    }
                }
            }
            if (intro_time >= 1)
            {
                intro_time = 1;
                with (obj_minigame_controller)
                {
                    start_timer();
                }
            }
        }
        else if (obj_minigame_controller.current_beat >= end_game_beat || end_game)
        {
            _end_game();
        }
        inbetween.__tick();
    };
    
    _draw = function()
    {
        var drawibt = false;
        var _mg_intro_length = inbetween.minigame_intro_length;
        with (obj_minigame_controller)
        {
            if (array_length(active_mgs) > 0)
            {
                if (((active_mgs[0].time <= _mg_intro_length || active_mgs[0].time >= active_mgs[0].time_limit || !active_mgs[0].use_timer) && inbetween_timer >= 0) || (show_results_screen && inbetween_timer <= 0))
                {
                    drawibt = true;
                }
                else
                {
                    drawibt = false;
                }
            }
            else
            {
                drawibt = true;
            }
        }
        if (drawibt)
        {
            obj_minigame_controller.update_inbetween_timer();
            inbetween.inbetween_timer = obj_minigame_controller.inbetween_timer;
            inbetween.__draw();
        }
    };
    
    gimmicks_queue = [];
    
    init = function()
    {
        minigame_queue = [];
        level = 0;
        _round = 0;
        _lives = 4;
        inbetween = -1;
        success_state = 0;
        end_game = false;
        end_game_beat = infinity;
        round_was_boss = false;
        last_few_mgs = [];
        intro_time = 0;
        gimmicks_queue = [];
        inbetween = new ibt_script();
        inbetween.character = self;
        inbetween._init();
    };
    
    _end_game = function()
    {
        if (!obj_minigame_controller.game_ended)
        {
            end_game = true;
            obj_minigame_controller.on_game_end();
            obj_minigame_controller.game_ended = true;
            inbetween.__cleanup();
            on_game_end();
            if (!instance_exists(obj_minigame_controller) || (instance_exists(obj_minigame_controller) && !obj_minigame_controller.exiting))
            {
                after_game();
            }
        }
    };
}

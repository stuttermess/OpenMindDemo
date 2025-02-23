function gamechar_shuffle() : gamechar_constructor() constructor
{
    name = "Shuffle";
    endless_score_id = "shuffle";
    gimmicks_start_round = 30;
    gimmick_chance = 0.6;
    gimmicks_pool = [gimmick_combo, gimmick_popup, gimmick_flip];
    rounds_per_levelup = gimmicks_start_round;
    bpm = 128;
    rounds_per_speedup = 5;
    speedup_amount = 0.08;
    rounds_per_boss = 15;
    game_end_round = 16;
    var _future = new gamechar_future();
    available_minigames = _future.available_minigames;
    minigame_chars = {};
    for (var i = 0; i < array_length(available_minigames); i++)
    {
        struct_set(minigame_chars, script_get_name(available_minigames[i]), "generic");
    }
    chars = 
    {
        generic: 
        {
            inbetween: new ibt_generic(),
            character: new gamechar_generic(),
            timer: timer_tutorial
        },
        tutorial: 
        {
            inbetween: new ibt_tutorial(),
            character: new gamechar_tutorial(),
            timer: timer_tutorial
        },
        sparkle: 
        {
            inbetween: new ibt_sparkle(),
            character: new gamechar_sparkle(),
            timer: timer_sparkle
        }
    };
    var _combochars = [gamechar_sparkle, gamechar_tutorial];
    for (var i = 0; i < array_length(_combochars); i++)
    {
        var __char = new _combochars[i]();
        array_copy(available_minigames, array_length(available_minigames), __char.available_minigames, 0, array_length(__char.available_minigames));
        var charname = string_replace(script_get_name(_combochars[i]), "gamechar_", "");
        for (var j = 0; j < array_length(__char.available_minigames); j++)
        {
            var mgname = script_get_name(__char.available_minigames[j]);
            struct_set(minigame_chars, mgname, charname);
        }
    }
    music_bpm = 128;
    timer_script = timer_tutorial;
    ibt_script = ibt_shuffle;
    
    get_char = function()
    {
        var mg_instof = instanceof(obj_minigame_controller.current_process_mg);
        var _mg_char = struct_get(chars, struct_get(minigame_chars, mg_instof)).character;
        return _mg_char;
    };
    
    choose_win_sound = function()
    {
        var _char = get_char();
        var _snd = _char.choose_win_sound();
        win_lose_sound_bpm = _char.win_lose_sound_bpm;
        return _snd;
    };
    
    choose_lose_sound = function()
    {
        var _char = get_char();
        var _snd = _char.choose_lose_sound();
        win_lose_sound_bpm = _char.win_lose_sound_bpm;
        return _snd;
    };
    
    round_is_boss = function(arg0)
    {
        return false;
    };
    
    choose_speedup = function(arg0)
    {
        if (!obj_minigame_controller.endless_mode)
        {
            return 0;
        }
        if ((arg0 % rounds_per_speedup) == 0 || round_is_boss(arg0 - 1))
        {
            if (arg0 >= 90)
            {
                if (arg0 >= 180)
                {
                    return 0;
                }
                rounds_per_speedup = 10;
                return speedup_amount * 0.8;
            }
            else
            {
                return speedup_amount;
            }
        }
        else
        {
            return 0;
        }
    };
}

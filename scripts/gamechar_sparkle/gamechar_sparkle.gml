function gamechar_sparkle() : gamechar_constructor() constructor
{
    name = "Sparkle";
    endless_score_id = "sparkle";
    gimmicks_start_round = 30;
    gimmick_chance = 0.6;
    gimmicks_pool = [gimmick_popup, gimmick_flip];
    standard_choose_gimmick = choose_next_gimmick;
    
    choose_next_gimmick = function()
    {
        if (instance_exists(obj_minigame_controller) && obj_minigame_controller.endless_mode)
        {
            standard_choose_gimmick();
        }
        else if (struct_exists(inbetween, "act") && inbetween.act == 2)
        {
            if (array_length(obj_minigame_controller.gimmicks) == 0)
            {
                obj_minigame_controller.start_gimmick(gimmick_popup);
            }
        }
    };
    
    standard_pick_next_minigame = pick_next_minigame;
    
    pick_next_minigame = function()
    {
        if (_round == act2_round && !obj_minigame_controller.endless_mode)
        {
            audio_pause_all();
            var _mgs_left = act3_round - _round;
            var remaining_minigames = [];
            array_copy(remaining_minigames, 0, minigame_queue, 0, array_length(minigame_queue));
            minigame_queue = [];
            array_copy(minigame_queue, 0, available_minigames, 0, array_length(available_minigames));
            array_shuffle_ext(minigame_queue);
            for (var i = 0; i < array_length(remaining_minigames); i++)
            {
                var _mg = remaining_minigames[i];
                while (array_get_index(minigame_queue, _mg) != -1)
                {
                    array_delete(minigame_queue, array_get_index(minigame_queue, _mg), 1);
                }
            }
            var insert_index = min(3, array_length(minigame_queue));
            for (var i = 0; i < array_length(remaining_minigames); i++)
            {
                array_insert(minigame_queue, insert_index + i, remaining_minigames[i]);
            }
            array_shuffle_ext(minigame_queue, insert_index, _mgs_left - insert_index);
            audio_resume_all();
            return standard_pick_next_minigame();
        }
        else
        {
            return standard_pick_next_minigame();
        }
    };
    
    results_screen_menu = new menu_constructor();
    results_screen_menu.add_sprite_button(ibtS_spr_btn_retry, function()
    {
        with (obj_minigame_controller)
        {
            start_game();
            char.results_flash = 1.5;
        }
    }, 400, 135);
    results_screen_menu.add_sprite_button(ibtS_spr_btn_exit, function()
    {
        obj_minigame_controller.start_exit();
    }, 80, 135);
    results_flash = 1.5;
    
    results_screen_draw = function()
    {
        draw_clear(c_black);
        draw_sprite(ibtS_spr_lose, 0, 240, 270);
        draw_sprite(ibtS_spr_textlose, 0, 240, 35);
        results_screen_menu._draw();
        draw_set_alpha(results_flash);
        draw_rectangle(-1, -1, 481, 271, false);
        draw_set_alpha(1);
        results_flash = lerp(results_flash, 0, 0.2);
    };
    
    bpm = 128;
    rounds_per_speedup = 5;
    speedup_amount = 0.08;
    rounds_per_boss = 30;
    game_end_round = 31;
    act2_round = 12;
    act3_round = 25;
    act2_vocals_out_round = act3_round - 4;
    act2_muffle_start_round = act3_round - 1;
    rounds_per_boss = act3_round;
    game_end_round = rounds_per_boss + 1;
    available_minigames = [mg_sGrizz, mg_sChao, mg_sBrush, mg_sBunbox, mg_sPcMash, mg_sPop, mg_sClaw, mg_sCatScamp, mg_sTelRun, mg_sHugRun, mg_sDodge, mg_sDizzy, mg_sDial, mg_sCandyCatch, mg_sKappnball, mg_sPuzzle, mg_sTransform, mg_sStitch];
    boss_minigame = mg_sBOSSjump;
    music_id = sfx_none;
    music_bpm = 128;
    timer_script = timer_sparkle;
    ibt_script = ibt_sparkle;
    
    choose_win_sound = function()
    {
        return choose(ibtS_voice_win1, ibtS_voice_win2, ibtS_voice_win3, ibtS_voice_win4);
    };
    
    choose_lose_sound = function()
    {
        return choose(ibtS_voice_lose1);
    };
    
    round_is_boss = function(arg0)
    {
        var isboss = arg0 == rounds_per_boss && !obj_minigame_controller.endless_mode;
        return isboss;
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

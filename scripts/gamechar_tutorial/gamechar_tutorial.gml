function gamechar_tutorial() : gamechar_constructor() constructor
{
    name = "Tutorial";
    if (instance_exists(obj_minigame_controller))
    {
        if (!obj_minigame_controller.endless_mode && master.profile.played_characters.tutorial)
        {
            use_skip_button = true;
        }
    }
    
    results_screen_tick = function()
    {
    };
    
    results_screen_draw = function()
    {
    };
    
    get_start_offset = function()
    {
        return 5;
    };
    
    bpm = 75;
    available_minigames = [mg_tScamp, mg_tCode, mg_tDuel, mg_tCatch, mg_tShark, mg_tDungeon];
    
    pick_next_minigame = function()
    {
        return available_minigames[_round % array_length(available_minigames)];
    };
    
    boss_minigame = mg_template;
    rounds_per_boss = 15;
    
    round_is_boss = function(arg0)
    {
        var isboss = (arg0 % rounds_per_boss) == 0 && arg0 > 0;
        return isboss;
    };
    
    rounds_per_speedup = 5;
    speedup_amount = 0.07;
    
    choose_speedup = function(arg0)
    {
        return 0;
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
    
    next_round_on_lose = false;
    game_end_round = 16;
    music_offset = -0.8;
    music_id = mus_tutorial;
    audio_sound_loop_start(music_id, 0.8);
    timer_script = timer_tutorial;
    ibt_script = ibt_tutorial;
    
    choose_win_sound = function()
    {
        return -1;
    };
    
    choose_lose_sound = function()
    {
        return -1;
    };
}

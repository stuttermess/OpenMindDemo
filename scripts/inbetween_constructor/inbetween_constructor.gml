function inbetween_constructor() constructor
{
    _round = 0;
    _lives = 4;
    next_control_style = 0;
    success_state = 0;
    inbetween_timer = 0;
    current_beat = 0;
    prev_current_beat = 0;
    character = -1;
    screen_w = 480;
    screen_h = 270;
    draws_minigame_surface = false;
    
    _init = function()
    {
        __init();
    };
    
    _tick = function()
    {
        _round = character._round;
        _lives = character._lives;
        __tick();
        prev_current_beat = current_beat;
    };
    
    __init = function()
    {
    };
    
    __on_return = function()
    {
    };
    
    __tick = function()
    {
    };
    
    __draw = function()
    {
    };
    
    __cleanup = function()
    {
    };
    
    _draw_control_prompt = function(arg0, arg1 = -1)
    {
        return draw_generic_control_prompt(240, 135, arg0, arg1);
    };
    
    _draw_100_stars = function(arg0 = 0, arg1 = 0)
    {
        var sx = 5;
        var sy = 265;
        for (var i = 0; i < floor(_round / 100); i++)
        {
            draw_sprite(spr_inbetween_100_star, 0, sx + arg0, sy + arg1);
            sx += 20;
            if (sx > 460)
            {
                sx = 5;
                sy -= 20;
            }
        }
    };
    
    get_intro_jingle = function()
    {
        return -1;
    };
    
    get_win_jingle = function()
    {
        return -1;
    };
    
    get_prep_jingle = function()
    {
        return -1;
    };
    
    get_lose_jingle = function()
    {
        return -1;
    };
    
    get_speedup_jingle = function()
    {
        return -1;
    };
    
    get_boss_jingle = function()
    {
        return -1;
    };
    
    intro_length = 8;
    minigame_intro_length = 0.5;
    minigame_outro_length = 0.5;
    
    get_inbetween_length = function(arg0)
    {
        switch (arg0)
        {
            case 4:
                return intro_length;
                break;
            case 0:
                return 8;
                break;
            case 1:
            case 5:
                return 12;
                break;
            case 2:
                return 16;
                break;
            case 3:
                return 4;
                break;
        }
    };
}

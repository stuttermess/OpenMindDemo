function gamechar_generic() : gamechar_constructor() constructor
{
    ibt_script = ibt_generic;
    
    choose_win_sound = function()
    {
        return -1;
    };
    
    choose_lose_sound = function()
    {
        return -1;
    };
}

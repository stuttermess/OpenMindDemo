function charselect_future() : charselect_character_constructor() constructor
{
    letterbox_color = 8388736;
    char_sprite = irandom(spr_smallblank);
    allowed_modes = [0];
    character_script = gamechar_future;
    
    draw_background = function()
    {
        draw_clear(c_purple);
    };
    
    name = spr_charselect_sparkle_name;
    minigame_count = 2;
    array_delete(options_str, 1, 1);
    array_delete(options_onclick, 1, 1);
    
    on_game_end = function()
    {
        var _on_game_exit = on_game_exit;
        with (obj_minigame_controller)
        {
            if (story_mode)
            {
                results_screen_time = 0;
                show_results_screen = true;
                _on_game_exit();
            }
        }
    };
}

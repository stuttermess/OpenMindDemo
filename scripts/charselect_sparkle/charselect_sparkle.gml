function charselect_sparkle() : charselect_character_constructor() constructor
{
    leaderboard_id = "sparkle_endless";
    local_leaderboard_id = "sparkle";
    letterbox_color = 16742911;
    char_sprite = spr_charselect_sparkle;
    char_loop_frame = 20;
    character_script = gamechar_sparkle;
    
    draw_background = function()
    {
        shader_set_wavy_spriteframe(spr_charselect_sparkle_bg, 0, time / 60, 1, 5000, 4, 0.3, 1000, 2);
        draw_sprite(spr_charselect_sparkle_bg, 0, 370, 135);
        shader_reset();
    };
    
    name = "Starlight";
    name_sprite = spr_charselect_sparkle_name;
    minigame_count = 16;
    story_intro_cutscene = new cutscene_constructor();
    with (story_intro_cutscene)
    {
        events[0] = new csev_object_constructor();
        events[0].skip_through = false;
        events[0].object_id = obj_sparkle_elevator_cutscene;
    }
    
    options_onclick[0] = function()
    {
        switch (settings.mode)
        {
            case 0:
                start_cutscene = story_intro_cutscene;
                break;
            case 1:
                start_cutscene = -1;
                break;
        }
        enter_game();
    };
    
    on_game_end = function()
    {
        var _thischar = self;
        with (obj_minigame_controller)
        {
            if (story_mode)
            {
                if (char._lives <= 0)
                {
                    results_screen_time = 0;
                    show_results_screen = true;
                }
                else
                {
                    instance_destroy(obj_minigame_controller);
                    audio_stop_all();
                    var _cs = new cs_0_4_mindselect();
                    with (_thischar)
                    {
                        _cs.set_pause_on_quit_function(on_game_exit);
                        
                        _cs._on_finish = function()
                        {
                            var _tr = start_transition_perlin(on_game_exit);
                            _tr.intro.length = 1;
                            _tr.intro.time = 1;
                            _tr.intro.back_alpha = 1;
                            _tr.intro.back_color = 0;
                        };
                    }
                    play_cutscene_struct(_cs);
                }
            }
            else if (endless_mode)
            {
                char.end_endless_mode();
            }
        }
    };
}

function cs_0_3() : cutscene_constructor() constructor
{
    events[0] = new csev_sequence_constructor();
    events[0].sequence_id = sqcs_0_3elevator;
    with (events[0])
    {
        skip_through = false;
        _script = load_dialogue_script("scripts/sequence/0/3.mwsc");
        _script_to_events();
    }
    events[1] = new csev_object_constructor();
    events[1].skip_through = false;
    events[1].object_id = obj_sparkle_elevator_cutscene;
    
    _on_finish = function()
    {
        var mgc = instance_create_depth(0, 0, 0, obj_minigame_controller);
        mgc.story_mode = true;
        mgc.char_script = gamechar_sparkle;
        
        mgc.after_start = function()
        {
            obj_minigame_controller.char.on_game_end = function()
            {
                with (obj_minigame_controller)
                {
                    if (exiting)
                    {
                        instance_destroy(obj_minigame_controller);
                        audio_stop_all();
                    }
                    else if (char._lives <= 0)
                    {
                        results_screen_time = 0;
                        show_results_screen = true;
                    }
                    else
                    {
                        var _unlocks = master.profile.unlocks;
                        global.mindselect_was_unlocked = _unlocks.mind_select_menu;
                        _unlocks.mind_select.sparkle = true;
                        _unlocks.mind_select.shuffle = true;
                        _unlocks.mind_select_menu = true;
                        master.profile.played_characters.sparkle = true;
                        profile_save();
                        instance_destroy(obj_minigame_controller);
                        audio_stop_all();
                        play_cutscene(cs_0_4);
                    }
                }
            };
        };
        
        mgc.start_game();
    };
}

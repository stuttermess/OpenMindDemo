function cs_0_1() : cutscene_constructor() constructor
{
    events[0] = new csev_sequence_constructor();
    events[0].sequence_id = sqcs_0_1line;
    with (events[0])
    {
        _script = load_dialogue_script("scripts/sequence/0/1a.mwsc");
        use_as_dialogue_background = true;
        _script_to_events();
    }
    events[1] = new csev_dialogue_constructor();
    events[1]._script = load_dialogue_script("scripts/0/terminal0.mwsc");
    events[1].background_sprite = sqcs_0_1_spr_machinedialoguebg;
    events[1].letterbox_start_in = true;
    events[2] = new csev_sequence_constructor();
    events[2].sequence_id = sqcs_0_1start_calibration;
    events[2]._script = load_dialogue_script("scripts/sequence/0/1b.mwsc");
    events[2]._script_to_events();
    
    _on_finish = function()
    {
        audio_stop_all();
        var mgc = instance_create_depth(0, 0, 0, obj_minigame_controller);
        mgc.char_script = gamechar_tutorial;
        
        mgc.after_start = function()
        {
            obj_minigame_controller.char.on_game_end = function()
            {
                var exiting = obj_minigame_controller.exiting;
                instance_destroy(obj_minigame_controller);
                audio_stop_all();
                if (!exiting)
                {
                    master.profile.played_characters.tutorial = true;
                    set_story_flag("tutorial.minigames.basics", 1);
                    set_story_flag("cuscene_name", "cs_0_2");
                    play_cutscene(cs_0_2);
                    storymode_save();
                }
            };
        };
        
        mgc.start_game();
    };
}

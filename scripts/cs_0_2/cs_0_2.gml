function cs_0_2() : cutscene_constructor() constructor
{
    events[0] = new csev_sequence_constructor();
    
    events[0]._first_frame_draw = function()
    {
        draw_clear(c_white);
    };
    
    events[0].sequence_id = sqcs_0_2after_tutorial;
    with (events[0])
    {
        _script = load_dialogue_script("scripts/sequence/0/2a.mwsc");
        use_as_dialogue_background = true;
        _script_to_events();
    }
    events[1] = new csev_dialogue_constructor();
    events[1]._script = load_dialogue_script("scripts/0/terminal1.mwsc");
    events[1].background_sprite = sqcs_0_1_spr_machinedialoguebg;
    events[1].nextseq_on_end = true;
    events[2] = new csev_sequence_constructor();
    events[2].sequence_id = sqcs_0_2enter_lobby;
    events[2].use_as_dialogue_background = true;
    events[3] = new csev_dialogue_constructor();
    events[3]._script = load_dialogue_script("scripts/0/meetsmalls.mwsc");
    events[3].background_sprite = sqcs_0_2_spr_smallsdialoguebg;
    events[4] = new csev_sequence_constructor();
    events[4].sequence_id = sqcs_0_2_8;
    events[4]._script = load_dialogue_script("scripts/sequence/0/2_8.mwsc");
    events[4]._script_to_events();
    
    _on_finish = function()
    {
        var _tr = start_transition_perlin(function()
        {
            set_story_flag("cuscene_name", "");
            var _cont = instance_create_depth(0, 0, 0, obj_lobby_controller);
            _cont.initialize_lobby(lobby_groundfloor);
            master.story_flags.room_id = "";
            storymode_save();
        });
        with (_tr)
        {
            timer = active.length;
        }
    };
}

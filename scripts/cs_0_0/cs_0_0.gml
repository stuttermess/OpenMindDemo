function cs_0_0() : cutscene_constructor() constructor
{
    events[0] = new csev_sequence_constructor();
    with (events[0])
    {
        sequence_id = sqcs_0_0intro;
        skip_frame = 2882;
        user_pausable = false;
        user_skip_keys = [32, 27];
        _script = load_dialogue_script("scripts/sequence/0/0.mwsc");
        _script_to_events();
        hold_to_skip = false;
    }
    
    _on_finish = function()
    {
        master.profile.stats.seen_opening = true;
        profile_save();
        instance_create_depth(0, 0, 0, obj_mainmenu_controller);
        obj_mainmenu_controller.opening_timer = 0;
    };
}

function cs_demoend() : cutscene_constructor() constructor
{
    events[0] = new csev_sequence_constructor();
    events[0].sequence_id = sqcs_demoend_credits;
    
    events[0]._first_frame_draw = function()
    {
        draw_clear(c_white);
    };
    
    var _exists = variable_global_exists("mindselect_was_unlocked");
    if ((_exists && !global.mindselect_was_unlocked) || !_exists)
    {
        events[1] = new csev_sequence_constructor();
        events[1].sequence_id = sqcs_demoend_unlockmsg;
    }
    
    _on_finish = function()
    {
        if (version_controller.build_type == 3)
        {
            instance_create_depth(0, 0, 0, obj_mainmenu_controller);
        }
        else
        {
            master._restart_game();
        }
    };
}

function cs_bootintro() : cutscene_constructor() constructor
{
    events[0] = new csev_sequence_constructor();
    events[0].sequence_id = sq_hohalogo;
    events[0].hold_to_skip = false;
    events[1] = new csev_sequence_constructor();
    events[1].sequence_id = sq_controlsdisclaimer;
    events[1].hold_to_skip = false;
    events[1].localize_text_tracks();
    events[2] = new csev_sequence_constructor();
    events[2].sequence_id = sq_photosensitivitydisclaimer;
    events[2].hold_to_skip = false;
    events[2].skip_through = true;
    events[2].localize_text_tracks();
    for (var i = 0; i < 3; i++)
    {
        events[i].user_skip_keys = [32, 27];
    }
    
    _on_finish = function()
    {
        var do_firstboot = !master.profile.stats.seen_opening;
        if (do_firstboot)
        {
            instance_create_depth(0, 0, 0, obj_firstopen_controller);
        }
        else
        {
            play_cutscene(cs_0_0);
        }
    };
}

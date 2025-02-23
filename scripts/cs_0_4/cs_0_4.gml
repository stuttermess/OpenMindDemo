function cs_0_4() : cutscene_constructor() constructor
{
    events[0] = new csev_sequence_constructor();
    events[0].sequence_id = sqcs_0_4_bossend;
    events[1] = new csev_sequence_constructor();
    events[1].sequence_id = sqcs_0_4aftersparkle;
    with (events[1])
    {
        _script = load_dialogue_script("scripts/sequence/0/4.mwsc");
        _script_to_events();
    }
    audio_sound_gain(mus_endlessresults, 1, 0);
    
    _on_finish = function()
    {
        play_cutscene(cs_demoend);
    };
}

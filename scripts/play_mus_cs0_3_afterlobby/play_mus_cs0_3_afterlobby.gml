function play_mus_cs0_3_afterlobby()
{
    audio_sound_loop_start(mus_cs0_3_afterlobby, 31.47);
    play_cutscene_sound(mus_cs0_3_afterlobby, 
    {
        type: 1,
        loop: true,
        out_time: 1000
    });
}

function stop_mus_cs0_3_afterlobby()
{
    stop_cutscene_sound(mus_cs0_3_afterlobby);
}

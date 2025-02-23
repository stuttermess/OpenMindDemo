function cs_0_1_scr_terminalsong_start()
{
    if (!instance_exists(cs_0_1_obj_terminalsong))
    {
        var _sng = audio_play_sound_on(master.emit_mus, cs_0_1_mus_terminal, true, 100, 1, 0);
        audio_sound_gain(_sng, 0, 0);
        audio_sound_gain(_sng, 1, 1000);
        var _inst = instance_create_depth(0, 0, 0, cs_0_1_obj_terminalsong);
        _inst.song = _sng;
    }
}

function cs_0_1_scr_terminalsong_end()
{
    if (instance_exists(cs_0_1_obj_terminalsong))
    {
        cs_0_1_obj_terminalsong.stop();
    }
}

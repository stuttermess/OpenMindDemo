function cs_0_1_scr_terminalbeeps_start()
{
    if (!instance_exists(cs_0_1_obj_terminalbeeps))
    {
        var _snd = sfx_play(cs_0_1_snd_processing, true);
        audio_sound_gain(_snd, 0, 0);
        audio_sound_gain(_snd, 1, 1000);
        var _inst = instance_create_depth(0, 0, 0, cs_0_1_obj_terminalbeeps);
        _inst.sound = _snd;
    }
}

function cs_0_1_scr_terminalbeeps_end()
{
    if (instance_exists(cs_0_1_obj_terminalbeeps))
    {
        cs_0_1_obj_terminalbeeps.stop();
    }
}

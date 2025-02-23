function sound_get_beat(arg0, arg1, arg2)
{
    var track_pos = audio_sound_get_track_position(arg0) - (arg2 / 1000);
    return track_pos * (arg1 / 60);
}

if (_visible)
{
}
_visible = false;
drawn_this_frame = false;
invis_time++;
if (visible_before && invis_time == 2)
{
    if (audio_is_playing(snd_crowd_loop))
    {
        audio_sound_gain(snd_crowd_loop, 1, 0);
    }
    else
    {
        play_crowd_ambience();
    }
    audio_stop_sound(sound);
    sfx_play(cs_0_1_snd_attention);
    stop();
}

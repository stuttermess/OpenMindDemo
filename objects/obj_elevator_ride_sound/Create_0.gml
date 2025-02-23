sound = sfx_play(snd_elevator_ride_loop, true, 0);
audio_sound_loop_start(sound, 5.212);
audio_sound_gain(sound, 1, 1000);

stop = function(arg0)
{
    if (t > 0)
    {
        t = 1;
    }
    else
    {
        audio_sound_gain(sound, 0, (arg0 / 60) * 1000);
        audio_sound_end_on_fade(sound);
        t = arg0;
    }
};

t = -1;

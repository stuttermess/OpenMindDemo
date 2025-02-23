type = 0;
soundid = -1;
sound = -1;
in_time = 0;
out_time = 0;
loop = false;
ending = false;

play = function()
{
    var _gain = undefined;
    if (in_time > 0)
    {
        _gain = 0;
    }
    sound = sfx_play(soundid, loop, _gain, undefined, undefined, type == 1);
    if (in_time > 0)
    {
        audio_sound_gain(sound, 1, in_time);
    }
};

stop = function()
{
    if (out_time == 0)
    {
        _end();
    }
    else
    {
        ending = true;
        audio_sound_gain(sound, 0, out_time);
        audio_sound_end_on_fade(sound);
    }
};

_end = function()
{
    audio_stop_sound(sound);
    instance_destroy();
};

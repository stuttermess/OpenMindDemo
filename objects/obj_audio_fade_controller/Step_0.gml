for (var i = 0; i < array_length(sounds); i++)
{
    if (audio_sound_get_gain(sounds[i]) == 0)
    {
        audio_stop_sound(sounds[i]);
        array_delete(sounds, i, 1);
        i--;
    }
}
if (array_length(sounds) == 0)
{
    instance_destroy();
}

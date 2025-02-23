if (!audio_is_playing(sound))
{
    instance_destroy();
}
if (t > 0)
{
    t--;
    if (t <= 0)
    {
        instance_destroy();
    }
}

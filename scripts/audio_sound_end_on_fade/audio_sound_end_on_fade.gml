function audio_sound_end_on_fade(arg0)
{
    if (!instance_exists(obj_audio_fade_controller))
    {
        instance_create_depth(0, 0, 0, obj_audio_fade_controller);
    }
    with (obj_audio_fade_controller)
    {
        sounds[array_length(sounds)] = arg0;
    }
}

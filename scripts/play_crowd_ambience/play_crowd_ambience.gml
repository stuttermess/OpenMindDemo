function play_crowd_ambience()
{
    if (!instance_exists(obj_crowd_ambience_sound))
    {
        instance_create_depth(0, 0, 0, obj_crowd_ambience_sound);
    }
}

function stop_crowd_ambience()
{
    if (instance_exists(obj_crowd_ambience_sound))
    {
        obj_crowd_ambience_sound.stop(60);
    }
}

function play_elevator_ambience()
{
    if (!instance_exists(obj_elevator_ambience_sound))
    {
        instance_create_depth(0, 0, 0, obj_elevator_ambience_sound);
    }
}

function stop_elevator_ambience()
{
    if (instance_exists(obj_elevator_ambience_sound))
    {
        obj_elevator_ambience_sound.stop(60);
    }
}

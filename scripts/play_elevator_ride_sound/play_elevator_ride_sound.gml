function play_elevator_ride_sound()
{
    if (!instance_exists(obj_elevator_ride_sound))
    {
        instance_create_depth(0, 0, 0, obj_elevator_ride_sound);
    }
}

function stop_elevator_ride_sound()
{
    if (instance_exists(obj_elevator_ride_sound))
    {
        obj_elevator_ride_sound.stop(60);
    }
}

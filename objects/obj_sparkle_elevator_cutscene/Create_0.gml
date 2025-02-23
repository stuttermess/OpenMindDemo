stop_mus_cs0_3_afterlobby();
anim_time = 0;
gamecountdown = 0;
doors_open = 0;
doors_y = 300;
drawcursor = false;
elevator_inst = -1;
repeat (2)
{
    stop_crowd_ambience();
}
repeat (2)
{
    stop_elevator_ambience();
}
repeat (2)
{
    stop_elevator_ride_sound();
}
audio_stop_all();

if (do_zoomin)
{
    zoomin_time += (1 / zoomin_length);
    if (zoomin_time >= 1)
    {
        zoomin_time = 1;
        do_zoomin = false;
    }
    yfrom = zoom_ystart + ((-zoom_ystart + zoom_yend) * easeInBack(zoomin_time));
}
animtimer += 1;
if (smf_instance_get_timer(doorOpen) >= 0.99)
{
    smf_instance_set_animation_speed(doorOpen, 0);
}

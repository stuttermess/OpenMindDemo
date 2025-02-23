anim_time++;
if (anim_time == 1)
{
    elevator_inst = instance_create_depth(0, 0, depth + 1, obj_sparkle_elevator);
}

var easeOutBack = function(arg0)
{
    var c1 = 1.70158;
    var c3 = c1 + 1;
    return 1 + (c3 * power(arg0 - 1, 3)) + (c1 * power(arg0 - 1, 2));
};

var easeInOutQuad = function(arg0)
{
    return (arg0 < 0.5) ? (2 * arg0 * arg0) : (1 - (power((-2 * arg0) + 2, 2) / 2));
};

var slideup_start = 90;
var slideup_end = slideup_start + 100;
if (anim_time == (slideup_start - 10))
{
    sfx_play(snd_elevator_rideup);
}
if (anim_time >= slideup_start && anim_time < slideup_end)
{
    var prog = (anim_time - slideup_start) / (slideup_end - slideup_start);
    doors_y = 300 - (300 * easeOutBack(prog));
}
var open_start = slideup_end + 70;
var open_end = open_start + 90;
if (anim_time == open_start)
{
    sfx_play(snd_elevator_open);
    ambience_sound = -1;
}
if (anim_time == (open_start + 5))
{
    ambience_sound = sfx_play(snd_sparkle_elevator_ambience, false, 0);
    audio_sound_gain(ambience_sound, 1, 2000);
}
if (anim_time == (open_end - 20))
{
}
if (anim_time >= open_start && anim_time < open_end)
{
    var prog = clamp((anim_time - open_start) / (open_end - open_start), 0, 1);
    doors_open = easeInOutQuad(prog);
}
if (anim_time == (open_end + 30))
{
    elevator_inst.ani_door_open();
}
if (anim_time == (open_end + 60 + 60 + 90))
{
    elevator_inst.ani_zoom_in();
    audio_sound_gain(ambience_sound, 0, 1500);
    audio_sound_end_on_fade(ambience_sound);
    sfx_play(snd_elevator_wooshin);
}
if (gamecountdown == 0)
{
    if (elevator_inst.zoomin_time >= 1)
    {
        instance_destroy(elevator_inst);
        gamecountdown++;
    }
}
else if (gamecountdown > 0)
{
    gamecountdown++;
}
if (gamecountdown >= 140)
{
    audio_stop_all();
    controller.next_event();
    instance_destroy();
    video_close();
}

if (anim_time < 210)
{
    draw_clear(c_black);
}
draw_sprite(spr_elevator_inside_doors, 0, 240 - (250 * doors_open), 135 + doors_y);
draw_sprite(spr_elevator_inside_doors, 1, 240 + (250 * doors_open), 135 + doors_y);

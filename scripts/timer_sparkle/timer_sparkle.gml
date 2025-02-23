function timer_sparkle(arg0, arg1, arg2, arg3, arg4)
{
    var imgnum = sprite_get_number(spr_timer_sparkle);
    var xoff = 0;
    var yoff = arg3;
    draw_sprite(spr_timer_sparkle, clamp((clamp(1 - arg4, 0, 1) * imgnum) - 1, 0, imgnum - 1), arg0 + xoff, arg1 + yoff);
}

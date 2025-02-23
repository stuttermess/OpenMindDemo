function timer_tutorial(arg0, arg1, arg2, arg3, arg4)
{
    var imgnum = 8;
    var xoff = 0;
    var yoff = arg3;
    draw_sprite(spr_timer_tutorial, clamp((clamp(1 - arg4, 0, 1) * imgnum) - 1, 0, imgnum - 1), arg0 + xoff, arg1 + yoff);
    var start_x = 80;
    var total_space = 455 - start_x;
    var spacing = total_space / 6;
    for (var i = 0; i < ((arg4 * imgnum) + 0.5); i++)
    {
        var _xx = arg0 + start_x + (spacing * i);
        var _yy = (arg1 + arg3) - 17.5;
        var _aa = 45 + (((arg4 * imgnum) - i) * 25);
        var _ss = 1;
        var out_time = 0.4;
        var _prog = 0;
        if (((arg4 * imgnum) - i) < out_time)
        {
            var _start = out_time;
            var _end = 0;
            _prog = clamp(((-1 * ((arg4 * imgnum) - i - _start)) / out_time) - 0, 0, 1);
            _ss = lerp(1, 0, lerp_easeInBack(_prog));
        }
        draw_sprite_ext(spr_timer_tutorial_square, 0, _xx, _yy, _ss, _ss, _aa, c_white, 1);
    }
}

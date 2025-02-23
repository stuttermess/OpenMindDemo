function draw_text_outline(arg0, arg1, arg2, arg3 = 0, arg4 = false, arg5 = 1, arg6 = 1, arg7 = 1, arg8 = 0, arg9 = 0)
{
    if (arg9 != 0)
    {
        var anchorchar = 1;
        switch (draw_get_halign())
        {
            case 1:
                anchorchar = string_length(arg2) / 2;
                if ((string_length(arg2) % 2) == 1)
                {
                    anchorchar -= 1;
                }
                arg0 -= ((string_width(arg2) / 2) * arg6);
                break;
            case 2:
                anchorchar = string_length(arg2);
                arg0 -= ((string_width(arg2) / 1) * arg6);
                break;
        }
        var _xx = arg0;
        var _yy = arg1;
        var _hal = draw_get_halign();
        draw_set_halign(fa_left);
        for (var i = 0; i < string_length(arg2); i++)
        {
            var _char = string_char_at(arg2, i + 1);
            _yy = arg1 + (arg9 * (i - anchorchar));
            draw_text_outline(_xx, _yy, _char, arg3, arg4, arg5, arg6, arg7, arg8, 0);
            _xx += (floor(arg6 / 2) + (string_width(_char) * arg6));
        }
        draw_set_halign(_hal);
        exit;
    }
    var col = draw_get_color();
    draw_set_color(arg3);
    if (arg4)
    {
        var fidelity = 8;
        for (var i = 0; i < fidelity; i++)
        {
            var dir = (i / fidelity) * 360;
            var len = arg5;
            var drawx = arg0 + ceil(lengthdir_x(len, dir));
            var drawy = arg1 + ceil(lengthdir_y(len, dir));
            draw_text_transformed(drawx, drawy, arg2, arg6, arg7, arg8);
        }
    }
    else
    {
        var xs = [1, 1, 0, -1, -1, -1, 0, 1];
        var ys = [0, -1, -1, -1, 0, 1, 1, 1];
        for (var i = 0; i < 8; i++)
        {
            draw_text_transformed(arg0 + (arg5 * xs[i]), arg1 + (arg5 * ys[i]), arg2, arg6, arg7, arg8);
        }
    }
    draw_set_color(col);
    draw_text_transformed(arg0, arg1, arg2, arg6, arg7, arg8);
}

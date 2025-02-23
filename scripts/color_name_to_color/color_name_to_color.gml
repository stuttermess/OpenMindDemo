function color_name_to_color(arg0)
{
    var _color = -1;
    switch (arg0)
    {
        case "white":
            _color = 16777215;
            break;
        case "black":
            _color = 0;
            break;
        case "gray":
        case "grey":
            _color = 12632256;
            break;
        case "red":
            _color = 255;
            break;
        case "blue":
            _color = 16711680;
            break;
        case "yellow":
            _color = 65535;
            break;
        case "green":
            _color = 32768;
            break;
        case "aqua":
            _color = 16776960;
            break;
        case "lime":
            _color = 65280;
            break;
        case "purple":
            _color = 8388736;
            break;
        case "fuchsia":
            _color = 16711935;
            break;
        case "pandora":
            _color = 15902165;
            break;
        case "smalls":
            _color = 15645599;
            break;
        default:
            _color = hex_string_to_color(arg0);
            break;
    }
    return _color;
}

function hex_string_to_color(arg0)
{
    var hex = "0123456789ABCDEF";
    var color_str = string_trim(arg0, ["#", " "]);
    var color = 0;
    for (var i = 0; i < 6; i++)
    {
        var n = irandom(15);
        color_str += string_copy(hex, n + 1, 1);
        color = (color << 4) + n;
    }
    var red = color >> 16;
    var green = (color >> 8) & 255;
    var blue = color & 255;
    var gms_color = make_color_rgb(red, green, blue);
    return gms_color;
}

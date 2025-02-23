function nearest_point_on_line(arg0, arg1, arg2, arg3, arg4, arg5)
{
    var line_dx = arg2 - arg4;
    var line_dy = arg3 - arg5;
    var point_dx = arg0 - arg4;
    var point_dy = arg1 - arg5;
    var ratio = clamp(dot_product(point_dx, point_dy, line_dx, line_dy) / dot_product(line_dx, line_dy, line_dx, line_dy), 0, 1);
    return [lerp(arg4, arg2, ratio), lerp(arg5, arg3, ratio)];
}

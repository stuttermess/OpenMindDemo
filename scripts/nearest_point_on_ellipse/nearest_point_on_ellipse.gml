function nearest_point_on_ellipse(arg0, arg1, arg2, arg3, arg4, arg5)
{
    var ex = mean(arg2, arg4);
    var ey = mean(arg3, arg5);
    var exr = (arg4 - arg2) / 2;
    var ehr = (arg5 - arg3) / 2;
    var dir_to_point = point_direction(ex, ey, arg0, arg1);
    var point_x = dcos(dir_to_point);
    point_x *= exr;
    point_x += ex;
    var point_y = dsin(-dir_to_point);
    point_y *= ehr;
    point_y += ey;
    return [point_x, point_y];
}

function distance_from_line(arg0, arg1, arg2, arg3, arg4, arg5)
{
    var _nearest = nearest_point_on_line(arg0, arg1, arg2, arg3, arg4, arg5);
    return point_distance(arg0, arg1, _nearest[0], _nearest[1]);
}

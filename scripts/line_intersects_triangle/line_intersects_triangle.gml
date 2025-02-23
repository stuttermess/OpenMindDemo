function line_intersects_triangle(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
{
    var _intersections = [];
    var _point_in = point_in_triangle(arg0, arg1, arg4, arg5, arg6, arg7, arg8, arg9) || point_in_triangle(arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
    if (_point_in)
    {
        return _intersections;
    }
    else
    {
        var _side = [[arg4, arg5, arg6, arg7], [arg6, arg7, arg8, arg9], [arg8, arg9, arg4, arg5]];
        for (var i = 0; i < 3; i++)
        {
            var side_intersections = lines_intersection_point(arg0, arg1, arg2, arg3, _side[i][0], _side[i][1], _side[i][2], _side[i][3], true);
            if (is_array(side_intersections))
            {
                array_copy(_intersections, array_length(_intersections), side_intersections, 0, array_length(side_intersections));
            }
        }
        if (array_length(_intersections) == 0)
        {
            return _intersections;
        }
        else
        {
            return false;
        }
    }
}

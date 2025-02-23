function line_intersects_quad(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11)
{
    var quad_lines = [[arg4, arg5, arg6, arg7], [arg6, arg7, arg8, arg9], [arg8, arg9, arg10, arg11], [arg10, arg11, arg4, arg5]];
    var l1 = [arg0, arg1, arg2, arg3];
    var intersections = [];
    for (var i = 0; i < 4; i++)
    {
        var l2 = quad_lines[i];
        var this_intersection = lines_intersection_point(l1[0], l1[1], l1[2], l1[3], l2[0], l2[1], l2[2], l2[3]);
        if (is_array(this_intersection))
        {
            array_push(intersections, this_intersection);
        }
    }
    if (array_length(intersections) == 0)
    {
        return false;
    }
    else
    {
        return intersections;
    }
}

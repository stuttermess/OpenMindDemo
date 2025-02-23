function triangle_intersects_triangle(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11)
{
    var _lines = [[arg0, arg1, arg2, arg3], [arg2, arg3, arg4, arg5], [arg4, arg5, arg0, arg1]];
    var _intersections = [];
    var _success = false;
    for (var i = 0; i < 3; i++)
    {
        var _l = _lines[i];
        var lx1 = _l[0];
        var ly1 = _l[1];
        var lx2 = _l[2];
        var ly2 = _l[3];
        var _intersection = line_intersects_triangle(lx1, ly1, lx2, ly2, arg6, arg7, arg8, arg9, arg10, arg11);
        if (is_array(_intersection))
        {
            array_copy(_intersections, array_length(_intersections), _intersection, 0, array_length(_intersection));
            _success = true;
        }
    }
    if (_success)
    {
        return _intersections;
    }
    else
    {
        return false;
    }
}

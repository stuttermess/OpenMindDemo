function nearest_point_on_quad(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
{
    var lines = [[arg2, arg3, arg4, arg5], [arg4, arg5, arg6, arg7], [arg6, arg7, arg8, arg9], [arg8, arg9, arg2, arg3]];
    var _nearest_point = [infinity, infinity];
    for (var i = 0; i < array_length(lines); i++)
    {
        var _line = lines[i];
        var _nearest = nearest_point_on_line(arg0, arg1, _line[0], _line[1], _line[2], _line[3]);
        var _dist = point_distance(arg0, arg1, _nearest[0], _nearest[1]);
        if (_dist < point_distance(arg0, arg1, _nearest_point[0], _nearest_point[1]))
        {
            _nearest_point = _nearest;
        }
    }
    if (_nearest_point[0] == infinity && _nearest_point[1] == infinity)
    {
        _nearest_point = undefined;
    }
    return _nearest_point;
}

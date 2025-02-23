function lines_intersect(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
{
    var ua = 0;
    var ux = arg2 - arg0;
    var uy = arg3 - arg1;
    var vx = arg6 - arg4;
    var vy = arg7 - arg5;
    var wx = arg0 - arg4;
    var wy = arg1 - arg5;
    var ud = (vy * ux) - (vx * uy);
    if (ud != 0)
    {
        ua = ((vx * wy) - (vy * wx)) / ud;
        if (arg8)
        {
            var ub = ((ux * wy) - (uy * wx)) / ud;
            if (ua < 0 || ua > 1 || ub < 0 || ub > 1)
            {
                ua = 0;
            }
        }
    }
    return ua;
}

function lines_intersection_point(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8 = true)
{
    var intersection = lines_intersect(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
    if (intersection <= 0 || intersection > 1)
    {
        return false;
    }
    else
    {
        var t = intersection;
        var _x = arg0 + (t * (arg2 - arg0));
        var _y = arg1 + (t * (arg3 - arg1));
        return [_x, _y];
    }
}

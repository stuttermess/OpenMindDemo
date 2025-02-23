function line_intersects_circle(arg0, arg1, arg2, arg3, arg4, arg5, arg6)
{
    var dx = arg5 - arg3;
    var dy = arg6 - arg4;
    var fx = arg3 - arg0;
    var fy = arg4 - arg1;
    var a = (dx * dx) + (dy * dy);
    var b = 2 * ((fx * dx) + (fy * dy));
    var c = ((fx * fx) + (fy * fy)) - (arg2 * arg2);
    var discriminant = (b * b) - (4 * a * c);
    if (discriminant < 0)
    {
        return false;
    }
    discriminant = sqrt(discriminant);
    var t1 = (-b - discriminant) / (2 * a);
    var t2 = (-b + discriminant) / (2 * a);
    return (t1 >= 0 && t1 <= 1) || (t2 >= 0 && t2 <= 1);
}

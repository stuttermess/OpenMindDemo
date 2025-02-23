function point_in_ellipse(arg0, arg1, arg2, arg3, arg4, arg5)
{
    var ex = mean(arg2, arg4);
    var ey = mean(arg3, arg5);
    var exr = (arg4 - arg2) / 2;
    var ehr = (arg5 - arg3) / 2;
    return ((power(arg0 - ex, 2) / power(exr, 2)) + (power(arg1 - ey, 2) / power(ehr, 2))) <= 1;
}

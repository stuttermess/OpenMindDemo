function point_in_quad(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
{
    return point_in_triangle(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7) || point_in_triangle(arg0, arg1, arg6, arg7, arg8, arg9, arg2, arg3);
}

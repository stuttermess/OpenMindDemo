function shader_set_uniform_rgba(arg0, arg1, arg2)
{
    var array = [color_get_red(arg1) / 255, color_get_green(arg1) / 255, color_get_blue(arg1) / 255, arg2];
    return shader_set_uniform_f_array(arg0, array);
}

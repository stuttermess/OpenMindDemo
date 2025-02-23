function shader_set_grayscale(arg0 = 0)
{
    shader_set(sh_grayscale);
    var s = shader_get_uniform(sh_grayscale, "u_saturation");
    shader_set_uniform_f(s, arg0);
}

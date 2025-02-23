function draw_transition_perlin(arg0, arg1 = 13, arg2 = 5, arg3 = 0.5, arg4 = 0)
{
    var shd = sh_transition_perlin;
    shader_set(shd);
    shader_set_uniform_f(shader_get_uniform(shd, "scale"), arg2);
    shader_set_uniform_f(shader_get_uniform(shd, "seed"), arg1);
    shader_set_uniform_f(shader_get_uniform(shd, "time"), arg0);
    shader_set_uniform_f(shader_get_uniform(shd, "resolution"), arg3);
    var _r = color_get_red(arg4);
    var _g = color_get_green(arg4);
    var _b = color_get_blue(arg4);
    shader_set_uniform_f_array(shader_get_uniform(shd, "color"), [_r, _g, _b]);
    draw_sprite(spr_blankscreen, 0, 0, 0);
    shader_reset();
}

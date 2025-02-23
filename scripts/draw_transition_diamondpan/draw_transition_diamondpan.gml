function draw_transition_diamondpan(arg0, arg1 = 1)
{
    var sf = application_surface;
    var tex = surface_get_texture(sf);
    var smoothness = 0;
    var shd = sh_transition_diamondpan;
    shader_set(shd);
    shader_set_uniform_f(shader_get_uniform(shd, "progress"), arg0);
    draw_surface(sf, 0, 0);
    shader_reset();
    draw_text_outline(5, 5, arg0);
}

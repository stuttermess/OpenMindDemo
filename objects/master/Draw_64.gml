if (ditherOn)
{
    var _tex = surface_get_texture(application_surface);
    shader_set_1bit_dither(_tex, dither_light, dither_dark, undefined, spr_dither_progression_compact);
    draw_surface(application_surface, 0, 0);
    shader_reset();
}

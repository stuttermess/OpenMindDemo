function shader_set_pixelate(arg0, arg1, arg2)
{
    return shader_set_pixelate_tex(arg0, sprite_get_texture(arg1, arg2), sprite_get_uvs(arg1, arg2));
}

function shader_set_pixelate_tex(arg0, arg1, arg2)
{
    var PixelsCount = shader_get_uniform(sh_pixelate, "PixelsCount");
    var texture_uni = shader_get_uniform(sh_pixelate, "Texture");
    shader_set(sh_pixelate);
    shader_set_uniform_f(texture_uni, arg2[0], arg2[1], arg2[2], arg2[3]);
    shader_set_uniform_f(PixelsCount, arg0);
}

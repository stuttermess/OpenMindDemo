function shader_set_compression_texture(arg0, arg1, arg2 = 1, arg3 = 1, arg4 = 1, arg5 = 1, arg6 = 1, arg7 = 1, arg8 = 1, arg9 = 1)
{
    var u_time = shader_get_uniform(sh_compression, "Time");
    var u_texel = shader_get_uniform(sh_compression, "Texel");
    var u_coords = shader_get_uniform(sh_compression, "TexPos");
    var u_xsp = shader_get_uniform(sh_compression, "Xspeed");
    var u_xfr = shader_get_uniform(sh_compression, "Xfreq");
    var u_xsi = shader_get_uniform(sh_compression, "Xsize");
    var u_ysp = shader_get_uniform(sh_compression, "Yspeed");
    var u_yfr = shader_get_uniform(sh_compression, "Yfreq");
    var u_ysi = shader_get_uniform(sh_compression, "Ysize");
    var u_xo = shader_get_uniform(sh_compression, "Xoffset");
    var u_yo = shader_get_uniform(sh_compression, "Yoffset");
    shader_set(sh_compression);
    shader_set_uniform_f(u_time, arg1);
    var tex = arg0;
    shader_set_uniform_f(u_texel, texture_get_texel_width(tex), texture_get_texel_height(tex));
    var uvs = texture_get_uvs(tex);
    shader_set_uniform_f(u_coords, uvs[0], uvs[1], uvs[2], uvs[3]);
    shader_set_uniform_f(u_xsp, arg3);
    shader_set_uniform_f(u_xfr, arg4);
    shader_set_uniform_f(u_xsi, arg5);
    shader_set_uniform_f(u_ysp, arg7);
    shader_set_uniform_f(u_yfr, arg8);
    shader_set_uniform_f(u_ysi, arg9);
    shader_set_uniform_f(u_xo, arg9);
}

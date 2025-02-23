function shader_set_wavy(arg0, arg1, arg2 = 1, arg3 = 1, arg4 = 1, arg5 = 1, arg6 = 1, arg7 = 1)
{
    var u_time = shader_get_uniform(sh_wavy, "Time");
    var u_texel = shader_get_uniform(sh_wavy, "Texel");
    var u_coords = shader_get_uniform(sh_wavy, "TexPos");
    var u_xsp = shader_get_uniform(sh_wavy, "Xspeed");
    var u_xfr = shader_get_uniform(sh_wavy, "Xfreq");
    var u_xsi = shader_get_uniform(sh_wavy, "Xsize");
    var u_ysp = shader_get_uniform(sh_wavy, "Yspeed");
    var u_yfr = shader_get_uniform(sh_wavy, "Yfreq");
    var u_ysi = shader_get_uniform(sh_wavy, "Ysize");
    shader_set(sh_wavy);
    shader_set_uniform_f(u_time, arg1);
    var tex = sprite_get_texture(arg0, 0);
    shader_set_uniform_f(u_texel, texture_get_texel_width(tex), texture_get_texel_height(tex));
    var uvs = texture_get_uvs(tex);
    shader_set_uniform_f(u_coords, uvs[0], uvs[1], uvs[2], uvs[3]);
    shader_set_uniform_f(u_xsp, arg2);
    shader_set_uniform_f(u_xfr, arg3);
    shader_set_uniform_f(u_xsi, arg4);
    shader_set_uniform_f(u_ysp, arg5);
    shader_set_uniform_f(u_yfr, arg6);
    shader_set_uniform_f(u_ysi, arg7);
}

function shader_set_wavy_spriteframe(arg0, arg1, arg2, arg3 = 1, arg4 = 1, arg5 = 1, arg6 = 1, arg7 = 1, arg8 = 1)
{
    var u_time = shader_get_uniform(sh_wavy, "Time");
    var u_texel = shader_get_uniform(sh_wavy, "Texel");
    var u_coords = shader_get_uniform(sh_wavy, "TexPos");
    var u_xsp = shader_get_uniform(sh_wavy, "Xspeed");
    var u_xfr = shader_get_uniform(sh_wavy, "Xfreq");
    var u_xsi = shader_get_uniform(sh_wavy, "Xsize");
    var u_ysp = shader_get_uniform(sh_wavy, "Yspeed");
    var u_yfr = shader_get_uniform(sh_wavy, "Yfreq");
    var u_ysi = shader_get_uniform(sh_wavy, "Ysize");
    shader_set(sh_wavy);
    shader_set_uniform_f(u_time, arg2);
    var tex = sprite_get_texture(arg0, arg1);
    shader_set_uniform_f(u_texel, texture_get_texel_width(tex), texture_get_texel_height(tex));
    var uvs = texture_get_uvs(tex);
    shader_set_uniform_f(u_coords, uvs[0], uvs[1], uvs[2], uvs[3]);
    shader_set_uniform_f(u_xsp, arg3);
    shader_set_uniform_f(u_xfr, arg4);
    shader_set_uniform_f(u_xsi, arg5);
    shader_set_uniform_f(u_ysp, arg6);
    shader_set_uniform_f(u_yfr, arg7);
    shader_set_uniform_f(u_ysi, arg8);
}

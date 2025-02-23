function draw_surface_ditherfaded(arg0, arg1, arg2, arg3, arg4 = 1, arg5 = 1, arg6 = 0, arg7 = 16777215, arg8 = 1, arg9 = undefined)
{
    var _texture = surface_get_texture(arg0);
    var _uvs = [0, 0, 1, 1, 0, 0, 1, 1];
    shader_set_ditherfade(arg3, _texture, _uvs, arg9);
    draw_surface_ext(arg0, arg1, arg2, arg4, arg5, arg6, arg7, arg8);
    shader_reset();
}

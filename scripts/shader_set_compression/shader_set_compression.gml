function shader_set_compression(arg0, arg1, arg2 = 1, arg3 = 1, arg4 = 1, arg5 = 1, arg6 = 1, arg7 = 1, arg8 = 1, arg9 = 1)
{
    var _tex = sprite_get_texture(arg0, 0);
    return shader_set_compression_texture(_tex, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
}

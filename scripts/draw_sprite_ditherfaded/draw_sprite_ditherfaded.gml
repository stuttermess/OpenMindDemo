function draw_sprite_ditherfaded(arg0, arg1, arg2, arg3, arg4, arg5 = 1, arg6 = 1, arg7 = 0, arg8 = 16777215, arg9 = 1, arg10 = undefined)
{
    var _sprite_texture = sprite_get_texture(arg0, arg1);
    var _sprite_uvs = sprite_get_uvs(arg0, arg1);
    shader_set_ditherfade(arg4, _sprite_texture, _sprite_uvs, arg10, undefined, undefined, undefined, 1 / arg5, 1 / arg6);
    draw_sprite_ext(arg0, arg1, arg2, arg3, arg5, arg6, arg7, arg8, arg9);
    shader_reset();
}

function draw_sprite_tiled_ditherfaded(arg0, arg1, arg2, arg3, arg4, arg5 = 1, arg6 = 1, arg7 = 16777215, arg8 = 1, arg9 = undefined)
{
    var _sprite_texture = sprite_get_texture(arg0, arg1);
    var _sprite_uvs = sprite_get_uvs(arg0, arg1);
    shader_set_ditherfade(arg4, _sprite_texture, _sprite_uvs, arg9, undefined, undefined, undefined, 1 / arg5, 1 / arg6);
    draw_sprite_tiled_ext(arg0, arg1, arg2, arg3, arg5, arg6, arg7, arg8);
    shader_reset();
}

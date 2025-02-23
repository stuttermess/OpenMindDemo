function shader_set_outline_texture(arg0, arg1 = [0, 0, 1, 1], arg2 = 0, arg3 = 1, arg4 = true, arg5 = 1)
{
    var _texel_size = [texture_get_texel_width(arg0), texture_get_texel_height(arg0)];
    shader_set(shd_outline);
    var _u_textureSizePixels = shader_get_uniform(shd_outline, "textureSizePixels");
    var _u_textureUVs = shader_get_uniform(shd_outline, "textureUVs");
    var _u_Color = shader_get_uniform(shd_outline, "Color");
    var _u_Size = shader_get_uniform(shd_outline, "Size");
    var _u_useCorners = shader_get_uniform(shd_outline, "useCorners");
    var _u_alphaThreshold = shader_get_uniform(shd_outline, "alphaThreshold");
    shader_set_uniform_f_array(_u_textureSizePixels, _texel_size);
    shader_set_uniform_f_array(_u_textureUVs, [arg1[0], arg1[1], arg1[2], arg1[3]]);
    shader_set_uniform_rgba(_u_Color, arg2, 1);
    shader_set_uniform_i(_u_Size, arg3);
    shader_set_uniform_i(_u_useCorners, real(arg4));
    shader_set_uniform_f(_u_alphaThreshold, arg5);
}

function shader_set_outline_sprite(arg0, arg1, arg2 = 0, arg3 = 1, arg4 = true, arg5 = 1)
{
    var _sprite_uvs = sprite_get_uvs(arg0, arg1);
    _sprite_uvs = [_sprite_uvs[0], _sprite_uvs[1], _sprite_uvs[2], _sprite_uvs[3]];
    var _sprite_texture = sprite_get_texture(arg0, arg1);
    return shader_set_outline_texture(_sprite_texture, _sprite_uvs, arg2, arg3, arg4, arg5);
}

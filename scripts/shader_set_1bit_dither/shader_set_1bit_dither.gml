function shader_set_1bit_dither(arg0 = 1, arg1 = 16777215, arg2 = 0, arg3 = [0, 0, 1, 1], arg4 = spr_dither_progression, arg5 = false, arg6 = 0, arg7 = 0, arg8 = 1)
{
    var _sprite_tex = arg0;
    var _sprite_texture_size = [texture_get_texel_width(_sprite_tex), texture_get_texel_height(_sprite_tex)];
    var _sprite_uvs = arg3;
    var _dither_sprite = arg4;
    var _dither_texture = sprite_get_texture(_dither_sprite, 0);
    var _dither_texture_size = [texture_get_texel_width(_dither_texture), texture_get_texel_height(_dither_texture)];
    var _dither_sprite_width = sprite_get_width(_dither_sprite);
    var _dither_sprite_height = sprite_get_height(_dither_sprite);
    var _dither_sprite_uvs = sprite_get_uvs(_dither_sprite, 0);
    var _dither_stages = floor(_dither_sprite_width / _dither_sprite_height);
    var _dither_offset = [arg6, arg7];
    shader_set(shd_1bit_dither);
    var _u_textureSizePixels = shader_get_uniform(shd_1bit_dither, "textureSizePixels");
    var _u_ditherTextureSizePixels = shader_get_uniform(shd_1bit_dither, "ditherTextureSizePixels");
    var _u_textureUVs = shader_get_uniform(shd_1bit_dither, "textureUVs");
    var _u_ditherTexture = shader_get_sampler_index(shd_1bit_dither, "ditherTexture");
    var _u_ditherUVs = shader_get_uniform(shd_1bit_dither, "ditherUVs");
    var _u_ditherStages = shader_get_uniform(shd_1bit_dither, "ditherStages");
    var _u_cellSize = shader_get_uniform(shd_1bit_dither, "cellSize");
    var _u_ditherOffset = shader_get_uniform(shd_1bit_dither, "ditherOffset");
    var _u_invert = shader_get_uniform(shd_1bit_dither, "invert");
    var _u_scale = shader_get_uniform(shd_1bit_dither, "scale");
    var _u_lightColor = shader_get_uniform(shd_1bit_dither, "lightColor");
    var _u_darkColor = shader_get_uniform(shd_1bit_dither, "darkColor");
    shader_set_uniform_f_array(_u_textureSizePixels, _sprite_texture_size);
    shader_set_uniform_f_array(_u_ditherTextureSizePixels, _dither_texture_size);
    shader_set_uniform_f_array(_u_textureUVs, [_sprite_uvs[0], _sprite_uvs[1], _sprite_uvs[2], _sprite_uvs[3]]);
    texture_set_stage(_u_ditherTexture, _dither_texture);
    shader_set_uniform_f_array(_u_ditherUVs, [_dither_sprite_uvs[0], _dither_sprite_uvs[1], _dither_sprite_uvs[2], _dither_sprite_uvs[3]]);
    shader_set_uniform_i(_u_ditherStages, _dither_stages);
    shader_set_uniform_i(_u_cellSize, _dither_sprite_height);
    shader_set_uniform_f_array(_u_ditherOffset, _dither_offset);
    shader_set_uniform_i(_u_invert, arg5);
    shader_set_uniform_f(_u_scale, arg8);
    shader_set_uniform_rgba(_u_lightColor, arg1, 1);
    shader_set_uniform_rgba(_u_darkColor, arg2, 1);
}

function shader_set_ditherfade(arg0, arg1 = 1, arg2 = [0, 0, 1, 1], arg3 = spr_dither_progression, arg4 = false, arg5 = 0, arg6 = 0, arg7 = 1, arg8 = 1)
{
    var _sprite_tex = arg1;
    var _sprite_texture_size = [texture_get_texel_width(_sprite_tex), texture_get_texel_height(_sprite_tex)];
    var _sprite_uvs = arg2;
    var _dither_sprite = arg3;
    var _dither_texture = sprite_get_texture(_dither_sprite, 0);
    var _dither_texture_size = [texture_get_texel_width(_dither_texture), texture_get_texel_height(_dither_texture)];
    var _dither_sprite_width = sprite_get_width(_dither_sprite);
    var _dither_sprite_height = sprite_get_height(_dither_sprite);
    var _dither_sprite_uvs = sprite_get_uvs(_dither_sprite, 0);
    var _dither_stages = floor(_dither_sprite_width / _dither_sprite_height);
    var _dither_stage = clamp(floor(_dither_stages * arg0), 0, _dither_stages - 1);
    var _dither_offset = [arg5, arg6];
    shader_set(shd_texture_dither_faded);
    var _u_textureSizePixels = shader_get_uniform(shd_texture_dither_faded, "textureSizePixels");
    var _u_ditherTextureSizePixels = shader_get_uniform(shd_texture_dither_faded, "ditherTextureSizePixels");
    var _u_textureUVs = shader_get_uniform(shd_texture_dither_faded, "textureUVs");
    var _u_ditherTexture = shader_get_sampler_index(shd_texture_dither_faded, "ditherTexture");
    var _u_ditherUVs = shader_get_uniform(shd_texture_dither_faded, "ditherUVs");
    var _u_ditherStages = shader_get_uniform(shd_texture_dither_faded, "ditherStages");
    var _u_cellSize = shader_get_uniform(shd_texture_dither_faded, "cellSize");
    var _u_stage = shader_get_uniform(shd_texture_dither_faded, "stage");
    var _u_ditherOffset = shader_get_uniform(shd_texture_dither_faded, "ditherOffset");
    var _u_invert = shader_get_uniform(shd_texture_dither_faded, "invert");
    var _u_scale = shader_get_uniform(shd_texture_dither_faded, "scale");
    shader_set_uniform_f_array(_u_textureSizePixels, _sprite_texture_size);
    shader_set_uniform_f_array(_u_ditherTextureSizePixels, _dither_texture_size);
    shader_set_uniform_f_array(_u_textureUVs, [_sprite_uvs[0], _sprite_uvs[1], _sprite_uvs[2], _sprite_uvs[3]]);
    texture_set_stage(_u_ditherTexture, _dither_texture);
    shader_set_uniform_f_array(_u_ditherUVs, [_dither_sprite_uvs[0], _dither_sprite_uvs[1], _dither_sprite_uvs[2], _dither_sprite_uvs[3]]);
    shader_set_uniform_i(_u_ditherStages, _dither_stages);
    shader_set_uniform_i(_u_cellSize, _dither_sprite_height);
    shader_set_uniform_i(_u_stage, _dither_stage);
    shader_set_uniform_f_array(_u_ditherOffset, _dither_offset);
    shader_set_uniform_i(_u_invert, arg4);
    shader_set_uniform_f_array(_u_scale, [arg7, arg8]);
}

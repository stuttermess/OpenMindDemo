function draw_mainmenu_bg(arg0, arg1 = {})
{
    var screenw = 480;
    var screenh = 270;
    if (!variable_global_exists("mmbg_mask_surf"))
    {
        global.mmbg_mask_surf = -1;
        global.mmbg_surf = -1;
        global.mmbg_surf2 = -1;
        global.mmbg_surf_stuff = -1;
        global.mmbg_surf_stuff2 = -1;
        global.mmbg_surf_stuff3 = -1;
        global.mmbg_surf_stuff4 = -1;
    }
    var cam_x = 0;
    var cam_y = 0;
    var moddable = 
    {
        overlay_col: 11929488,
        things_sprite: spr_mmbg_8stuff,
        things_image_index: 0,
        blend_things_sprite: spr_mmbg_8stuff,
        blend_things_image_index: 1,
        things_blend_amount: 1,
        x: 0,
        y: 0
    };
    var mods_arr = struct_get_names(arg1);
    for (var i = 0; i < array_length(mods_arr); i++)
    {
        var _name = mods_arr[i];
        if (struct_exists(moddable, _name))
        {
            struct_set(moddable, _name, struct_get(arg1, _name));
        }
    }
    var _xoff = moddable.x;
    var _yoff = moddable.y;
    draw_sprite(spr_mmbg_1, 0, screenw / 2, screenh / 2);
    blendmode_set_hardlight();
    draw_sprite(spr_mmbg_2, 0, screenw / 2, screenh / 2);
    blendmode_reset();
    if (!surface_exists(global.mmbg_mask_surf))
    {
        global.mmbg_mask_surf = surface_create(screenw, screenh);
    }
    if (!surface_exists(global.mmbg_surf))
    {
        global.mmbg_surf = surface_create(screenw, screenh);
    }
    surface_set_target(global.mmbg_mask_surf);
    draw_clear_alpha(c_black, 0);
    shader_set_wavy(spr_mmbg_3, arg0, 0.5, 10, 50);
    draw_sprite(spr_mmbg_3, 0, (screenw / 2) + (_xoff * 0.5), (screenh / 2) + (_yoff * 0.5));
    shader_reset();
    surface_reset_target();
    surface_set_target(global.mmbg_surf);
    draw_clear_alpha(c_black, 0);
    shader_set(sh_mask);
    var umask = shader_get_sampler_index(sh_mask, "u_mask");
    texture_set_stage(umask, surface_get_texture(global.mmbg_mask_surf));
    var urect = shader_get_uniform(sh_mask, "u_rect");
    shader_set_uniform_f(urect, 0, 0, screenw, screenh);
    draw_sprite(spr_mmbg_4MASK, 0, screenw / 2, screenh / 2);
    shader_reset();
    surface_reset_target();
    draw_surface(global.mmbg_surf, 0, 0);
    if (!surface_exists(global.mmbg_surf2))
    {
        global.mmbg_surf2 = surface_create(screenw * 2, screenh * 2);
    }
    surface_set_target(global.mmbg_surf2);
    draw_clear_alpha(c_black, 0);
    draw_sprite_tiled(spr_mmbg_5, 0, (cam_x * 0.02) + (arg0 * 15) + (_xoff * 0.75), (cam_y * 0.02) + (arg0 * 18) + (_yoff * 0.75));
    surface_reset_target();
    blendmode_set_addglow();
    shader_set_wavy(spr_mmbg_5, arg0, 0, 0, 0, 0.5, 10, 50);
    draw_surface(global.mmbg_surf2, -100, -100);
    shader_reset();
    blendmode_reset();
    blendmode_set_multiply();
    var _col = moddable.overlay_col;
    draw_clear(_col);
    blendmode_reset();
    blendmode_set_colorburn();
    draw_sprite(spr_mmbg_6, 0, screenw / 2, screenh / 2);
    blendmode_reset();
    blendmode_set_addglow();
    draw_sprite(spr_mmbg_7, 0, screenw / 2, screenh / 2);
    blendmode_reset();
    var screen_upscale_w = 2;
    var screen_upscale_h = 2;
    var _sf_w = screenw * screen_upscale_w;
    var _sf_h = screenh * screen_upscale_h;
    if (!surface_exists(global.mmbg_surf_stuff))
    {
        global.mmbg_surf_stuff = surface_create(_sf_w, _sf_h);
    }
    if (!surface_exists(global.mmbg_surf_stuff2))
    {
        global.mmbg_surf_stuff2 = surface_create(_sf_w, _sf_h);
    }
    if (!surface_exists(global.mmbg_surf_stuff3))
    {
        global.mmbg_surf_stuff3 = surface_create(_sf_w, _sf_h);
    }
    if (!surface_exists(global.mmbg_surf_stuff4))
    {
        global.mmbg_surf_stuff4 = surface_create(_sf_w, _sf_h);
    }
    var _things_yoff = 60;
    var _things_xoff = 60;
    var things_spr = moddable.things_sprite;
    var things_ind = moddable.things_image_index;
    var _dither_invert = false;
    var _reps = 1 + real(moddable.things_blend_amount > 0 && moddable.things_blend_amount < 1);
    if (moddable.things_blend_amount < 1)
    {
        things_spr = moddable.blend_things_sprite;
        things_ind = moddable.blend_things_image_index;
    }
    else if (moddable.things_blend_amount == 1)
    {
        _reps = 1;
        things_spr = moddable.things_sprite;
        things_ind = moddable.things_image_index;
        _dither_invert = true;
    }
    if (master.debug_vars.disable_mmbg_figments)
    {
        _reps = 0;
    }
    _xoff -= 40;
    var things_cam_x = (_xoff * 25) / 1.7777777777777777;
    var things_cam_y = _yoff * 25;
    repeat (_reps)
    {
        surface_set_target(global.mmbg_surf_stuff);
        draw_clear_alpha(c_black, 0);
        draw_sprite_tiled(things_spr, things_ind, 0 + (-arg0 * 33) + _things_xoff, 0 + (-arg0 * 37) + _things_yoff);
        surface_reset_target();
        surface_set_target(global.mmbg_surf_stuff2);
        draw_clear_alpha(c_black, 0);
        shader_set_wavy(spr_mmbg_1, arg0, 0.65, -8, 450);
        draw_surface(global.mmbg_surf_stuff, -_things_xoff, -_things_yoff);
        shader_reset();
        surface_reset_target();
        surface_set_target(global.mmbg_surf_stuff3);
        draw_clear_alpha(c_black, 0);
        var _texwidth = texture_get_texel_width(sprite_get_texture(spr_mmbg_1, 0));
        var _texheight = texture_get_texel_height(sprite_get_texture(spr_mmbg_1, 0));
        mmbg_shader_set_compression(spr_mmbg_1, arg0, -things_cam_x, 0, 0, 0, -things_cam_y, 0.5, 30, 0.01);
        draw_surface(global.mmbg_surf_stuff2, -_things_xoff, -_things_yoff);
        shader_reset();
        surface_reset_target();
        surface_set_target(global.mmbg_surf_stuff4);
        draw_clear_alpha(c_black, 0);
        var _tex = surface_get_texture(global.mmbg_surf_stuff3);
        shader_set_ditherfade(moddable.things_blend_amount, _tex, [0, 0, 1, 1], undefined, _dither_invert);
        draw_surface(global.mmbg_surf_stuff3, 0, 0);
        shader_reset();
        surface_reset_target();
        blendmode_set_addglow();
        draw_surface(global.mmbg_surf_stuff4, 0, 0);
        blendmode_reset();
        _dither_invert = !_dither_invert;
        things_spr = moddable.things_sprite;
        things_ind = moddable.things_image_index;
    }
}

function mmbg_shader_set_compression(arg0, arg1, arg2 = 1, arg3 = 1, arg4 = 1, arg5 = 1, arg6 = 1, arg7 = 1, arg8 = 1, arg9 = 1)
{
    var texture = sprite_get_texture(arg0, 0);
    var texel_w = texture_get_texel_width(texture);
    var texel_h = texture_get_texel_height(texture);
    arg2 *= texel_w;
    arg6 *= texel_h;
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
    var tex = texture;
    shader_set_uniform_f(u_texel, texture_get_texel_width(tex), texture_get_texel_height(tex));
    var uvs = texture_get_uvs(tex);
    shader_set_uniform_f(u_coords, uvs[0], uvs[1], uvs[2], uvs[3]);
    shader_set_uniform_f(u_xsp, arg3);
    shader_set_uniform_f(u_xfr, arg4);
    shader_set_uniform_f(u_xsi, arg5);
    shader_set_uniform_f(u_ysp, arg7);
    shader_set_uniform_f(u_yfr, arg8);
    shader_set_uniform_f(u_ysi, arg9);
    shader_set_uniform_f(u_xo, arg5 + arg2);
    shader_set_uniform_f(u_yo, arg9 + arg6);
}

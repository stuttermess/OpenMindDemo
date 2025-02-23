function RFX_draw_sprite()
{
    if (global.RFXenabled)
    {
        var sprite = argument[0];
        var index = argument[1];
        var xx = argument[2];
        var yy = argument[3];
        var xScale = (argument_count > 4) ? argument[4] : 1;
        var yScale = (argument_count > 5) ? argument[5] : 1;
        var Rot = (argument_count > 6) ? argument[6] : 0;
        var Col = (argument_count > 7) ? argument[7] : 16777215;
        var Alph = (argument_count > 8) ? argument[8] : 1;
        var sSize = [sprite_get_width(sprite), sprite_get_height(sprite)];
        RFX_set_shader(sSize);
        draw_sprite_ext(sprite, index, xx, yy, xScale, yScale, Rot, Col, Alph);
        shader_reset();
    }
}

function RFX_apply_screen()
{
    if (global.RFXenabled)
    {
        var sSize = [display_get_gui_width(), display_get_gui_height()];
        RFX_set_shader(sSize);
        draw_surface_stretched(application_surface, 0, 0, sSize[0], sSize[1]);
        shader_reset();
    }
}

function RFX_draw_surface(arg0, arg1, arg2, arg3 = 1, arg4 = 1, arg5 = 1, arg6 = 16777215, arg7 = 1)
{
    var mip;
    if (global.RFXenabled)
    {
        var area = [surface_get_width(arg0) * arg3, surface_get_height(arg0) * arg4];
        RFX_set_shader(area);
        mip = gpu_get_tex_mip_enable();
        gpu_set_tex_mip_enable(0);
    }
    draw_surface_ext(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7);
    if (global.RFXenabled)
    {
        shader_reset();
        gpu_set_tex_mip_enable(mip);
    }
}

function RFX_init(arg0, arg1, arg2, arg3 = 0, arg4 = false)
{
    global.RFXshader = 0;
    global.RFXscale = arg0;
    global.RFXdith = arg1;
    global.RFXspread = arg2;
    global.RFXcdepth = 10;
    global.RFXpal = 0;
    global.RFXdithsampler = 0;
    global.RFXpalsampler = 0;
    global.RFXscreensize = 0;
    global.RFXuspread = 0;
    global.RFXudepth = 0;
    global.RFXenabled = true;
    global.RFX2wide = arg4;
    global.RFXPixelScale = [global.RFX2wide ? (arg0 * 2) : arg0, arg0];
    global.RFXGamma = 1.2;
    global.RFXSSAA = arg3;
}

function RFX_set_shader(arg0)
{
    shader_set(global.RFXshader);
    global.RFXdithsampler = shader_get_sampler_index(global.RFXshader, "s_dithmap");
    global.RFXpalsampler = shader_get_sampler_index(global.RFXshader, "s_lutmap");
    global.RFXscreensize = shader_get_uniform(global.RFXshader, "screensize");
    global.RFXuspread = shader_get_uniform(global.RFXshader, "dspread");
    global.RFXudepth = shader_get_uniform(global.RFXshader, "cdepth");
    global.RFXuPixelScale = shader_get_uniform(global.RFXshader, "PixelScale");
    global.RFXuSSAA = shader_get_uniform(global.RFXshader, "u_SSAA");
    gpu_set_tex_filter(false);
    gpu_set_texrepeat_ext(global.RFXpalsampler, false);
    gpu_set_texrepeat_ext(global.RFXdithsampler, true);
    gpu_set_tex_mip_enable_ext(global.RFXdithsampler, 0);
    gpu_set_tex_filter_ext(global.RFXdithsampler, false);
    gpu_set_tex_mip_enable_ext(global.RFXpalsampler, 0);
    gpu_set_tex_filter_ext(global.RFXpalsampler, false);
    var RFXuGamma = shader_get_uniform(global.RFXshader, "u_Gamma");
    shader_set_uniform_f(RFXuGamma, global.RFXGamma);
    shader_set_uniform_f_array(global.RFXuPixelScale, global.RFXPixelScale);
    texture_set_stage(global.RFXpalsampler, global.RFXpal);
    texture_set_stage(global.RFXdithsampler, global.RFXdith);
    shader_set_uniform_f_array(global.RFXscreensize, arg0);
    shader_set_uniform_f(global.RFXuspread, global.RFXspread);
    shader_set_uniform_f(global.RFXudepth, global.RFXcdepth);
    shader_set_uniform_f(global.RFXuSSAA, global.RFXSSAA);
}

function RFX_set_palswap(arg0)
{
    global.RFXshader = RFX_palswap_shd;
    global.RFXpal = arg0;
}

function RFX_set_coldepth(arg0)
{
    global.RFXshader = RFX_coldepth_shd;
    global.RFXcdepth = arg0;
}

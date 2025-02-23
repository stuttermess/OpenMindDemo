function blendmode_setup_surfaces()
{
    static _blen = surface_create(camera_get_view_width(camera_get_active()), camera_get_view_height(camera_get_active()));
    static _tar = surface_create(camera_get_view_width(camera_get_active()), camera_get_view_height(camera_get_active()));
    
    global.blendmode_start_world_mat = matrix_get(2);
    matrix_set(2, matrix_build_identity());
    global.targetsurf = surface_get_target();
    global.normalblending = false;
    if (!surface_exists(_blen))
    {
        _blen = surface_create(camera_get_view_width(camera_get_active()), camera_get_view_height(camera_get_active()));
    }
    if (!surface_exists(_tar))
    {
        _tar = surface_create(camera_get_view_width(camera_get_active()), camera_get_view_height(camera_get_active()));
    }
    surface_set_target(_tar);
    gpu_set_colorwriteenable(1, 1, 1, 1);
    draw_clear_alpha(c_black, 0);
    draw_surface(global.targetsurf, 0, 0);
    surface_reset_target();
    global.targetsurf = _tar;
    global.blendsurf = _blen;
    global.blendmodestartcam = camera_get_active();
    surface_set_target(global.blendsurf);
    draw_clear_alpha(c_black, 0);
    matrix_set(2, global.blendmode_start_world_mat);
}

function set_blendmode_data_and_draw(arg0, arg1, arg2)
{
    shader_set(arg0);
    global.texblend = shader_get_sampler_index(arg0, "TextureBlend");
    global.texbase = shader_get_sampler_index(arg0, "TextureBase");
    texture_set_stage(global.texbase, surface_get_texture(arg1));
    texture_set_stage(global.texblend, surface_get_texture(arg2));
    draw_sprite(spr_debugtex1, 0, 0, 0);
    shader_reset();
}

function blendmode_reset()
{
    if (global.normalblending)
    {
        gpu_set_blendmode(bm_normal);
    }
    else
    {
        surface_reset_target();
        matrix_set(2, matrix_build_identity());
        set_blendmode_data_and_draw(global.blendmodeshader, global.targetsurf, global.blendsurf);
        matrix_set(2, global.blendmode_start_world_mat);
        camera_apply(global.blendmodestartcam);
    }
}

function blendmode_cleanup()
{
    surface_free(global.targetsurf);
    surface_free(global.blendsurf);
}

function blendmode_set_add()
{
    global.blendmodeshader = sh_add;
    blendmode_setup_surfaces();
}

function blendmode_set_subtract()
{
    global.blendmodeshader = sh_subtract;
    blendmode_setup_surfaces();
}

function blendmode_set_colordodge()
{
    global.blendmodeshader = sh_colordodge;
    blendmode_setup_surfaces();
}

function blendmode_set_hardlight()
{
    global.blendmodeshader = sh_hardlight;
    blendmode_setup_surfaces();
}

function blendmode_set_difference()
{
    global.blendmodeshader = sh_difference;
    blendmode_setup_surfaces();
}

function blendmode_set_screen()
{
    global.blendmodeshader = sh_screen;
    blendmode_setup_surfaces();
}

function blendmode_set_vividlight()
{
    global.blendmodeshader = sh_vividlight;
    blendmode_setup_surfaces();
}

function blendmode_set_hardmix()
{
    global.blendmodeshader = sh_hardmix;
    blendmode_setup_surfaces();
}

function blendmode_set_addglow()
{
    global.blendmodeshader = sh_addglow;
    blendmode_setup_surfaces();
}

function blendmode_set_multiply()
{
    global.blendmodeshader = sh_multiply;
    blendmode_setup_surfaces();
}

function blendmode_set_colorburn()
{
    global.blendmodeshader = sh_colorburn;
    blendmode_setup_surfaces();
}

function blendmode_set_overlay()
{
    global.blendmodeshader = sh_overlay;
    blendmode_setup_surfaces();
}

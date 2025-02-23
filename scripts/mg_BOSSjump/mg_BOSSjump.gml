function mg_sBOSSjump() : minigame_constructor() constructor
{
    name = "Spring Jump";
    prompt = "JUMP!";
    use_prompt = false;
    prompt_y_offset = -15;
    use_timer = false;
    music = -1;
    music_bpm = 149;
    music_ignore_bpm = true;
    music_loops = true;
    efin_skip_amount = 6;
    control_style = build_control_style(["arrows", "spacebar"]);
    screen_w = 480;
    screen_h = 270;
    smf_model_preload_obj("models/minigames/sparkle/boss/bosscube.obj");
    smf_model_preload_obj("models/minigames/sparkle/boss/bosscubeplanets.obj");
    metascript_init = msboss_metascript_init;
    metascript_start = msboss_metascript_start;
    metascript_tick_before = msboss_metascript_tick_before;
    metascript_draw_before = msboss_metascript_draw_before;
    metascript_draw_after = msboss_metascript_draw_after;
    metascript_cleanup = msboss_metascript_cleanup;
    define_object("bg_cube", 
    {
        init: msBOSSscr_bg_cube_init,
        tick: msBOSSscr_bg_cube_tick
    });
    define_object("bg_cube_planets", 
    {
        init: msBOSSscr_bg_cube_planets_init,
        tick: msBOSSscr_bg_cube_planets_tick
    });
    define_object("portal", 
    {
        init: msBOSSscr_portal_init,
        tick: msBOSSscr_portal_tick,
        draw: msBOSSscr_portal_draw
    });
    define_object("player", 
    {
        init: msBOSSscr_player_init,
        tick: msBOSSscr_player_tick,
        draw: ms_BOSSscr_player_draw
    });
    define_object("platform", 
    {
        init: msBOSSscr_platform_init,
        tick: msBOSSscr_platform_tick
    });
    define_object("particle", 
    {
        init: msBOSSscr_particle_init,
        tick: msBOSSscr_particle_tick,
        draw: msBOSSscr_particle_draw
    });
    define_object("her", 
    {
        init: msBOSSscr_her_init,
        draw: msBOSSscr_her_draw
    });
    define_object("gloop", 
    {
        init: msBOSSscr_gloop_init,
        tick: msBOSSscr_gloop_tick
    });
    define_object("cam", 
    {
        init: msBOSSscr_cam_init,
        tick: msBOSSscr_cam_tick
    });
    define_object("bunny", 
    {
        init: msBOSSscr_bunny_init,
        draw: msBOSSscr_bunny_draw
    });
    define_object("platform2", 
    {
        init: msBOSSscr_platform2_init,
        tick: msBOSSscr_platform2_tick,
        draw: msBOSSscr_platform2_draw
    });
    define_object("star", 
    {
        init: msBOSSscr_star_init,
        tick: msBOSSscr_star_tick,
        draw: msBOSSscr_star_draw
    });
    define_object("player_afterimage", 
    {
        init: msboss_player_afterimage_init,
        tick: msboss_player_afterimage_tick,
        draw: msboss_player_afterimage_draw
    });
}

function msBOSSscr_bunny_init()
{
    sprite_index = msboss_spr_bunnies;
    y = 100;
    x = 240;
}

function msBOSSscr_bunny_draw()
{
}

function msBOSSscr_star_init()
{
    sprite_index = msboss_spr_stars;
    image_index = random_range(0, 3);
    dir = choose(-1, 1);
    spd = random_range(0.8, 1.2);
    i = 0;
}

function msBOSSscr_star_tick()
{
    i++;
    if (i == 1)
    {
        starty = y;
    }
    if (x <= 120 || x >= 360)
    {
        dir = -dir;
    }
    x += (dir * spd);
    y = starty + (sin(x / 10) * 5);
}

function msBOSSscr_star_draw()
{
}

function msBOSSscr_bg_cube_init()
{
    tex = msboss_spr_cubetex;
    x = 400;
    y = 400;
    z = 0;
    xrot = 0;
    yrot = 0;
    model = smf_model_load_obj("models/minigames/sparkle/boss/bosscube.obj");
    model.texPack = [msboss_spr_cubetex];
    obj = new smf_instance(model);
}

function msBOSSscr_bg_cube_tick()
{
    xrot += 1;
    yrot += 2;
}

function msBOSSscr_bg_cube_planets_init()
{
    tex = msboss_spr_planetstex;
    x = 400;
    y = 400;
    z = 0;
    xrot = 0;
    yrot = 0;
    model = smf_model_load_obj("models/minigames/sparkle/boss/bosscubeplanets.obj");
    model.texPack = [msboss_spr_planetstex];
    obj = new smf_instance(model);
}

function msBOSSscr_bg_cube_planets_tick()
{
    xrot += 0.8;
}

function msBOSSscr_portal_init()
{
    sprite_index = msboss_spr_portal_mask;
    image_speed = 1;
    x = 240;
    y = 180;
    index = 0;
    imgindprev = 0;
    psurf = -1;
}

function msBOSSscr_portal_tick()
{
    imgindprev = image_index;
    index += 0.5;
}

function msBOSSscr_portal_draw()
{
}

function msBOSSscr_player_init()
{
    active = false;
    sprite_index = msboss_spr_player_fall;
    x = 240;
    y = -400;
    grv = 0.2;
    vsp = 0;
    hsp = 0;
    walkspd = 0;
    maxwalkspd = 5;
    acel = 0.2;
    decel = 0.3;
    aimside = 1;
    timer = 0;
    jumpbuffer = 0;
    maxjumpbuffer = 8;
    jumpsquat = 1;
    jumpsquat_time = 20;
    jumpvel_low = -3;
    jumpvel_high = -6;
    jumpvel = jumpvel_low;
    land_platform = -1;
    land_platform_offset = [0, 0];
    
    screenshake = function(arg0, arg1)
    {
        var game = get_meta_object();
        if (arg0 > game.cam.shake_remain)
        {
            game.cam.shake_magnitude = arg0;
            game.cam.shake_remain = arg0;
            game.cam.shake_length = arg1;
        }
    };
    
    startjump = function()
    {
        if (jumpsquat < 1)
        {
            exit;
        }
        var game = get_meta_object();
        sprite_index = msboss_spr_player_land_bounce;
        image_speed = 0;
        jumpsquat = 0;
        jumpvel = jumpvel_low;
        vsp = 0;
        repeat (5)
        {
            create_object("particle", 
            {
                x: x,
                y: y
            });
        }
    };
    
    jump = function(arg0 = jumpvel_low)
    {
        sprite_index = msboss_spr_player_up;
        image_speed = 1;
        jumpsquat = 1;
        vsp = arg0;
        y += vsp;
        var pitch = 1;
        var gain = 1;
        var offset = 0;
        if (arg0 == jumpvel_low)
        {
            pitch = 0.6;
            offset = 0.12;
        }
        sfx_play(msBOSS_snd_bounce, false, gain, offset, pitch);
    };
    
    var game = get_meta_object();
    floor_y = game.floor_y;
}

function msBOSSscr_player_tick()
{
    if (!active)
    {
        exit;
    }
    var game = get_meta_object();
    var level_height = game.level_height;
    if (game.intro)
    {
        if (y >= floor_y)
        {
            if (sprite_index != msboss_spr_player_trans)
            {
                sfx_play(msBOSS_snd_transform);
            }
            sprite_index = msboss_spr_player_trans;
            if (image_index <= 4)
            {
                screenshake(10, 20);
            }
            if (image_index >= 12 && image_index <= 14)
            {
                screenshake(5, 40);
            }
            if (image_index >= (sprite_get_number(sprite_index) - 1))
            {
                sprite_index = msboss_spr_player_down;
                game.intro = false;
                display_prompt();
            }
        }
        else
        {
            y += (floor_y / 150);
            game.cam.y += 1;
        }
        exit;
    }
    var input = get_input();
    var ikey = input.key;
    if (ikey.space_press)
    {
        jumpbuffer = maxjumpbuffer;
    }
    if (jumpsquat < 1 && get_win_state() != -1)
    {
        if (land_platform != -1)
        {
            x = land_platform.x + land_platform_offset[0];
            y = land_platform.y + land_platform_offset[1];
        }
        jumpsquat += (1 / jumpsquat_time);
        image_index = sprite_get_number(sprite_index) * jumpsquat;
        var _skip = 0.8;
        if (jumpbuffer > 0)
        {
            jumpvel = jumpvel_high;
            if (jumpsquat < _skip)
            {
                jumpsquat = _skip;
            }
        }
        if (jumpsquat >= 1)
        {
            jump(jumpvel);
        }
        exit;
    }
    if ((get_current_frame() % 5) == 0)
    {
        game.playerafterimage = create_object("player_afterimage", 
        {
            x: x,
            y: y,
            startx: x,
            sprite_index: sprite_index,
            image_index: image_index,
            image_angle: image_angle,
            image_speed: 0,
            image_xscale: image_xscale,
            image_yscale: image_yscale,
            image_yscale: image_yscale
        });
    }
    var on_floor = false;
    if (y >= floor_y)
    {
        y = floor_y;
        startjump();
        land_platform = -1;
        land_platform_offset = [0, 0];
    }
    if (image_index >= sprite_get_number(sprite_index))
    {
        if (vsp < 0)
        {
            sprite_index = msboss_spr_player_up;
        }
    }
    if (vsp >= 1.5)
    {
        sprite_index = msboss_spr_player_down;
    }
    var movex;
    if (get_win_state() != -1)
    {
        movex = ikey.right - ikey.left;
    }
    else
    {
        movex = 0;
    }
    if (movex != 0)
    {
        walkspd = lerp(walkspd, maxwalkspd * movex, acel);
    }
    else
    {
        walkspd = lerp(walkspd, 0, decel);
    }
    hsp = walkspd;
    vsp += grv;
    y += vsp;
    x += hsp;
    x = clamp(x, game.wall_left, game.wall_right);
    vspprev = vsp;
    yprev = y;
    jumpbuffer--;
    if (get_win_state() == 0)
    {
        for (var i = 0; i < game.totalplatforms; i++)
        {
            var p = game.platform[i];
            if (collide_obj_fast(self, x, y, p, p.x, p.y))
            {
                if (vsp > 0)
                {
                    startjump();
                    land_platform = p;
                    land_platform_offset = [x - p.x, y - p.y];
                }
            }
        }
    }
    if (collide_obj_fast(self, x, y, game.gloop, game.gloop.x, game.gloop.y))
    {
        if (get_win_state() == 0)
        {
            sfx_play(msBOSS_snd_fail);
        }
        efin_skip_amount = 4;
        game_lose();
        hsp = 0;
        vsp = 0;
        sprite_index = msboss_spr_player_sink;
    }
    if (collide_obj_fast(self, x, y, game.portal, game.portal.x, game.portal.y) && get_win_state() == 0)
    {
        if (get_win_state() == 0)
        {
            sfx_play(msBOSS_snd_magicportal, false, 2);
        }
        obj_minigame_controller.current_process_mg.efin_skip_amount += game.outro_beats;
        game.win_time = get_time();
        game_win();
        vsp = -4;
    }
    if (get_win_state() == 1)
    {
        image_xscale = max(0, image_xscale - 0.02);
        image_yscale = image_xscale;
        x = lerp(x, 240, 0.1);
        timer++;
        if (timer >= 20)
        {
            if (y >= (game.portal.y + 10))
            {
                y = game.portal.y + 10;
            }
        }
    }
}

function ms_BOSSscr_player_draw()
{
}

function msBOSSscr_platform_init()
{
    sprite_index = msboss_spr_platform;
    image_index = choose(0, 1);
    image_alpha = 0;
    shake = 0;
    dir = choose(-1, 1);
    shaketime = 0;
    i = 0;
    j = 30;
}

function msBOSSscr_platform_tick()
{
    i++;
    j--;
    shaketime--;
    var game = get_meta_object();
    if (platformid >= 10)
    {
        if ((platformid % 3) == 0 && platformid != 0)
        {
            shake = 1;
        }
        if (platformid >= 9 && (platformid % 2) == 0)
        {
            shake = 2;
        }
    }
    if (i == 1)
    {
        startx = x;
        starty = y;
    }
    if (shake == 1 && i >= 1)
    {
        if (j > 0)
        {
            x = startx + random_range(-1, 1);
            y = starty + random_range(-1, 1);
        }
        else
        {
            x += dir;
        }
        if (shaketime <= 0)
        {
            j = 30;
            shaketime = 80;
            startx = x;
        }
    }
    if (shake == 2)
    {
        x += (dir / 1.5);
    }
    if (x >= (320 + game.xoff) || x <= (160 + game.xoff))
    {
        dir = -dir;
    }
    if (i > 1 && shake != 1)
    {
        x = startx + game.xoff;
    }
    x = clamp(x, 160 + game.xoff, 320 + game.xoff);
}

function msBOSSscr_particle_init()
{
    sprite_index = msboss_spr_particle;
    rot = random_range(1, 10);
    spd = random_range(1, 2);
    angle = random_range(0, 180);
}

function msBOSSscr_particle_tick()
{
    x += lengthdir_x(spd, angle);
    y += lengthdir_y(spd, angle);
    image_angle += rot;
    image_xscale -= 0.05;
    image_yscale = image_xscale;
    if (image_xscale <= 0)
    {
        destroy_object();
    }
}

function msBOSSscr_particle_draw()
{
    var game = get_meta_object();
    var _mat_before = matrix_get(2);
    matrix_set(2, game.cam_matrix);
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, image_alpha);
    matrix_set(2, _mat_before);
}

function msBOSSscr_her_init()
{
    sprite_index = msboss_spr_her;
    y = 100;
    x = 240;
}

function msBOSSscr_her_draw()
{
}

function msBOSSscr_gloop_init()
{
    var _game = get_meta_object();
    base_x = 240;
    x = base_x;
    y = _game.level_height + 350;
    sprite_index = msboss_spr_gloop;
    gsurf = -1;
    index = 0;
}

function msBOSSscr_gloop_tick()
{
    var game = get_meta_object();
    if (game.intro)
    {
        exit;
    }
    index -= 0.5;
    if (game.player.y < (game.level_height - 200))
    {
        y = lerp(y, min(y, game.cam.y + 135 + 65), 0.1);
    }
    y -= 0.3;
    y = clamp(y, 400, 9999);
}

function msBOSSscr_cam_init()
{
    var game = get_meta_object();
    cam = view_camera[1];
    cam_default_w = 480;
    cam_default_h = 270;
    xTo = xstart;
    yTo = ystart;
    shakeX = 0;
    shakeY = 0;
    i = 0;
    shake_length = 0;
    shake_magnitude = 0;
    shake_remain = 0;
    buff = 12;
    zoomLevel = 1;
    portal_zoom_level = 25;
    temp_cam_w = cam_default_w;
    temp_cam_h = cam_default_h;
    musgain = 1;
    audio_sound_pitch(msBOSS_snd_magicportal, 1);
    portal_lerp_start_y = -1;
}

function msBOSSscr_cam_tick()
{
    zoomXTo = cam_default_w * zoomLevel;
    zoomYTo = cam_default_h * zoomLevel;
    temp_cam_w = zoomXTo;
    temp_cam_h = zoomYTo;
    var temp_cam_w_half = temp_cam_w / 2;
    var temp_cam_h_half = temp_cam_h / 2;
    var game = get_meta_object();
    xTo = game.player.x;
    yTo = game.player.y;
    if (!game.intro)
    {
        xTo = game.player.x;
        yTo = game.player.y - 30;
    }
    if (get_win_state() == 1)
    {
        xTo = game.player.x;
        yTo = game.player.y;
    }
    if (get_time() <= game.outro_beats && get_win_state() == 1)
    {
        var _intensity = (game.win_time - get_time()) / game.outro_beats;
        _intensity = clamp(_intensity * 1.25, 0, 1);
        if (_intensity > 0)
        {
            if (is_array(obj_minigame_controller.game_music))
            {
                audio_sound_gain(array_last(obj_minigame_controller.game_music), (1 - _intensity) * musgain, 0);
            }
            audio_sound_pitch(msBOSS_snd_magicportal, 1 + (_intensity * 2));
            var _zoom_intensity = clamp(_intensity * 2, 0, 1);
            zoomLevel = lerp(1, portal_zoom_level, lerp_easeIn(_zoom_intensity));
            x = lerp(portal_lerp_start_x, game.portal.x, min(_zoom_intensity, 1));
            y = lerp(portal_lerp_start_y, game.portal.y + 19, min(_zoom_intensity, 1));
        }
    }
    else
    {
        x += ((xTo - x) * 0.1);
        y += ((yTo - y) * 0.1);
        if (get_win_state() == 1)
        {
            y -= 5;
        }
        x = clamp(x, 240, 240);
        y = clamp(y, 120, game.level_height - 135);
        portal_lerp_start_x = x;
        portal_lerp_start_y = y;
    }
    shakeX += random_range(-shake_remain, shake_remain);
    shakeY += random_range(-shake_remain, shake_remain);
    shakeX = lerp(shakeX, 0, 0.1);
    shakeY = lerp(shakeY, 0, 0.1);
    shake_remain = max(0, shake_remain - ((1 / shake_length) * shake_magnitude));
    camera_set_view_size(cam, temp_cam_w, temp_cam_h);
    camera_set_view_pos(cam, x - temp_cam_w_half, y - temp_cam_h_half);
}

function msBOSSscr_platform2_init()
{
}

function msBOSSscr_platform2_tick()
{
    y++;
}

function msBOSSscr_platform2_draw()
{
}

function msboss_metascript_cleanup()
{
    surface_free(surface3d);
    surface_free(portal.psurf);
    surface_free(gloop.gsurf);
}

function msboss_metascript_draw_after()
{
    var game = get_meta_object();
    var _world_matrix_start = matrix_get(2);
    var _cam_matrix = cam_matrix;
    matrix_set(2, _cam_matrix);
    draw_sprite(msboss_spr_floor, 0, 240, level_height);
    for (var i = 0; i < totalplatforms; i++)
    {
        with (platform[i])
        {
            draw_sprite(sprite_index, image_index, x, y);
        }
    }
    with (bunny)
    {
        draw_sprite_ext(msboss_spr_screenbgbun, image_index, x, y + 50, 1, 1, 0, c_white, game.palpha);
        draw_sprite_ext(msboss_spr_bunnies, image_index, x, y + 50, 1, 1, 0, c_white, game.palpha);
        draw_sprite_ext(msboss_spr_bunnyglow, image_index, x, y + 50, 1, 1, 0, c_white, game.palpha);
    }
    with (her)
    {
        draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, game.palpha);
        draw_sprite_ext(msboss_spr_lhand, image_index, x - 120, y + 10, 1, 1, 0, c_white, game.palpha);
        draw_sprite_ext(msboss_spr_rhand, image_index, x + 120, y + 10, 1, 1, 0, c_white, game.palpha);
    }
    with (portal)
    {
        matrix_set(2, matrix_build_identity());
        if (!surface_exists(psurf))
        {
            psurf = surface_create(sprite_get_width(sprite_index), sprite_get_height(sprite_index));
        }
        surface_set_target(psurf);
        draw_clear_alpha(c_white, 0);
        draw_sprite(msboss_spr_portal_mask, image_index, sprite_get_xoffset(sprite_index), sprite_get_yoffset(sprite_index));
        gpu_set_colorwriteenable(1, 1, 1, 0);
        draw_sprite_tiled(msboss_spr_portal_tex, 0, index, index);
        draw_sprite_ditherfaded(msboss_spr_portal_cover, 0, 0, 0, 1 - ((game.cam.zoomLevel - 1) / (game.cam.portal_zoom_level - 1)));
        gpu_set_colorwriteenable(1, 1, 1, 1);
        draw_sprite(msboss_spr_portal_outline, image_index, sprite_get_xoffset(sprite_index), sprite_get_yoffset(sprite_index));
        surface_reset_target();
        matrix_set(2, _cam_matrix);
        draw_set_alpha(game.palpha);
        draw_surface(psurf, x - sprite_get_xoffset(sprite_index), y - sprite_get_yoffset(sprite_index));
        draw_set_alpha(1);
    }
    with (playerafterimage)
    {
        draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, c_white, image_alpha);
    }
    with (player)
    {
        draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, 0, c_white, image_alpha);
    }
    blendmode_set_addglow();
    for (var i = 0; i < (array_length(stars) - 1); i++)
    {
        with (stars[i])
        {
            draw_sprite_ext(sprite_index, image_index, x, y + 200, image_xscale, image_yscale, 0, c_white, 1);
        }
    }
    blendmode_reset();
    with (gloop)
    {
        matrix_set(2, matrix_build_identity());
        if (!surface_exists(gsurf))
        {
            gsurf = surface_create(sprite_get_width(sprite_index), sprite_get_height(sprite_index));
        }
        surface_set_target(gsurf);
        draw_sprite(msboss_spr_gloop, image_index, sprite_get_xoffset(sprite_index), sprite_get_yoffset(sprite_index));
        gpu_set_colorwriteenable(1, 1, 1, 0);
        draw_sprite_tiled(msboss_spr_symbols, 0, 0, index);
        gpu_set_colorwriteenable(1, 1, 1, 1);
        surface_reset_target();
        matrix_set(2, _cam_matrix);
        shader_set_wavy(msboss_spr_gloop, get_current_frame() / 10, 0.2, 10, 4, 0.5, 10, 4);
        draw_surface(gsurf, x - sprite_get_xoffset(sprite_index), y - sprite_get_yoffset(sprite_index));
        shader_reset();
    }
    for (var i = 0; i < 10; i++)
    {
        draw_sprite(msboss_spr_bg_walls, 0, 240 + xoff, (sprite_get_height(msboss_spr_bg_walls) * 2) + (i * sprite_get_height(msboss_spr_bg_walls)) + 53);
    }
    draw_sprite(msboss_spr_bg_walls_top, 0, 240 + xoff, 324);
    matrix_set(2, _world_matrix_start);
}

function msboss_metascript_draw_before()
{
    draw_sprite_tiled(msboss_spr_bg, 0, 0, 0);
    var camxto = camx;
    var camyto = camy;
    var camzto = camz;
    camxto = 100;
    camyto = 100;
    camzto = 0;
    start3d(3, camx, camy, camz, camxto, camyto, camzto, 60);
    draw3dobject(bgcube.x, bgcube.y, bgcube.z, bgcube.xrot, bgcube.yrot, 0, 10, 10, 10, bgcube.obj, msBOSS_sh_3d);
    draw3dobject(bgplanets.x, bgplanets.y, bgplanets.z, bgplanets.xrot, bgplanets.yrot, 0, 10, 10, 10, bgplanets.obj, msBOSS_sh_3d);
    end3d();
    var _transform_matrix_base = matrix_build_identity();
    _transform_matrix_base = matrix_multiply(_transform_matrix_base, matrix_build(0 - cam.x - cam.shakeX, 0 - cam.y - cam.shakeY, 0, 0, 0, 0, 1, 1, 1));
    _transform_matrix_base = matrix_multiply(_transform_matrix_base, matrix_build(0, 0, 0, 0, 0, 0, cam.zoomLevel, cam.zoomLevel, cam.zoomLevel));
    _transform_matrix_base = matrix_multiply(_transform_matrix_base, matrix_build(240, 135, 0, 0, 0, 0, 1, 1, 1));
    cam_matrix = _transform_matrix_base;
    var _world_matrix_start = matrix_get(2);
    matrix_set(2, cam_matrix);
    matrix_set(2, _world_matrix_start);
    matrix_set(2, cam_matrix);
    for (var i = 0; i < 10; i++)
    {
        for (var j = 0; j < 3; j++)
        {
            draw_sprite(msboss_spr_bg_shards, 0, -32 + (j * sprite_get_width(msboss_spr_bg_shards)), (500 - (sprite_get_height(msboss_spr_bg_shards) * 1.8)) + (i * sprite_get_height(msboss_spr_bg_shards)) + (cam.y / 2));
        }
    }
    for (var i = 0; i < 10; i++)
    {
        draw_sprite(msboss_spr_insidewall, 0, 240 + xoff, (sprite_get_height(msboss_spr_bg_walls) * 1.8) + (i * sprite_get_height(msboss_spr_bg_walls)));
    }
    draw_sprite(msboss_spr_insidewall_top, 0, 240 + xoff, 324);
    matrix_set(2, _world_matrix_start);
}

function msboss_metascript_tick_before()
{
    if (!intro)
    {
        palpha = 1;
    }
    if (!intro && get_win_state() == 0)
    {
        if (player.y <= (level_height / 2))
        {
            xoff = lerp(xoff, sin((myy - (level_height / 2)) / 130) * 100, 0.05);
            myy = min(player.y, myy);
        }
    }
    set_walls();
}

function msboss_metascript_init()
{
    outro_beats = 8;
    level_height = 2100;
    floor_height = 11;
    floor_y = level_height - floor_height;
    player = create_object("player");
    bgcube = create_object("bg_cube");
    bgplanets = create_object("bg_cube_planets");
    cam = create_object("cam");
    bunny = create_object("bunny");
    camx = 0;
    camy = 0;
    camz = 0;
    xoff = 0;
    myy = level_height;
    cam2d = level_height;
    playerafterimage = 0;
    platformpos = [[160, 2016], [240, 1952], [320, 1888], [160, 1824], [320, 1760], [240, 1696], [320, 1632], [240, 1568], [320, 1504], [160, 1440], [240, 1376], [240, 1312], [160, 1248], [320, 1184], [160, 1120], [320, 1056], [320, 992], [240, 928], [160, 864], [240, 800], [160, 736], [320, 672], [160, 608], [240, 544], [320, 480], [160, 416], [240, 352], [240, 288]];
    totalplatforms = array_length(platformpos);
    for (var i = 0; i < totalplatforms; i++)
    {
        platform[i] = create_object("platform", 
        {
            x: platformpos[i][0],
            y: platformpos[i][1] + 16,
            platformid: i
        });
    }
    for (var i = 0; i < 30; i++)
    {
        stars[i] = create_object("star", 
        {
            x: random_range(140, 340),
            y: random_range(400, level_height)
        });
    }
    portal = create_object("portal");
    gloop = create_object("gloop");
    her = create_object("her");
    intro = true;
    palpha = 0;
    
    set_walls = function()
    {
        wall_left = 140 + xoff;
        wall_right = 340 + xoff;
        gloop.x = gloop.base_x + xoff;
    };
    
    set_walls();
}

function msboss_metascript_start()
{
    player.active = true;
}

function msboss_player_afterimage_init()
{
}

function msboss_player_afterimage_tick()
{
    if (image_alpha <= 0)
    {
        destroy_object();
    }
    image_alpha -= (0.15 * get_game_speed());
}

function msboss_player_afterimage_draw()
{
}

function mg_tDungeon() : minigame_constructor() constructor
{
    name = "Dungeon";
    prompt = "FIND!";
    time_limit = 16;
    efin_skip_amount = 4;
    if (instance_exists(obj_minigame_controller) && obj_minigame_controller.endless_mode)
    {
        efin_skip_amount = 8;
    }
    music_bpm = 128;
    music = mt5_mus;
    metascript_init = mt5_metascript_init;
    metascript_start = mt5_metascript_start;
    metascript_tick_before = mt5_metascript_tick_before;
    metascript_draw_before = mt5_metascript_draw_before;
    metascript_draw_after = mt5_metascript_draw_after;
    metascript_cleanup = mt5_metascript_cleanup;
    gimmick_blacklist = [gimmick_popup];
    smf_model_preload_obj("models/minigames/tutorial/dungeon/mt5_level.obj");
    smf_model_preload_obj("models/minigames/tutorial/dungeon/mt5_skybox.obj");
    smf_model_preload_obj("models/minigames/tutorial/dungeon/mt5_present_base.obj");
    smf_model_preload_obj("models/minigames/tutorial/dungeon/mt5_present_top.obj");
    smf_model_preload_obj("models/minigames/tutorial/dungeon/mt5_object.obj");
    control_style = build_control_style(["arrows", "cmove", "cclick"]);
    define_object("level", {}, 
    {
        x: 0,
        y: 0,
        z: 0
    });
    define_object("wall", {}, 
    {
        sprite_index: mt5_spr_wall,
        image_alpha: 0
    });
    define_object("present", 
    {
        init: mt5scr_present_init,
        tick: mt5scr_present_tick
    });
    define_object("levelpresent", 
    {
        init: mt5scr_levelpresent_init,
        tick: mt5scr_levelpresent_tick
    });
}

function mt5_metascript_init()
{
    level = create_object("level");
    present = create_object("present");
    present_pos[0] = [-28, 16.5, 1.5, 0];
    present_pos[1] = [2, 29, 8, 45];
    present_pos[2] = [2.5, -26.5, 1.5, 0];
    var _p = irandom_range(0, array_length(present_pos) - 1);
    present_x = present_pos[_p][0];
    present_y = present_pos[_p][1];
    present_z = present_pos[_p][2];
    present_rot = present_pos[_p][3];
    levelpresent = create_object("levelpresent");
    flip = choose(1, -1);
    var wid = 0;
    wall[wid] = create_object("wall", 
    {
        x: -31.9,
        y: -15.3,
        image_xscale: 3.99,
        image_yscale: 2.09
    }, true);
    wid++;
    wall[wid] = create_object("wall", 
    {
        x: 20.75,
        y: -37.15,
        image_xscale: 2.92,
        image_yscale: 1
    }, true);
    wid++;
    wall[wid] = create_object("wall", 
    {
        x: 17.25,
        y: -34.85,
        image_xscale: 1.07,
        image_yscale: 1
    }, true);
    wid++;
    wall[wid] = create_object("wall", 
    {
        x: 33.45,
        y: -25.2,
        image_xscale: 0.59,
        image_yscale: 0.73
    }, true);
    wid++;
    wall[wid] = create_object("wall", 
    {
        x: 42.55,
        y: 9.9,
        image_xscale: 1,
        image_yscale: 3.69
    }, true);
    wid++;
    wall[wid] = create_object("wall", 
    {
        x: 36.75,
        y: 27.8,
        image_xscale: 1,
        image_yscale: 1
    }, true);
    wid++;
    wall[wid] = create_object("wall", 
    {
        x: -4.3,
        y: 37.3,
        image_xscale: 4.41,
        image_yscale: 1
    }, true);
    wid++;
    wall[wid] = create_object("wall", 
    {
        x: 1.9,
        y: 34.4,
        image_xscale: 1.02,
        image_yscale: 1
    }, true);
    wid++;
    wall[wid] = create_object("wall", 
    {
        x: -41.15,
        y: 14.7,
        image_xscale: 1,
        image_yscale: 1.91
    }, true);
    wid++;
    wall[wid] = create_object("wall", 
    {
        x: -36.3,
        y: 32.4,
        image_xscale: 1,
        image_yscale: 1
    }, true);
    wid++;
    wall[wid] = create_object("wall", 
    {
        x: -36.7,
        y: -2,
        image_xscale: 1,
        image_yscale: 1
    }, true);
    for (var i = 0; i < array_length(wall); i++)
    {
        with (wall[i])
        {
            collision_instance = create_collision_instance();
        }
    }
    model = smf_model_load_obj("models/minigames/tutorial/dungeon/mt5_level.obj");
    model.texPack = [mt5_spr_leveltex];
    skymodel = smf_model_load_obj("models/minigames/tutorial/dungeon/mt5_skybox.obj");
    skymodel.texPack = [mt5_spr_bg];
    smfobj = new smf_instance(model);
    skysmfobj = new smf_instance(skymodel);
    yaw = -90;
    pitch = 0;
    maxwalksp = 0.3;
    x = 20;
    y = -20;
    z = 0;
    sprite_index = mt5_spr_player;
    collision_instance = create_collision_instance();
    xxstart = x;
    yystart = y;
    xup = 0;
    yup = 0;
    zup = 1;
    walkspx = 0;
    walkspy = 0;
    viewbob = 0;
    sensitivity = 7;
    anim = 0;
    handtargetx = 350;
    handtargety = 305;
    handx = handtargetx;
    handy = handtargety;
    yawprev = yaw;
    pitchprev = pitch;
    viewboby = 0;
    darkness = 0;
    handspr = mt5_spr_hand;
    handanim = 0;
    presdist = 7;
    started = false;
    frame_start = infinity;
    stepsound_cooldown = 0;
}

function mt5_metascript_start()
{
    frame_start = get_current_frame();
    if (!obj_minigame_controller.endless_mode)
    {
    }
    started = true;
}

function mt5_metascript_tick_before()
{
    var input = get_input();
    if (get_win_state() == 0)
    {
        keyup = input.key.up;
        keydown = input.key.down;
        keyleft = input.key.left;
        keyright = input.key.right;
        var _frame = get_current_frame();
        if (_frame > (frame_start + 5))
        {
            yaw -= (((window_mouse_get_x() - (window_get_width() / 2)) / sensitivity) * flip);
            pitch += ((window_mouse_get_y() - (window_get_height() / 2)) / sensitivity);
        }
        if (started)
        {
            window_mouse_set(window_get_width() / 2, window_get_height() / 2);
        }
        show_debug_message("{0} {1}", x, y);
        pitch = clamp(pitch, -89, 89);
        var movex = (keyright - keyleft) * flip;
        var movey = keyup - keydown;
        if (movex != 0)
        {
            walkspx = lerp(walkspx, maxwalksp * get_game_speed(), 0.2);
        }
        else
        {
            walkspx = 0;
        }
        if (movey != 0)
        {
            walkspy = lerp(walkspy, maxwalksp * get_game_speed(), 0.2);
        }
        else
        {
            walkspy = 0;
        }
        stepsound_cooldown--;
        if (movex != 0 || movey != 0)
        {
            var prev_viewboby = viewboby;
            viewbob += (1 * get_game_speed());
            viewboby = sin(viewbob / 4);
            if (stepsound_cooldown <= 0 && round_to_multiple(viewboby, 0.15) > round_to_multiple(prev_viewboby, 0.15) && round_to_multiple(viewboby, 0.5) == 1)
            {
                sfx_play(mt5_snd_step);
                stepsound_cooldown = 10;
            }
        }
        else
        {
            viewbob = 0;
            viewboby = lerp(viewboby, 0, 0.1);
        }
        var _movex = (dsin(yaw) * walkspx * movex) + (dsin(yaw + 90) * walkspy * movey);
        var _movey = (dcos(yaw) * walkspx * movex) + ((dcos(yaw - 90) * walkspy * movey) / -1);
        move_and_slide(collision_instance, _movex, _movey);
        anim += 0.05;
        var dist_to_present = point_distance(x, y, present_x, present_y);
        var dest_reverb = clamp(max(dist_to_present - 7, 0) / 40, 0, 1);
        if (dist_to_present <= presdist)
        {
            sfx_play(mt5_snd_win, undefined, undefined, undefined, get_game_speed());
            game_win();
            with (obj_collider)
            {
                array_delete(minigame.colliders, array_get_index(minigame.colliders, id), 1);
            }
            instance_destroy(obj_collider);
        }
    }
    else if (get_win_state() == 1)
    {
        pitch = lerp(pitch, 30 - (present_z * 3), 0.1);
        darkness = lerp(darkness, 0.7, 0.2);
        handspr = mt5_spr_hand_grab;
        handanim += (0.15 * get_game_speed());
        if (handanim >= sprite_get_number(mt5_spr_hand_grab))
        {
            handspr = mt5_spr_hand;
        }
    }
    handx -= ((yawprev - yaw) * flip);
    handy += (pitchprev - pitch);
    handx += (sin(viewbob / 8) * 1.5);
    handy += (sin(viewbob / 4) * 1);
    handx = clamp(handx, handtargetx - 50, handtargetx + 50);
    handy = clamp(handy, handtargety - 50, handtargety + 50);
    handx = lerp(handx, handtargetx, 0.1);
    handy = lerp(handy, handtargety, 0.1);
    yawprev = yaw;
    pitchprev = pitch;
}

function mt5_metascript_draw_before()
{
    draw_clear(c_black);
}

function mt5_metascript_draw_after()
{
    var xfrom = x;
    var yfrom = y;
    var zfrom = z + 9 + (viewboby / 6);
    var xto = xfrom + (dcos(yaw) * dcos(pitch));
    var yto = yfrom - (dsin(yaw) * dcos(pitch));
    var zto = zfrom - dsin(pitch);
    
    defaultshaderscript = function()
    {
        shader_set_uniform_f(shader_get_uniform(mt5_sh_3d, "v_cameraPosition"), x, y, z);
        shader_set_uniform_f(shader_get_uniform(mt5_sh_3d, "darkness"), darkness);
    };
    
    presentshaderscript = function()
    {
        shader_set_uniform_f(shader_get_uniform(mt5_sh_3d, "darkness"), 0);
    };
    
    start3d(2, xfrom, yfrom, zfrom, xto, yto, zto, 60, 348, 195, false);
    var lp = levelpresent;
    draw3dobject(level.x, level.y, level.z, 0, 0, 0, 5, 5, 5, smfobj, mt5_sh_3d, defaultshaderscript);
    draw3dobject(lp.x, lp.y, lp.z, 0, 0, lp.rot, 5, 5, 5, lp.smfbaseobj, mt5_sh_3d, defaultshaderscript);
    draw3dobject(lp.x, lp.y, lp.z, 0, 0, lp.rot, 5, 5, 5, lp.smftopobj, mt5_sh_3d, defaultshaderscript);
    shader_set_1bit_dither(surface_get_texture(surface3d), undefined, undefined, undefined, mt5_spr_dither);
    end3d(8, 7, flip);
    shader_reset();
    shader_set(mt5_sh_bluthru);
    if (!flip)
    {
        draw_surface_ext(surface3d, 8 + surface_get_width(surface3d), 7, -1, 1, 0, c_white, 1);
    }
    else
    {
        draw_surface(surface3d, 8, 7);
    }
    shader_reset();
    if (get_win_state() == 1)
    {
        start3d(2, xfrom, yfrom, zfrom, xto, yto, zto, 60, 348, 195, false);
        var p = present;
        draw3dobject(p.x, p.y, p.z, 0, 0, p.rot + yaw + 180, 5, 5, 5, p.smfbaseobj, mt5_sh_3d, presentshaderscript);
        draw3dobject(p.x, p.y, p.z + p.topz, 0, p.topz * 15, p.rot + yaw + 180, 5, 5, 5, p.smftopobj, mt5_sh_3d, presentshaderscript);
        draw3dobject(p.x, p.y, (p.z + p.objz) - 2, 0, 0, p.rot + yaw + 180, 7 * p.objs, 7 * p.objs, 7 * p.objs, p.smfobjectobj, mt5_sh_3d, presentshaderscript);
        shader_set_1bit_dither(surface_get_texture(surface3d), undefined, undefined, undefined, mt5_spr_dither);
        end3d(8, 7, flip);
        shader_reset();
        shader_set(mt5_sh_bluthru);
        if (!flip)
        {
            draw_surface_ext(surface3d, 8 + surface_get_width(surface3d), 7, -1, 1, 0, c_white, 1);
        }
        else
        {
            draw_surface(surface3d, 8, 7);
        }
        shader_reset();
    }
    var hand_uvs = sprite_get_uvs(mt5_spr_hand, 0);
    var hoff_x = handx - handtargetx;
    var hoff_y = handy - handtargety;
    shader_set_1bit_dither(sprite_get_texture(mt5_spr_hand, 0), undefined, undefined, hand_uvs, mt5_spr_dither_hand, false, hoff_x, hoff_y, 0.5);
    draw_sprite(handspr, handanim, handx, handy);
    shader_reset();
    draw_sprite(mt5_spr_overlay, 0, 0, 0);
    draw_sprite(mt5_spr_viro, anim, 420, 185);
    if (flip)
    {
        draw_sprite_ext(mt5_spr_minimap, 1, 0, 0, 1, 1, 0, c_white, 1);
    }
    else
    {
        draw_sprite_ext(mt5_spr_minimap, 0, 0, 0, 1, 1, 0, c_white, 1);
    }
    var _mmx = x;
    var _mmy = y;
    var _mmp = mt5scr_world_to_minimap_pos(_mmx, _mmy);
    _mmx = _mmp[0];
    _mmy = _mmp[1];
    if (!flip)
    {
        draw_sprite_ext(mt5_spr_minimap_player, 0, _mmx, _mmy, 1, 1, -yaw, c_white, 1);
    }
    else
    {
        draw_sprite_ext(mt5_spr_minimap_player, 0, _mmx, _mmy, 1, 1, yaw, c_white, 1);
    }
    _mmp = mt5scr_world_to_minimap_pos(present_x, present_y);
    _mmx = _mmp[0];
    _mmy = _mmp[1];
    draw_sprite_ext(mt5_spr_minimap_goal, 0, _mmx, _mmy, 1, 1, 0, c_white, 1);
}

function mt5scr_world_to_minimap_pos(arg0, arg1)
{
    var _game = get_meta_object();
    var _x, _y;
    if (!flip)
    {
        _x = ((arg1 * 1.25) + 440) - _game.xxstart;
        _y = (arg0 * 1.2) + 80 + _game.yystart;
    }
    else
    {
        _x = ((-arg1 * 1.25) + 440) - _game.xxstart;
        _y = (arg0 * 1.2) + 80 + _game.yystart;
    }
    return [_x, _y];
}

function mt5_metascript_cleanup()
{
    surface_free(surface3d);
    if (!obj_minigame_controller.endless_mode)
    {
    }
    instance_destroy(obj_collider);
}

function mt5scr_present_init()
{
    modelbase = smf_model_load_obj("models/minigames/tutorial/dungeon/mt5_present_base.obj");
    modelbase.texPack = [mt5_spr_leveltex];
    modeltop = smf_model_load_obj("models/minigames/tutorial/dungeon/mt5_present_top.obj");
    modeltop.texPack = [mt5_spr_leveltex];
    modelobject = smf_model_load_obj("models/minigames/tutorial/dungeon/mt5_object.obj");
    modelobject.texPack = [choose(mt5_spr_object1, mt5_spr_object2, mt5_spr_object3)];
    smfbaseobj = new smf_instance(modelbase);
    smftopobj = new smf_instance(modeltop);
    smfobjectobj = new smf_instance(modelobject);
    x = 0;
    y = 0;
    z = -3;
    targetz = 0;
    rot = 0;
    game = get_meta_object();
    topz = 0;
    objz = 0;
    objs = 0;
    vsp = 0;
    sprite_index = spr_none;
}

function mt5scr_present_tick()
{
    if (get_win_state() == 1)
    {
        targetz = 7 + (game.present_z / 15) + (-game.pitch / 10 / 2);
        rot = lerp(rot, 359, 0.05 * get_game_speed());
        z = lerp(z, targetz, 0.1 * get_game_speed());
    }
    x = game.x + (dsin(game.yaw + 90) * 5);
    y = game.y + (dcos(game.yaw + 90) * 5);
    if (rot >= 354)
    {
        topz += vsp;
        vsp += (0.01 * get_game_speed());
        objz = lerp(objz, 4, 0.1);
        objs = lerp(objs, 1, 0.1);
    }
}

function mt5scr_levelpresent_init()
{
    var _game = get_meta_object();
    modelbase = smf_model_load_obj("models/minigames/tutorial/dungeon/mt5_present_base.obj");
    modelbase.texPack = [mt5_spr_leveltex];
    modeltop = smf_model_load_obj("models/minigames/tutorial/dungeon/mt5_present_top.obj");
    modeltop.texPack = [mt5_spr_leveltex];
    smfbaseobj = new smf_instance(modelbase);
    smftopobj = new smf_instance(modeltop);
    x = _game.present_x;
    y = _game.present_y;
    z = _game.present_z;
    rot = _game.present_rot;
    sprite_index = spr_none;
}

function mt5scr_levelpresent_tick()
{
}

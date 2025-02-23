function mg_fTug() : minigame_constructor() constructor
{
    name = "Jobi's Pulling";
    prompt = "PUSH!";
    use_prompt = true;
    use_timer = true;
    timer_script = timer_tutorial;
    time_limit = 12;
    show_timer_at = 8;
    music = mf2_mus;
    music_bpm = 128;
    music_loops = false;
    music_ignore_bpm = false;
    control_style = build_control_style(["cursor"]);
    gimmick_blacklist = [gimmick_popup];
    screen_w = 480;
    screen_h = 270;
    metascript_init = mf2_metascript_init;
    metascript_start = mf2_metascript_start;
    metascript_tick_before = mf2_metascript_tick_before;
    metascript_tick_after = metascript_blank;
    metascript_draw_before = mf2_metascript_draw_before;
    metascript_draw_after = mf2_metascript_draw_after;
    metascript_cleanup = metascript_blank;
    define_object("jobi", 
    {
        init: mf2scr_jobi_init,
        tick: mf2scr_jobi_tick
    });
    define_object("sylth", 
    {
        init: mf2scr_sylth_init,
        tick: mf2scr_sylth_tick,
        draw: mf2scr_sylth_draw
    });
    define_object("brain", 
    {
        init: mf2scr_brain_init,
        tick: mf2scr_brain_tick,
        draw: mf2scr_epmty
    });
}

function mf2_metascript_init()
{
    can_tug = false;
    jobi = create_object("jobi");
    sylth = create_object("sylth");
    brain = [];
}

function mf2_metascript_start()
{
    can_tug = true;
}

function mf2_metascript_tick_before()
{
}

function mf2_metascript_draw_before()
{
    draw_clear(c_black);
}

function mf2_metascript_draw_after()
{
    if (get_win_state() == 0)
    {
        draw_sprite(mf2_spr_mousepromt, (get_current_frame() / 1.8) * get_game_speed(), 240, 85);
    }
}

function mf2scr_jobi_init()
{
    x = 110;
    y = 130;
    targetyoffset = 0;
    yoffset = 0;
    yoffsetspd = 0;
    handtargetyoffset = 0;
    handyoffset = 0;
    handyoffsetspd = 0;
    jobihandtargetyoffset = 0;
    jobihandyoffset = 0;
    jobihandyoffsetspd = 0;
    goal_targetyoffset = 15;
    mouse_y_prev = 135;
    eye_x = 0;
    eye_y = 0;
    target_eye_x = 0;
    target_eye_y = 0;
    eyetimer = 0;
    maxeyetimer = random_range(10, 20);
    ignore_mouse_vel = false;
    i = 0;
    brainspawntimer = 3;
    bob = sin(get_current_frame() / 5);
    cbob = cos(get_current_frame() / 5);
    tug_sound = -1;
    tug_intensity = 0;
    
    play_tug_sound = function(arg0 = -1, arg1 = -1)
    {
        if (arg0 == -1)
        {
            arg0 = lerp(0.2, 0.6, clamp(tug_intensity / 100, 0, 0.5) / 0.5);
            arg1 = 1 + (targetyoffset / goal_targetyoffset);
        }
        arg0 *= 1;
        return sfx_play(choose(mf2_snd_tug1, mf2_snd_tug2, mf2_snd_tug3), false, arg0, 0, arg1);
    };
    
    tugging_time = 0;
    tug_effectiveness = 1;
    tension = 0.1;
    targ_tension = 0.1;
    mouse_pos_yoff = 0;
}

function mf2scr_jobi_tick()
{
    var game = get_meta_object();
    var input = get_input();
    var imouse = input.mouse;
    if (!game.can_tug)
    {
        exit;
    }
    var mousevel = (mouse_y_prev - imouse.y) + mouse_pos_yoff;
    if (mousevel < 0)
    {
        mousevel = 0;
    }
    mouse_pos_yoff = 0;
    if (targetyoffset >= goal_targetyoffset && mousevel > 50 && get_win_state() == 0)
    {
        sfx_play(mf2_snd_pop, false, 1.5);
        sfx_play(mf2_snd_cheer);
        game_win();
        tug_intensity = 0;
    }
    if (get_win_state() == 1)
    {
        targetyoffset = 100;
        yoffset = lerp(yoffset, targetyoffset, 0.2);
        if (brainspawntimer > 0)
        {
            brainspawntimer--;
        }
        else
        {
            var newbrain = create_object("brain");
            newbrain.xv = random_range(5, 8) * choose(-1, 1);
            newbrain.yv = random_range(-5, -8);
            game.brain[array_length(game.brain)] = newbrain;
            brainspawntimer = 3;
        }
    }
    else if (abs(mousevel) > 10)
    {
        var prev_tug_intensity = tug_intensity;
        tug_intensity = mousevel * tug_effectiveness;
        tension = 0.1;
        targetyoffset = max(targetyoffset, 0);
        handtargetyoffset = max(handtargetyoffset, 0);
        targetyoffset += (tug_intensity / 100);
        handtargetyoffset += (tug_intensity / 20);
        var _threshold = 30;
        if (tug_intensity > 0 && prev_tug_intensity < _threshold && tug_intensity >= _threshold)
        {
            play_tug_sound();
        }
        if (tugging_time > 5)
        {
            tug_effectiveness = lerp(tug_effectiveness, 0, 0.3);
        }
        tugging_time++;
    }
    else
    {
        tug_intensity = lerp(tug_intensity, 0, 0.2);
        tug_effectiveness = 1;
        tugging_time = 0;
    }
    var _target_y = spring(yoffset, yoffsetspd, targetyoffset, 0.1, 0.05);
    yoffset = _target_y[0];
    yoffsetspd = _target_y[1];
    var _handtarget_y = spring(handyoffset, handyoffsetspd, handtargetyoffset, 0.1, 0.2);
    handyoffset = _handtarget_y[0];
    handyoffsetspd = _handtarget_y[1];
    var _jobihandtarget_y = spring(jobihandyoffset, jobihandyoffsetspd, jobihandtargetyoffset, 0.1, 0.1);
    jobihandyoffset = _jobihandtarget_y[0];
    jobihandyoffsetspd = _jobihandtarget_y[1];
    handtargetyoffset = lerp(handtargetyoffset, 0, 0.2);
    jobihandtargetyoffset = -handtargetyoffset;
    if (get_win_state() != 1)
    {
        bob = sin(get_current_frame() / 5);
        cbob = cos(get_current_frame() / 5);
    }
    else
    {
        bob = sin(get_current_frame() / 3);
        cbob = cos(get_current_frame() / 3);
        target_eye_x = 0;
        target_eye_y = 0;
        maxeyetimer = 9999999;
    }
    eyetimer++;
    if (eyetimer >= maxeyetimer)
    {
        target_eye_x = random_range(-5, 5);
        target_eye_y = random_range(-5, 5);
        eyetimer = 0;
    }
    eye_x = lerp(eye_x, target_eye_x, 0.5);
    eye_y = lerp(eye_y, target_eye_y, 0.5);
    var old_mousey = imouse.y;
    var new_mousey = 135;
    window_mouse_set(window_get_width() / 2, window_get_height() / 2);
    mouse_pos_yoff = new_mousey - old_mousey;
    mouse_y_prev = imouse.y;
    ignore_mouse_vel--;
}

function mf2scr_jobi_draw()
{
    var game = get_meta_object();
    draw_sprite(mf2_spr_jobibackhead, 0, x, (y + (bob * 2)) - yoffset - (handyoffset / 1));
    draw_sprite(mf2_spr_jobi_body, 0, x, (y + 100 + bob) - (handyoffset * 1.5));
    for (var i = 0; i < (array_length(game.brain) - 1); i++)
    {
        with (game.brain[i])
        {
            if (layer == 0)
            {
                _draw_self();
            }
        }
    }
    draw_sprite(mf2_spr_jobibackheadmask, 0, x, (y + (bob * 2)) - yoffset - (handyoffset / 1));
    draw_sprite(mf2_spr_jobiheadfront, 0, x, (y + bob) - (handyoffset * 1.5));
    draw_sprite(mf2_spr_jobimouth, 0, x, (y + (bob * 3)) - (handyoffset * 1.5));
    draw_sprite(mf2_spr_jobieyes, 0, x, (y + (bob * 2)) - (handyoffset * 1.5));
    draw_sprite(mf2_spr_jobipupils, 0, x + (cbob * (get_win_state() * 4)) + eye_x, (y + (bob * (get_win_state() * 4)) + eye_y) - (handyoffset * 1.5));
    draw_sprite_ext(mf2_spr_jobihand, 0, x - 60, (y + 110 + (bob * 10)) - (handyoffset * 1.5) - jobihandyoffset, 1, 1, 0, c_white, 1);
    draw_sprite_ext(mf2_spr_jobihand, 0, x + 60, (y + 110 + (cbob * 10)) - (handyoffset * 1.5) - jobihandyoffset, -1, 1, 0, c_white, 1);
    for (var i = 0; i < (array_length(game.brain) - 1); i++)
    {
        with (game.brain[i])
        {
            if (layer == 1)
            {
                _draw_self();
            }
        }
    }
}

function mf2scr_sylth_init()
{
    x = 450;
    y = 200;
    targetheadx = x - 70;
    headx = targetheadx;
    head2x = targetheadx;
    head3x = targetheadx;
    targetheady = y - 110;
    heady = targetheady;
    target_y = 135;
    blinkscale = 1;
    blinktimer = 0;
    blinktimermax = random_range(20, 100);
    xoffset = 0;
    ik1 = array_create(6, -1);
    ik2 = array_create(6, -1);
}

function mf2scr_sylth_tick()
{
    var game = get_meta_object();
    blinktimer++;
    blinkscale = lerp(blinkscale, 1, 0.5);
    xoffset = -game.jobi.yoffset / 4;
    if (blinktimer >= blinktimermax)
    {
        blinkscale = 0;
        blinktimer = 0;
        blinktimermax = random_range(20, 100);
    }
    targetheadx = (x - 70) + xoffset;
    heady = targetheady;
    headx = lerp(headx, targetheadx, 0.3);
    head2x = lerp(head2x, targetheadx, 0.15);
    head3x = lerp(head3x, targetheadx, 0.1);
    ik1 = mf2_ik((x - 25) + xoffset + 5, y - 70, 190, (180 + -game.jobi.yoffset) - game.jobi.handyoffset);
    ik2 = mf2_ik((x - 25) + xoffset, y - 70, 190, (180 + -game.jobi.yoffset) - game.jobi.handyoffset);
}

function mf2_ik(arg0, arg1, arg2, arg3)
{
    var segment1_length = 115;
    var segment2_length = 130;
    var facing_dir = 0;
    var knee_mod = arg0 - (arg0 + lengthdir_x(1, facing_dir));
    var alpha = point_direction(arg0, arg1, arg2, arg3);
    var _c = min(point_distance(arg0, arg1, arg2, arg3), segment2_length + segment1_length);
    var Bx = arg0 + lengthdir_x(_c, alpha);
    var By = arg1 + lengthdir_y(_c, alpha);
    var beta = radtodeg(arccos(min(1, max(-1, ((sqr(segment1_length) + sqr(_c)) - sqr(segment2_length)) / (2 * segment1_length * _c)))));
    var Cx = arg0 + lengthdir_x(segment1_length, alpha - beta);
    var Cy = arg1 + lengthdir_y(segment1_length, alpha - beta);
    var ix = arg0 + lengthdir_x(segment1_length * cos(degtorad(beta)), point_direction(arg0, arg1, Bx, By));
    var iy = arg1 + lengthdir_y(segment1_length * cos(degtorad(beta)), point_direction(arg0, arg1, Bx, By));
    var C2x = ix + lengthdir_x(point_distance(ix, iy, Cx, Cy) * knee_mod, point_direction(ix, iy, Cx, Cy));
    var C2y = iy + lengthdir_y(point_distance(ix, iy, Cx, Cy) * knee_mod, point_direction(ix, iy, Cx, Cy));
    return [arg0, arg1, C2x, C2y, Bx, By];
}

function mf2scr_sylth_draw()
{
    var game = get_meta_object();
    draw_sprite_ext(mf2_spr_syltharm1, 1, ik1[0], ik1[1], 1, 1, point_direction(ik1[0], ik1[1], ik1[2], ik1[3]) - 180, c_white, 1);
    draw_sprite_ext(mf2_spr_syltharm1, 0, ik1[0], ik1[1], 1, 1, point_direction(ik1[0], ik1[1], ik1[2], ik1[3]) - 180, c_white, 1);
    draw_sprite_ext(mf2_spr_syltharm2, 1, ik1[2], ik1[3], 1, 1, point_direction(ik1[2], ik1[3], ik1[4], ik1[5]) - 180, c_white, 1);
    draw_sprite_ext(mf2_spr_syltharm2, 0, ik1[2], ik1[3], 1, 1, point_direction(ik1[2], ik1[3], ik1[4], ik1[5]) - 180, c_white, 1);
    draw_sprite(mf2_spr_sylthhandback, 0, (ik1[4] + 3) - xoffset, ik1[5] - 30 - 20);
    with (game.jobi)
    {
        mf2scr_jobi_draw();
    }
    draw_sprite_ext(mf2_spr_sylthupperbody, 0, x + xoffset, y, 1, 1, point_direction(min(x + xoffset, x - 15), y, x, y + 2), c_white, 1);
    draw_sprite_ext(mf2_spr_sylthlowerbody, 0, x + xoffset, y, 1, 1, -point_direction(min(x + xoffset, x - 15), y, x, y + 2) * 2, c_white, 1);
    draw_sprite_ext(mf2_spr_syltharm1, 1, ik2[0], ik2[1], 1, 1, point_direction(ik2[0], ik2[1], ik2[2], ik2[3]) - 180, c_white, 1);
    draw_sprite_ext(mf2_spr_syltharm1, 0, ik2[0], ik2[1], 1, 1, point_direction(ik2[0], ik2[1], ik2[2], ik2[3]) - 180, c_white, 1);
    draw_sprite_ext(mf2_spr_syltharm2, 1, ik2[2], ik2[3], 1, 1, point_direction(ik2[2], ik2[3], ik2[4], ik2[5]) - 180, c_white, 1);
    draw_sprite_ext(mf2_spr_syltharm2, 0, ik2[2], ik2[3], 1, 1, point_direction(ik2[2], ik2[3], ik2[4], ik2[5]) - 180, c_white, 1);
    draw_sprite(mf2_spr_sylthhandfront, 0, (ik2[4] + 3) - xoffset, ik2[5] - 30);
    draw_sprite(mf2_spr_sylthhead, 0, head2x, heady);
    draw_sprite(mf2_spr_sylthhead2, 0, headx, heady);
    draw_sprite_ext(mf2_spr_syltheyeleft, 0, headx, heady, 1, blinkscale, 0, c_white, 1);
    draw_sprite_ext(mf2_spr_syltheyeright, 0, headx, heady, 1, blinkscale, 0, c_white, 1);
    draw_sprite(mf2_spr_sylthhead3, 0, head3x, heady);
}

function mf2scr_epmty()
{
}

function mf2scr_brain_init()
{
    var game = get_meta_object();
    sprite_index = mf2_spr_brain;
    x = game.jobi.x;
    y = game.jobi.y + 16;
    hsp = random_range(-2, 2);
    vsp = random_range(-3, -2);
    grv = 0.1;
    life = 200;
    layer = 0;
}

function mf2scr_brain_tick()
{
    var game = get_meta_object();
    x += hsp;
    y += vsp;
    vsp += grv;
    if (vsp > 0)
    {
        layer = 1;
    }
    life--;
    if (y > 300)
    {
        destroy_object();
    }
}

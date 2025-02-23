function mg_tCatch() : minigame_constructor() constructor
{
    name = "Catch";
    prompt = "CATCH!";
    use_prompt = true;
    use_timer = true;
    win_on_timeover = true;
    time_limit = 8;
    music = mt3_mus;
    music_bpm = 128;
    music_loops = false;
    music_ignore_bpm = false;
    gimmick_blacklist = [gimmick_flip];
    control_style = build_control_style(["arrows"]);
    screen_w = 480;
    screen_h = 270;
    metascript_init = mt3_metascript_init;
    metascript_tick_before = mt3_metascript_tick_before;
    metascript_tick_after = metascript_blank;
    metascript_draw_before = mt3_metascript_draw_before;
    metascript_draw_after = metascript_blank;
    metascript_cleanup = mt3_metascript_cleanup;
    define_object("player", 
    {
        init: mt3scr_player_init,
        tick: mt3scr_player_tick,
        draw: mt3scr_player_draw
    });
    define_object("note", 
    {
        init: mt3scr_note_init,
        tick: mt3scr_note_tick,
        draw: mt3scr_note_draw
    });
    define_object("particle", 
    {
        init: mt3scr_particle_init,
        tick: mt3scr_particle_tick,
        draw: mt3scr_particle_draw
    });
}

function mt3_metascript_init()
{
    player = create_object("player");
    notes_max_amount = get_time_limit() - 2;
    notes = 0;
    spawn_beats = [0];
    var _fasts = max(round(2 - get_game_speed()), 0);
    var _pauses = ceil(_fasts / 2);
    notes_max_amount -= floor(get_game_speed() / 1.5);
    _pauses += floor(get_game_speed() / 1.5);
    _fasts -= floor(get_game_speed() / 1.15);
    for (var i = 1; i < notes_max_amount; i++)
    {
        var _prevbeat = spawn_beats[i - 1];
        var _adds = [0];
        if (_pauses > 0)
        {
            array_push(_adds, 0.5);
        }
        if (_fasts > 0)
        {
            array_push(_adds, -0.5);
        }
        var _add = _adds[irandom(array_length(_adds) - 1)];
        if (_add > 0)
        {
            _pauses--;
        }
        if (_add < 0)
        {
            _fasts--;
        }
        var _beat = round_to_multiple(_prevbeat + 1 + _add, 0.5);
        _beat = clamp(_beat, 0, notes_max_amount - 0.5);
        spawn_beats[i] = _beat;
        note[i] = create_object("note");
        note[i].spawn_beat = _beat;
        note[i].land_beat = _beat + 2;
    }
    bgsurf1 = -1;
    bgsurf2 = -1;
    timer = 0;
    prev_beat = -1;
}

function mt3_metascript_tick_before()
{
    current_beat = get_time_limit() - get_time();
    timer++;
    prev_beat = current_beat;
}

function mt3_metascript_draw_before()
{
    draw_clear(c_dkgray);
    if (!surface_exists(bgsurf1))
    {
        bgsurf1 = surface_create(480, 270);
    }
    if (!surface_exists(bgsurf2))
    {
    }
    var _t = get_current_frame() / 120;
    surface_set_target(bgsurf1);
    draw_clear_alpha(c_white, 0);
    draw_sprite_tiled_ext(mt3_spr_bg1, 0, _t * 182, _t * 57, 1, 1, c_white, 1);
    surface_reset_target();
    shader_set_wavy(ms0_spr_bg, get_current_frame() / 100, 1, 50, 300, 0.1, 50, 500);
    draw_surface(bgsurf1, 0, 0);
    shader_reset();
}

function mt3_metascript_cleanup()
{
    surface_free(bgsurf1);
    surface_free(bgsurf2);
}

function mt3scr_player_init()
{
    sprite_index = mt3_spr_tac;
    x = 240;
    y = 135;
    xspd = 0;
    yspd = 0;
    handx = 240;
    handy = 135;
    handxspd = 0;
    handyspd = 0;
    dir = 0;
    dirprev = 0;
    rot = 0;
    rotspd = 0;
    handrot = 0;
    handrotspd = 0;
    targetangle = 0;
    deathscale = 0;
    deathrot = 0;
    t = 0;
}

function mt3scr_player_tick()
{
    var game = get_meta_object();
    var input = get_input();
    if (get_win_state() != -1)
    {
        if (input.key.up)
        {
            dir = 0;
        }
        else if (input.key.left)
        {
            dir = 1;
        }
        else if (input.key.down)
        {
            dir = 2;
        }
        else if (input.key.right)
        {
            dir = 3;
        }
    }
    else
    {
        deathscale = lerp_easeOutBack(clamp(t, 0, 1)) * 1.4;
        deathrot += 5;
        t += (0.01 * get_game_speed());
    }
    targetangle = dir * 90;
    var diff = targetangle - rot;
    if (diff > 180)
    {
        targetangle -= 360;
    }
    else if (diff < -180)
    {
        targetangle += 360;
    }
    var _taca = spring(rot, rotspd, targetangle, 0.2, 0.4);
    rot = _taca[0];
    rotspd = _taca[1];
    var hand_diff = targetangle - handrot;
    if (hand_diff > 180)
    {
        targetangle -= 360;
    }
    else if (hand_diff < -180)
    {
        targetangle += 360;
    }
    var _handa = spring(handrot, handrotspd, targetangle, 0.1, 0.2);
    handrot = _handa[0];
    handrotspd = _handa[1];
    if (rot < 0)
    {
        rot += 360;
    }
    else if (rot >= 360)
    {
        rot -= 360;
    }
    if (handrot < 0)
    {
        handrot += 360;
    }
    else if (handrot >= 360)
    {
        handrot -= 360;
    }
    var _xx = spring(x, xspd, 240, 0.2, 0.4);
    x = _xx[0];
    xspd = _xx[1];
    var _yy = spring(y, yspd, 135, 0.2, 0.4);
    y = _yy[0];
    yspd = _yy[1];
    var _hxx = spring(handx, handxspd, 240, 0.1, 0.2);
    handx = _hxx[0];
    handxspd = _hxx[1];
    var _hyy = spring(handy, handyspd, 135, 0.1, 0.2);
    handy = _hyy[0];
    handyspd = _hyy[1];
}

function mt3scr_player_draw()
{
    if (get_win_state() != -1)
    {
        draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, image_angle + rot, c_white, image_alpha);
        draw_sprite_ext(mt3_spr_hands, 0, handx, handy, image_xscale, image_yscale, image_angle + handrot, c_white, image_alpha);
        draw_sprite(mt3_spr_tacface, 0, x + lengthdir_x(15, rot + 90), y + lengthdir_y(15, rot + 90));
    }
    else
    {
        draw_sprite_ext(sprite_index, 1, x, y, image_xscale, image_yscale, image_angle + rot, c_white, image_alpha);
        draw_sprite_ext(mt3_spr_hands, 1, handx, handy, image_xscale, image_yscale, image_angle + handrot, c_white, image_alpha);
        draw_sprite(mt3_spr_tacface, 1, x + lengthdir_x(15, rot + 90), y + lengthdir_y(15, rot + 90));
        draw_sprite_ext(mt3_spr_deathcircle, 0, x, y, deathscale, deathscale, deathrot, c_white, 1);
        draw_sprite_ext(mt3_spr_deathface, 0, x, y, deathscale, deathscale, 0, c_white, 1);
    }
}

function mt3scr_note_init()
{
    game = get_meta_object();
    sprite_index = mt3_spr_notes;
    image_index = random_range(0, sprite_get_number(sprite_index));
    dir = irandom_range(0, 3);
    if (get_game_speed() > 1.6)
    {
        dir = choose(1, 3);
    }
    var dir_real = (dir + 1) * 90;
    end_x = 240 + lengthdir_x(50, dir_real);
    end_y = 135 + lengthdir_y(50, dir_real);
    note_speed_x = 100;
    note_speed_y = note_speed_x * 0.5625;
    note_speed_x *= 1.4;
    note_speed_y *= 1.4;
    start_x = end_x + lengthdir_x(note_speed_x, dir_real);
    start_y = end_y + lengthdir_y(note_speed_y, dir_real);
    x = start_x;
    y = start_y;
    spawn_beat = 0;
    land_beat = spawn_beat + 2;
    depth = -1;
    image_speed = 0;
}

function mt3scr_note_tick()
{
    var _time = get_time_limit() - get_time();
    var _prog = (_time - spawn_beat) / (land_beat - spawn_beat);
    x = lerp(start_x, end_x, _prog);
    y = lerp(start_y, end_y, _prog);
    if ((_prog >= 1 && dir == game.player.dir) || (_prog >= 1.06 && dir != game.player.dir))
    {
        if (dir != game.player.dir)
        {
            sfx_play(mt3_snd_ouch);
            if (get_win_state() == 0)
            {
                sfx_play(mt3_snd_lose, false, 1, 0, get_game_speed());
            }
            game_lose();
        }
        else
        {
            sfx_play(mt3_snd_catch);
        }
        destroy_object();
        game.player.x -= lengthdir_x(7, (dir * 90) + 90);
        game.player.y -= lengthdir_y(7, (dir * 90) + 90);
        game.player.handx -= lengthdir_x(20, (dir * 90) + 90);
        game.player.handy -= lengthdir_y(20, (dir * 90) + 90);
        game.player.rot += random_range(-10, 10);
        game.player.handrot += random_range(-10, 10);
        repeat (random_range(4, 6))
        {
            create_object("particle", 
            {
                fromdir: (dir * 90) - 90,
                x: x,
                y: y
            });
        }
    }
}

function mt3scr_note_draw()
{
    _draw_self();
}

function mt3scr_particle_init()
{
    sprite_index = mt3_spr_particle;
    spd = random_range(1, 3);
    angle = 0;
    i = 0;
}

function mt3scr_particle_tick()
{
    var game = get_meta_object();
    if (i == 0)
    {
        angle = fromdir + random_range(-50, 50);
    }
    spd = max(0, spd - 0.1);
    image_xscale = lerp(image_xscale, 0, 0.1);
    image_yscale = lerp(image_yscale, 0.2, 0.2);
    x += -lengthdir_x(spd, angle);
    y += -lengthdir_y(spd, angle);
    i++;
    if (i >= 2)
    {
        image_index = 1;
    }
    else
    {
        image_index = 0;
    }
    if (spd <= 0)
    {
        destroy_object();
    }
    image_angle = angle;
}

function mt3scr_particle_draw()
{
    _draw_self();
}

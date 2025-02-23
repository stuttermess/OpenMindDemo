function mg_sTransform() : minigame_constructor() constructor
{
    name = "Transform";
    prompt = "TRANSFORM!";
    time_limit = 12;
    timer_script = timer_sparkle;
    efin_skip_amount = 12;
    win_on_timeover = true;
    music = ms16_mus;
    music_bpm = 128;
    gimmick_blacklist = [gimmick_flip, gimmick_combo];
    control_style = build_control_style(["arrows"]);
    metascript_init = ms16_metascript_init;
    metascript_start = ms16_metascript_start;
    metascript_tick_before = ms16_metascript_tick_before;
    metascript_tick_after = ms16_metascript_tick_after;
    metascript_draw_before = ms16_metascript_draw_before;
    metascript_draw_after = ms16_metascript_draw_after;
    define_object("sparkle", 
    {
        init: ms16scr_sparkle_init,
        tick: ms16scr_sparkle_tick,
        draw: ms16scr_sparkle_draw
    }, 
    {
        sprite_index: ms16_spr_ready,
        x: 240,
        y: 245
    });
    define_object("note", 
    {
        init: ms16scr_note_init,
        tick: ms16scr_note_tick,
        draw: ms16scr_note_draw
    }, 
    {
        sprite_index: ms16_spr_arrow,
        x: 0,
        y: 40
    });
    define_object("hitbox", 
    {
        draw: ms16scr_hitbox_draw
    }, 
    {
        x: 0,
        y: 0
    });
}

function ms16_metascript_init()
{
    sparkle = create_object("sparkle");
    hitbox = create_object("hitbox");
    endbeat = get_time_limit() - 8;
    startbeat = 3;
    beat_amount = 3;
    beat_separation = 2;
    diff = get_game_difficulty();
    switch (diff)
    {
        case 0:
        case 1:
            startbeat = 2;
            beat_amount = 3;
            beat_separation = 2;
            break;
        case 2:
        default:
            startbeat = 4;
            beat_amount = 3;
            beat_separation = 1;
            break;
    }
    if (get_game_speed() > 1.4)
    {
        startbeat = 3;
        beat_amount = 3;
        beat_separation = 2;
        diff = 0;
    }
    j = 0;
    t = 0;
    yy1 = 0;
    yy2 = 0;
    winsurf = -1;
    for (var i = 0; i < beat_amount; i++)
    {
        var _landbeat = (i * beat_separation) + startbeat;
        note[j] = create_object("note", 
        {
            landbeat: _landbeat,
            dir: irandom_range(0, 3)
        });
        show_debug_message("beat " + string(i) + ": " + string(_landbeat));
        j++;
    }
    dir = -1;
    prevdir = dir;
    keyp = false;
    xscale = 1;
    yscale = 1;
    fail = false;
    music_end = -1;
    grace_period_beats = 1.5;
    hitsound_num = 0;
}

function ms16_metascript_start()
{
    music_end = sfx_play(ms16_mus_end, false, 0, 0, get_game_speed(), true);
}

function ms16_metascript_tick_before()
{
    var _input = get_input();
    var _cb = get_time_limit() - get_time();
    if (_cb >= grace_period_beats && get_win_state() == 0)
    {
        if (_input.key.up_press)
        {
            dir = 0;
            xscale = 0.8;
            yscale = 1.2;
            keyp = true;
        }
        else if (_input.key.right_press)
        {
            dir = 1;
            xscale = 1.5;
            yscale = 0.8;
            keyp = true;
        }
        else if (_input.key.down_press)
        {
            dir = 2;
            xscale = 1.5;
            yscale = 0.8;
            keyp = true;
        }
        else if (_input.key.left_press)
        {
            dir = 3;
            xscale = 1.5;
            yscale = 0.8;
            keyp = true;
        }
    }
    var _hitsounds = [ms16_snd_hit1, ms16_snd_hit2, ms16_snd_hit3, ms16_snd_hit4, ms16_snd_hit5];
    if (keyp)
    {
        if (array_length(note) > 0)
        {
            var n = note[0];
            if (collide_obj_fast(n, n.x, n.y, hitbox, hitbox.x, hitbox.y))
            {
                if (dir == n.dir)
                {
                    sfx_play(_hitsounds[hitsound_num]);
                    hitsound_num++;
                    if (beat_amount == 3)
                    {
                        hitsound_num++;
                    }
                    show_debug_message("hit");
                    fail = false;
                }
                else
                {
                    sfx_play(ms16_snd_miss);
                    game_lose();
                    fail = true;
                }
                destroy_object(n);
                array_delete_pos(note, 0);
            }
            else
            {
                sfx_play(ms16_snd_miss);
                game_lose();
                fail = true;
            }
        }
    }
    if (array_length(note) <= 0)
    {
        if (get_win_state() == 0)
        {
            if (obj_minigame_controller.endless_mode)
            {
                audio_sound_gain(music_end, 1, 0);
            }
            sfx_play(ms16_snd_win);
        }
        game_win();
    }
    if (get_win_state() != 0)
    {
        t++;
    }
    var s = sparkle;
    switch (dir)
    {
        case 0:
            if (!fail)
            {
                s.sprite_index = ms16_spr_up;
            }
            else
            {
                s.sprite_index = ms16_spr_up_fail;
            }
            break;
        case 1:
            if (!fail)
            {
                s.sprite_index = ms16_spr_right;
            }
            else
            {
                s.sprite_index = ms16_spr_right_fail;
            }
            break;
        case 2:
            if (!fail)
            {
                s.sprite_index = ms16_spr_down;
            }
            else
            {
                s.sprite_index = ms16_spr_down_fail;
            }
            break;
        case 3:
            if (!fail)
            {
                s.sprite_index = ms16_spr_left;
            }
            else
            {
                s.sprite_index = ms16_spr_left_fail;
            }
            break;
        default:
            if (!fail)
            {
                s.sprite_index = ms16_spr_ready;
            }
            else
            {
                s.sprite_index = ms16_spr_ready_fail;
            }
            break;
    }
    xscale = lerp(xscale, 1, 0.2);
    yscale = lerp(yscale, 1, 0.2);
    s.image_xscale = xscale;
    s.image_yscale = yscale;
    prevdir = dir;
    keyp = false;
}

function ms16_metascript_tick_after()
{
}

function ms16_metascript_draw_before()
{
    draw_sprite(ms16_spr_bg, diff, get_screen_width() / 2, get_screen_height() / 2);
}

function ms16_metascript_draw_after()
{
    var w = get_screen_width() / 2;
    var h = get_screen_height() / 2;
    if (get_win_state() == 1)
    {
        draw_set_alpha(t / 15);
        draw_rectangle(0, 0, 999, 999, false);
        var _et = 45;
        if (t >= _et)
        {
            if (!surface_exists(winsurf))
            {
                winsurf = surface_create(get_screen_width(), get_screen_height());
            }
            if (!game_get_pause())
            {
                yy1 = lerp(yy1, 80, 0.015);
                yy2 = lerp(yy2, -40, 0.015);
            }
            surface_set_target(winsurf);
            draw_sprite(ms16_spr_bg_win, 0, w, 20 + h + ((t - _et) / 10));
            draw_sprite(ms16_spr_transform1, 0, 120, h + yy1);
            draw_sprite(ms16_spr_transform2, 0, 350, h + yy2 + 60);
            draw_set_alpha(1);
            blendmode_set_addglow();
            draw_sprite(ms16_spr_bg_addglow, 0, w, h);
            blendmode_reset();
            surface_reset_target();
            draw_surface_ext(winsurf, 0, 0, 1, 1, 0, c_white, (t - _et) / 15);
        }
    }
    if (get_win_state() == -1)
    {
        draw_set_alpha((t / 15) - 1);
        draw_rectangle(0, 0, 999, 999, false);
        var _et = 75;
        if (t >= _et)
        {
            draw_sprite_ext(ms16_spr_bg_fail, 0, w, h, 1, 1, 0, c_white, (t - _et) / 15);
        }
    }
    draw_set_alpha(1);
}

function ms16scr_sparkle_init()
{
}

function ms16scr_sparkle_tick()
{
}

function ms16scr_sparkle_draw()
{
    _draw_self();
}

function ms16scr_note_init()
{
    screencentrex = get_screen_width() / 2;
    notespd = 90;
    landbeat = 1;
    dir = 0;
    currentbeat = get_time_limit() - get_time();
    prevbeat = currentbeat;
    beatskip = 0;
    xx = 292;
    game = get_meta_object();
}

function ms16scr_note_tick()
{
    var _cb = get_time_limit() - get_time();
    if (beatskip == 0 && get_time() < (get_time_limit() - 0.1))
    {
        if (abs(prevbeat - _cb) >= 1)
        {
            beatskip = round(abs(prevbeat - _cb));
        }
    }
    currentbeat = _cb + beatskip;
    x = screencentrex + lerp(0, -notespd, (landbeat - currentbeat) + (beatskip * 2));
    image_angle = dir * -90;
    prevbeat = (get_time_limit() - get_time()) + beatskip;
    if (get_game_difficulty() == 0)
    {
        xx = 292;
    }
    else if (get_game_difficulty() == 1)
    {
        xx = 268;
    }
    else if (get_game_difficulty() == 2)
    {
        xx = 258;
    }
    if (x >= xx)
    {
        game_lose();
        game.fail = true;
    }
}

function ms16scr_note_draw()
{
    _draw_self();
    var orix = x;
    var center_diff = x - 240;
    x = 240 - center_diff;
    _draw_self();
    x = orix;
}

function ms16scr_hitbox_draw()
{
    game = get_meta_object();
    sprite_index = asset_get_index("ms16_spr_bghitbox_" + string(game.diff));
}

function array_delete_pos(arg0, arg1)
{
    var _length = array_length(arg0);
    if (_length > 1)
    {
        for (var _i = arg1; _i < (_length - 1); _i++)
        {
            arg0[_i] = arg0[_i + 1];
        }
    }
    array_resize(arg0, _length - 1);
}

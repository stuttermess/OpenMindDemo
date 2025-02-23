enum curstates
{
	sparkle = 0,
	kiss = 1 // cute hehe
}

function mg_sDodge() : minigame_constructor() constructor
{
    name = "Dodge";
    prompt = "AVOID!";
    time_limit = 20;
    music = ms10_mus;
    music_bpm = 128;
    win_on_timeover = true;
    control_style = build_control_style(["dleft", "dright", "spacebar"]);
    screen_w = 480;
    screen_h = 270;
    metascript_init = ms10_metascript_init;
    metascript_start = ms10_metascript_start;
    metascript_draw_before = ms10_metascript_draw_before;
    metascript_draw_after = ms10_metascript_draw_after;
    define_object("guy", 
    {
        init: ms10scr_guy_init,
        tick: ms10scr_guy_tick,
        draw: ms10scr_guy_draw
    });
    define_object("hit", 
    {
        init: ms10scr_hit_init,
        tick: ms10scr_hit_tick,
        draw: ms10scr_hit_draw
    });
    define_object("sparkle", 
    {
        init: ms10scr_sparkle_init,
        tick: ms10scr_sparkle_tick,
        draw: ms10scr_sparkle_draw
    });
    define_object("heart", 
    {
        init: ms10scr_heart_init,
        tick: ms10scr_heart_tick
    });
    define_object("explosion", 
    {
        init: ms10scr_explosion_init,
        tick: ms10scr_explosion_tick,
        draw: ms10scr_explosion_draw
    });
    define_object("mwa", 
    {
        init: ms10scr_mwa_init,
        tick: ms10scr_mwa_tick,
        draw: ms10scr_mwa_draw
    });
    define_object("flame", 
    {
        init: ms10scr_flame_init,
        tick: ms10scr_flame_tick,
        draw: ms10scr_flame_draw
    });
}

function ms10_metascript_init()
{
    sparkle = create_object("sparkle");
    guy = create_object("guy");
    explosion = create_object("explosion", 
    {
        y: -2000
    });
    mwa = -4;
    flame1 = array_create(20, -4);
    flame2 = array_create(20, -4);
    hit = -4;
    heartexists = false;
    flameamt = 0;
    heartamt = 0;
    shakex = 0;
    shakey = 0;
    shakemag = 0;
    shaketime = 0;
    cam2d_create();
}

function ms10_metascript_start()
{
    sparkle.active = true;
}

function ms10_metascript_draw_before()
{
    draw_clear(c_teal);
    shader_set_wavy(ms10_spr_bg, get_current_frame() / 6, 0.2, 140, 3, 0.2, 140, 3);
    draw_sprite(ms10_spr_bg, 0, camera_get_view_x(cam2d_get_view()) + 240, 130);
    shader_reset();
    draw_sprite(ms10_spr_presents, 0, camera_get_view_x(cam2d_get_view()) / 3, 270);
}

function ms10_metascript_draw_after()
{
    with (sparkle)
    {
        _draw_self();
    }
    if (heartexists)
    {
        for (var i = 0; i < (heartamt + 1); i++)
        {
            shader_set_ditherfade(0.2, sprite_get_texture(ms10_spr_heart, 0));
            with (heart[i])
            {
                perform_event("draw");
            }
            shader_reset();
        }
    }
    for (var i = 0; i < (flameamt + 1); i++)
    {
        with (flame1[i])
        {
            _draw_self();
        }
        with (flame2[i])
        {
            _draw_self();
        }
    }
    with (mwa)
    {
        _draw_self();
    }
    with (explosion)
    {
        _draw_self();
    }
    with (guy)
    {
        draw_sprite_ext(sprite_index, image_index, x, y, image_xscale + xscale, image_yscale + yscale, image_angle, c_white, image_alpha);
    }
    draw_sprite(ms10_spr_fg, 0, 240, 270);
    with (hit)
    {
        _draw_self();
    }
}

function ms10scr_guy_init()
{
    x = 240;
    y = 150;
    active = true;
    hsp = 0;
    vsp = 0;
    vspprev = 0;
    grv = 0.3;
    walkspd = 0;
    maxwalkspd = 3.5;
    acel = 0.2;
    decel = 0.3;
    aimside = 1;
    jumpheight = -7.6;
    maxjumpbuffer = 10;
    jumpbuffer = 0;
    xscale = 0;
    yscale = 0;
    yprev = 0;
    floorheight = 230;
    death = false;
    walksound = -1;
    sprite_index = ms10_spr_guy_idle;
}

function ms10scr_guy_tick()
{
    if (!active)
    {
        exit;
    }
    var input = get_input();
    var game = get_meta_object();
    var ikey = input.key;
    if (game.shaketime > 0)
    {
        game.shakex = random_range(-game.shakemag, game.shakemag);
        game.shakey = random_range(-game.shakemag, game.shakemag);
        game.shakemag = lerp(game.shakemag, 0, 0.1);
        game.shaketime -= 1;
    }
    var camx = (mean(x, game.sparkle.x) - 240) / 10;
    camera_set_view_pos(cam2d_get_view(), camx + game.shakex, 0 + game.shakey);
    if (!death)
    {
        if (y >= floorheight)
        {
            y = floorheight;
            vsp = 0;
        }
        var movex = ikey.right - ikey.left;
        if (movex != 0)
        {
            walkspd = lerp(walkspd, maxwalkspd * movex, acel);
            if (walksound == -1)
            {
                walksound = sfx_play(ms10_snd_walk, true);
                audio_sound_loop_end(ms10_snd_walk, 0.235);
            }
        }
        else
        {
            walkspd = lerp(walkspd, 0, decel);
        }
        if ((movex == 0 || y < floorheight) && walksound != -1)
        {
            audio_stop_sound(walksound);
            walksound = -1;
        }
        hsp = walkspd;
        uph = ikey.space;
        if (ikey.space_press)
        {
            jumpbuffer = maxjumpbuffer;
        }
        if (jumpbuffer > 0)
        {
            if ((y + 1) > floorheight)
            {
                vsp = jumpheight;
                jumpbuffer = 0;
            }
        }
        if (ikey.space_press && (y + 1) > floorheight)
        {
            vsp = jumpheight;
            jumpbuffer = 0;
            sfx_play(ms10_snd_jump);
        }
        if (vsp < 0 && !uph)
        {
            vsp = max(vsp, jumpheight / 3);
        }
        jumpbuffer--;
        aimside = movex;
        if (aimside != 0)
        {
            image_xscale = aimside;
        }
        if (movex != 0)
        {
            image_speed = abs(hsp / 2);
        }
        else
        {
            image_speed = 1;
        }
        if (hsp >= -0.1 && hsp <= 0.1)
        {
            sprite_index = ms10_spr_guy_idle;
        }
        else
        {
            sprite_index = ms10_spr_guy_run;
        }
        if (y < floorheight)
        {
            sprite_index = ms10_spr_guy_jump;
        }
        if ((y + 5) >= floorheight)
        {
            if ((yprev + 1) < floorheight)
            {
                xscale = (vspprev / 4) * image_xscale;
                yscale = -vspprev / 10;
            }
        }
        else if (vsp != 0)
        {
            yscale = abs(vsp / 8);
            xscale = abs(vsp / 15) * -image_xscale;
        }
    }
    yscale = lerp(yscale, 0, 0.2);
    xscale = lerp(xscale, 0, 0.2);
    vsp += grv;
    y += vsp;
    x += hsp;
    image_speed = get_game_speed();
    x = clamp(x, 46, 420);
    if (yprev < floorheight && y >= floorheight)
    {
        sfx_play(ms10_snd_land);
    }
    vspprev = vsp;
    yprev = y;
    game = get_meta_object();
    if (game.heartexists)
    {
        for (var i = 0; i < game.flameamt; i++)
        {
            if ((collide_obj_fast(self, x, y, game.flame1[i + 1], game.flame1[i + 1].x, game.flame1[i + 1].y) && game.flame1[i + 1].active) || (collide_obj_fast(self, x, y, game.flame2[i + 1], game.flame2[i + 1].x, game.flame2[i + 1].y) && game.flame2[i + 1].active))
            {
                sprite_index = ms10_spr_guy_death;
                game_lose();
                if (death == false)
                {
                    hsp = random_range(-1, 1);
                    vsp = -7;
                    game.hit = create_object("hit", 
                    {
                        x: x,
                        y: y
                    });
                }
                death = true;
            }
        }
    }
    if (death)
    {
        image_angle += 7;
    }
}

function ms10scr_guy_draw()
{
}

function ms10scr_hit_init()
{
    sprite_index = ms10_spr_hit;
    i = 20;
    image_alpha = 1;
    y -= 10;
    image_xscale = 0;
    image_yscale = 0;
}

function ms10scr_hit_tick()
{
    i--;
    image_angle += 15;
    image_alpha -= 0.05;
    image_xscale += 0.2;
    image_yscale += 0.2;
    if (i <= 0)
    {
        image_alpha = 0;
    }
}

function ms10scr_hit_draw()
{
}

function ms10scr_sparkle_init()
{
    x = 240;
    y = 240;
    image_alpha = 1;
    xstart = x;
    sprite_index = ms10_spr_sparkle_idle;
    timer = 0;
    maxtimer = (60 * random_range(1, 2)) / get_game_speed() / get_game_speed() / 1.4;
    atttimer = 0;
    curstate = curstates.sparkle;
    i = 0;
    active = false;
}

function ms10scr_sparkle_tick()
{
    if (!active)
    {
        exit;
    }
    var game = get_meta_object();
    switch (curstate)
    {
        case curstates.sparkle:
            x = xstart + (sin(i / 50) * 100);
            sprite_index = ms10_spr_sparkle_idle;
            if (timer >= maxtimer)
            {
                timer = 0;
                curstate = curstates.kiss;
            }
            timer += 1;
            i += (1 * (0.5 - (get_game_speed() * 1.5)));
            break;
        case curstates.kiss:
            if (atttimer == 20)
            {
                game.heart[game.heartamt] = create_object("heart", 
                {
                    x: x
                });
                game.mwa = create_object("mwa", 
                {
                    x: x
                });
                sfx_play(ms10_snd_smooch);
            }
            if (atttimer >= 20)
            {
                sprite_index = ms10_spr_sparkle_mwa;
            }
            else
            {
                sprite_index = ms10_spr_sparkle_mm;
            }
            if (atttimer >= (60 / clamp(get_game_speed(), 0, 2.5)))
            {
                curstate = curstates.sparkle;
                atttimer = 0;
                maxtimer = (60 * random_range(1, 2)) / get_game_speed() / 1.5;
            }
            atttimer++;
            break;
    }
}

function ms10scr_sparkle_draw()
{
}

function ms10scr_heart_init()
{
    var game = get_meta_object();
    y = 90;
    image_alpha = 0.7;
    sprite_index = ms10_spr_heart;
    hsp = sign(game.guy.x - game.sparkle.x) * 2;
    var gspd = clamp(get_game_speed(), 0, 2.5);
    vsp = -3 * gspd * 1.4;
    grv = 0.1 * gspd * 2.5;
    floorheight = 230;
}

function ms10scr_heart_tick()
{
    var game = get_meta_object();
    vsp += grv;
    x += hsp;
    y += vsp;
    game.heartexists = true;
    if (y >= floorheight)
    {
        y = -999999;
        sfx_play(ms10_snd_fire);
        for (var i = 0; i < 4; i++)
        {
            game.flameamt++;
            maxtick = 10;
            game.flame1[game.flameamt] = create_object("flame", 
            {
                x: x + (13 * i),
                dir: 1,
                delay: 10 * i
            });
            game.flame2[game.flameamt] = create_object("flame", 
            {
                x: x - (13 * i),
                dir: -1,
                delay: 10 * i
            });
        }
        game.explosion = create_object("explosion", 
        {
            x: x
        });
        game.shakemag = 10;
        game.shaketime = 1000;
        image_alpha = 0;
        destroy_object();
    }
}

function ms10scr_heart_draw()
{
}

function ms10scr_explosion_init()
{
    sprite_index = ms10_spr_explosion;
    image_alpha = 1;
    y = 210;
}

function ms10scr_explosion_tick()
{
    if (image_index >= (sprite_get_number(sprite_index) - 1))
    {
        image_alpha = 0;
        y = -9999;
    }
}

function ms10scr_explosion_draw()
{
}

function ms10scr_mwa_init()
{
    sprite_index = ms10_spr_mwa;
    len = random_range(1, 1.5);
    dir = random_range(0, 359);
    image_alpha = 1;
    y = 90;
}

function ms10scr_mwa_tick()
{
    x += lengthdir_x(len, dir);
    y += lengthdir_y(len, dir);
    len = max(0, len - 0.04);
    image_alpha -= 0.02;
    if (image_index >= (sprite_get_number(sprite_index) - 1))
    {
        image_speed = 0;
    }
}

function ms10scr_mwa_draw()
{
}

function ms10scr_flame_init()
{
    sprite_index = ms10_spr_flames;
    image_speed = 0;
    image_alpha = 1;
    y = 210;
    spd = (5 * (get_game_speed() * 3)) / 2;
    delay = 0;
    active = false;
}

function ms10scr_flame_tick()
{
    if (delay <= 0)
    {
        image_speed = 1 * get_game_speed();
    }
    delay -= (1 * get_game_speed());
    if (image_index >= 3)
    {
        active = true;
    }
    if (image_index >= (sprite_get_number(ms10_spr_flames) - 1))
    {
        y = -2000;
    }
    if (image_index >= (sprite_get_number(ms10_spr_flames) - 5))
    {
        active = false;
    }
}

function ms10scr_flame_draw()
{
}

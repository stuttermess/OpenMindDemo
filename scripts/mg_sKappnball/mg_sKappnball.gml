function mg_sKappnball() : minigame_constructor() constructor
{
    name = "KAPPNBALL";
    prompt = "PADDLE!";
    time_limit = 20;
    music = ms13_mus;
    music_bpm = 128;
    music_loops = false;
    control_style = build_control_style(["dleft", "dright"]);
    metascript_init = mg13_metascript_init;
    metascript_start = mg13_metascript_start;
    metascript_tick_before = mg13_metascript_tick_before;
    metascript_tick_after = metascript_blank;
    metascript_draw_before = mg13_metascript_draw_before;
    metascript_draw_after = metascript_blank;
    metascript_cleanup = metascript_blank;
    define_object("paddle", 
    {
        init: mg13_paddle_init,
        tick: mg13_paddle_tick
    });
    define_object("kapp", 
    {
        init: mg13_kapp_init,
        tick: mg13_kapp_tick
    });
    define_object("ball", 
    {
        init: mg13_ball_init,
        tick: mg13_ball_tick
    });
    define_object("block", 
    {
        init: mg13_block_init,
        tick: mg13_block_tick,
        draw: mg13_block_draw
    }, 
    {
        myid: 0
    });
    define_object("particle", 
    {
        init: mg13_particle_init,
        tick: mg13_particle_tick,
        draw: mg13_particle_draw
    }, 
    {
        fromdir: 0
    });
}

function mg13_metascript_init()
{
	enum blist
	{
		UNKNOWN_0,
		UNKNOWN_1,
		UNKNOWN_2,
		UNKNOWN_3,
		UNKNOWN_4,
		UNKNOWN_5,
		UNKNOWN_6
	}
	
    paddle = create_object("paddle");
    kapp = create_object("kapp");
    ball = create_object("ball");
    var startx = 140;
    var sep = 45;
    var yy = 30;
    blocklist = [
	[
		[blist.UNKNOWN_4, startx, yy + 10], [blist.UNKNOWN_5, startx + 139, yy + 10],
		[blist.UNKNOWN_3, startx + 32, yy], [blist.UNKNOWN_6, startx + 60, yy],
		[blist.UNKNOWN_6, startx + 79, yy], [blist.UNKNOWN_0, startx + 108, yy],
		[blist.UNKNOWN_1, startx + 32, yy + 19], [blist.UNKNOWN_2, startx + 70, yy + 19],
		[blist.UNKNOWN_3, startx + 108, yy + 19]
	]];
    var rand = irandom_range(0, array_length(blocklist) - 1);
    blockspawnlist = blocklist[rand];
    totalblocks = 3;
    maxtotalblocks = 0;
    for (var i = 0; i < array_length(blockspawnlist); i++)
    {
        iid = blockspawnlist[i][0];
        xx = blockspawnlist[i][1] + 80;
        yy = blockspawnlist[i][2] + 45;
        block[i] = create_object("block", 
        {
            myid: iid,
            x: xx,
            y: yy,
            objid: i
        });
        maxtotalblocks++;
    }
    sat = 1;
}

function mg13_metascript_start()
{
    ball.active = true;
}

function mg13_metascript_tick_before()
{
    var input = get_input();
    if (totalblocks <= 0)
    {
        game_win();
    }
}

function mg13_metascript_draw_before()
{
    if (get_win_state() == -1)
    {
        sat = 0;
        shader_set_grayscale(sat);
    }
    draw_sprite(ms13_spr_bg, 0, 0, 0);
    draw_sprite(ms13_spr_windows, 0, (get_screen_width() / 2) - 1, (get_screen_height() / 2) + 2);
    shader_reset();
    draw_text((get_screen_width() / 2) + 30, get_screen_height() / 2, string(totalblocks) + " LEFT");
}

function mg13_particle_init()
{
    sprite_index = ms13_spr_particle;
    spd = random_range(1, 3);
    angle = fromdir;
    i = 0;
}

function mg13_particle_tick()
{
    var game = get_meta_object();
    if (i == 0)
    {
        angle = fromdir + random_range(-30, 30);
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

function mg13_particle_draw()
{
    _draw_self();
}

function mg13_block_init()
{
    sprlist = [ms13_spr_block_blue, ms13_spr_block_green, ms13_spr_block_pink, ms13_spr_block_purple, ms13_spr_block_twin1_left, ms13_spr_block_twin1_right, ms13_spr_block_twin2];
    sprite_index = sprlist[myid];
    active = true;
    timer = 5;
}

function mg13_block_tick()
{
    var game = get_meta_object();
    if (!active)
    {
        timer--;
        sprite_index = sprlist[myid];
        if (timer <= 0)
        {
            sprite_index = spr_none;
        }
    }
    else
    {
        sprite_index = sprlist[myid];
    }
    if (timer == 2)
    {
        repeat (random_range(3, 6))
        {
            var p = create_object("particle");
            p.x = x;
            p.y = y;
            p.fromdir = point_direction(x, y, game.ball.x, game.ball.y) + 180;
        }
    }
}

function mg13_block_draw()
{
    var game = get_meta_object();
    if (get_win_state() == -1)
    {
        shader_set_grayscale(game.sat);
    }
    if (active)
    {
        _draw_self();
    }
    else
    {
        shader_set(sh_flashwhite);
        draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, 1);
    }
    shader_reset();
}

function mg13_paddle_init()
{
    sprite_index = ms13_spr_paddle;
    y = 202;
    x = 295;
    paddlewidth = sprite_get_width(sprite_index);
    skid = -1;
    walkspd = 0;
    maxwalkspd = 2.5 + (get_game_speed() - 1);
    acel = 0.1 + ((get_game_speed() - 1) / 10);
    decel = 0.1;
    aimside = 1;
    spd = 0;
    maxspd = 1.5;
}

function mg13_paddle_tick()
{
    var input = get_input();
    var move = input.key.right - input.key.left;
    if (move != 0)
    {
        walkspd = lerp(walkspd, maxwalkspd * move, acel);
    }
    else
    {
        walkspd = lerp(walkspd, 0, decel);
    }
    x += walkspd;
    x = clamp(x, 221, 361);
    if (x == 221 || x == 361)
    {
        walkspd = 0;
    }
    aimside = move;
    if (aimside != 0)
    {
        image_xscale = aimside;
    }
    if (skid <= 0)
    {
        sprite_index = ms13_spr_paddle;
    }
    else
    {
        if (sprite_index == ms13_spr_paddle)
        {
            sfx_play(ms13_snd_paddleskid);
        }
        sprite_index = ms13_spr_paddle_halt;
    }
    if (abs(walkspd) >= 1.2)
    {
        if (move != 0 && sign(walkspd) != aimside && walkspd != 0)
        {
            skid = 17;
        }
    }
    image_angle = walkspd * 2;
    skid--;
}

function mg13_ball_init()
{
    sprite_index = ms13_spr_ball;
    x = 295;
    y = 185;
    active = false;
    spd = (get_game_speed() * 2) - 0.5;
    direction = -70;
    left = 200;
    right = 382;
    top = 62;
    bottom = 210;
}

function mg13_ball_tick()
{
    if (!active)
    {
        exit;
    }
    var game = get_meta_object();
    x += lengthdir_x(spd, direction);
    y += lengthdir_y(spd, direction);
    xto = x + lengthdir_x(spd, direction);
    yto = y + lengthdir_y(spd, direction);
    if ((xto >= right || xto <= left) && y < bottom)
    {
        x = clamp(x, left, right);
        direction = -direction + 180;
        sfx_play(ms13_snd_wallbounce);
    }
    if (yto <= top)
    {
        direction = -direction;
        sfx_play(ms13_snd_wallbounce);
    }
    paddlewidth = game.paddle.paddlewidth / 2;
    paddlex = game.paddle.x;
    paddley = game.paddle.y;
    if ((paddlex - paddlewidth) <= x && (paddlex + paddlewidth) >= x)
    {
        if (y >= (paddley - 10) && y <= (paddley + 10))
        {
            direction = point_direction(paddlex, paddley, x, y);
            sfx_play(ms13_snd_paddlebounce);
            spd += 0.1;
            while (y >= (paddley - 10))
            {
                y -= 5;
                direction = point_direction(paddlex, paddley, x, y);
            }
        }
    }
    var b = game.block;
    var blength = game.maxtotalblocks;
    for (var i = 0; i < blength; i++)
    {
        if (collide_obj_fast(self, x, y, b[i], b[i].x, b[i].y))
        {
            if (b[i].active)
            {
                direction = -direction;
                x += lengthdir_x(spd, direction);
                y += lengthdir_y(spd, direction);
                b[i].active = false;
                var _snd = sfx_play(ms13_snd_brickbreak);
                audio_sound_pitch(_snd, random_range(0.9, 1.1));
                game.totalblocks--;
            }
        }
    }
    if (y > (game.paddle.y + 15))
    {
        if (get_win_state() == 0)
        {
            audio_sound_gain(sfx_play(ms13_snd_lose), 1, 0);
        }
        game_lose();
    }
}

function mg13_kapp_init()
{
    sprite_index = ms13_spr_kappu;
    x = 136;
    y = 104;
    xstart = x;
    magnitude = 2;
}

function mg13_kapp_tick()
{
    if (get_win_state() == -1)
    {
        sprite_index = ms13_spr_kappu_sad;
        x = xstart + random_range(-magnitude, magnitude);
        magnitude = lerp(magnitude, 0, 0.05);
    }
    if (get_win_state() == 1)
    {
        sprite_index = ms13_spr_kappu_happy;
    }
}

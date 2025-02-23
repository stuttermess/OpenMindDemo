function mg_tShark() : minigame_constructor() constructor
{
    name = "Shark";
    prompt = "CATCH!";
    use_prompt = true;
    use_timer = true;
    time_limit = 8;
    music = mt4_mus;
    music_bpm = 128;
    music_loops = false;
    music_ignore_bpm = false;
    control_style = build_control_style(["arrows", "spacebar"]);
    screen_w = 480;
    screen_h = 270;
    metascript_init = mt4_metascript_init;
    metascript_start = mt4_metascript_start;
    metascript_tick_before = mt4_metascript_tick_before;
    metascript_tick_after = metascript_blank;
    metascript_draw_before = mt4_metascript_draw_before;
    metascript_draw_after = metascript_blank;
    metascript_cleanup = mt4_metascript_cleanup;
    define_object("player", 
    {
        init: mt4scr_player_init,
        tick: mt4scr_player_tick,
        draw: mt4scr_player_draw
    });
    define_object("nyte", 
    {
        init: mt4scr_nyte_init,
        tick: mt4scr_nyte_tick,
        draw: mt4scr_nyte_draw
    });
    define_object("wall", 
    {
        init: mt4scr_wall_init,
        tick: mt4scr_wall_tick,
        draw: mt4scr_wall_draw
    });
}

function mt4_metascript_start()
{
    player.move_sound = sfx_play(mt4_snd_move, false, 0);
}

function mt4_metascript_init()
{
    var _psx = 240;
    var _psy = 200;
    var _dir = random(360);
    var _len = random_range(70, 80);
    var _px = _psx + lengthdir_x(_len, _dir);
    var _py = _psy + (lengthdir_y(_len, _dir) / 2);
    _len = 60;
    var _nx = _psx + lengthdir_x(_len, _dir + 180);
    var _ny = _psy + (lengthdir_y(_len, _dir + 180) / 2);
    player = create_object("player", 
    {
        x: _px,
        y: _py
    });
    nyte = create_object("nyte", 
    {
        x: _nx,
        y: _ny
    });
    wall = [];
    array_push(wall, create_object("wall", 
    {
        x: 43,
        y: 151,
        image_angle: 13,
        image_xscale: 50
    }), create_object("wall", 
    {
        x: 347,
        y: 154,
        image_angle: -15,
        image_xscale: 50
    }), create_object("wall", 
    {
        x: 322,
        y: 259,
        image_angle: 13,
        image_xscale: 50
    }), create_object("wall", 
    {
        x: 58,
        y: 239,
        image_angle: -15,
        image_xscale: 50
    }), create_object("wall", 
    {
        x: 0,
        y: 135,
        image_angle: 0,
        image_yscale: 50
    }));
    caught = false;
}

function mt4_metascript_tick_before()
{
    if (caught)
    {
        game_win();
    }
}

function mt4_metascript_draw_before()
{
    draw_clear(c_black);
    draw_sprite(mt4_spr_bg, 0, 240, 135);
    draw_sprite(mt4_spr_pandora_eyes, 0, 240 + ((player.x - 240) / 40), 135 + ((player.y - 200) / 30) + 4);
}

function mt4_metascript_cleanup()
{
}

function mt4scr_player_init()
{
    sprite_index = mt4_spr_shadow;
    sharky = y;
    sharkvsp = 0;
    grv = 0.2 * get_game_speed();
    sharkjumpheight = -6 * (0.5 + (get_game_speed() / 2));
    offset = 0;
    hsp = 0;
    vsp = 0;
    xwalkspd = 0;
    xmaxwalkspd = 2.5;
    ywalkspd = 0;
    ymaxwalkspd = 2.5;
    acel = 0.1;
    decel = 0.3;
    aimside = 1;
    attemptcatch = false;
    play_bite_sound = true;
    bodysurf = -1;
    headsurf = -1;
    game = get_meta_object();
    move_sound = -1;
    width = 90;
    height = 34;
    collision_points = [];
    collision_instance = create_collision_instance();
}

function mt4scr_player_tick()
{
    var _input = get_input();
    if (!attemptcatch)
    {
        var _spd = get_game_speed();
        var movex = _input.key.right - _input.key.left;
        if (movex != 0)
        {
            xwalkspd = lerp(xwalkspd, xmaxwalkspd * movex, acel * _spd);
        }
        else
        {
            xwalkspd = lerp(xwalkspd, 0, decel * _spd);
        }
        hsp = xwalkspd;
        var movey = _input.key.down - _input.key.up;
        if (movey != 0)
        {
            ywalkspd = lerp(ywalkspd, ymaxwalkspd * movey, acel * _spd);
        }
        else
        {
            ywalkspd = lerp(ywalkspd, 0, decel * _spd);
        }
        vsp = ywalkspd;
        move_and_slide(collision_instance, hsp * _spd, vsp * _spd);
    }
    if (move_sound != -1)
    {
        var _sp = clamp(point_distance(0, 0, hsp, vsp) / point_distance(0, 0, xmaxwalkspd, ymaxwalkspd), 0, 1);
        if (attemptcatch)
        {
            _sp = 0;
        }
        audio_sound_gain(move_sound, _sp, 0);
    }
    if (_input.key.space_press && !attemptcatch && get_win_state() == 0)
    {
        attemptcatch = true;
        play_bite_sound = true;
        sfx_play(mt4_snd_lunge, false, 2, 0, 1, 0, 
        {
            x: x,
            y: y,
            z: 0
        });
        sharky = sprite_get_height(mt4_spr_shark) * 2;
        sharkvsp = sharkjumpheight;
        if (collide_obj_fast(self, x, y, game.nyte, game.nyte.x, game.nyte.y))
        {
            game.caught = true;
        }
    }
    if (attemptcatch)
    {
        var prev_vsp = sharkvsp;
        sharkvsp += grv;
        sharky += sharkvsp;
        if (prev_vsp <= 0 && sharkvsp >= 0 && play_bite_sound)
        {
            play_bite_sound = false;
            if (game.caught)
            {
                sfx_play(mt4_snd_bite_win, false, 1, 0, 1, 0, 
                {
                    x: x,
                    y: y,
                    z: 0
                });
            }
            else
            {
                sfx_play(mt4_snd_bite_fail, false, 1, 0, 1, 0, 
                {
                    x: x,
                    y: y,
                    z: 0
                });
            }
        }
        sprite_index = mt4_spr_shadow_hit;
        if ((sharky - sprite_get_height(mt4_spr_shark)) > y && sign(sharkvsp) == 1)
        {
            attemptcatch = false;
            sharkvsp = 0;
            sharky = -100;
        }
    }
    else
    {
        sprite_index = mt4_spr_shadow;
    }
}

function mt4scr_player_draw()
{
    _draw_self();
    var _n = game.nyte;
    if (!surface_exists(bodysurf))
    {
        bodysurf = surface_create(480, 270);
    }
    if (!surface_exists(headsurf))
    {
        headsurf = surface_create(480, 270);
    }
    if (attemptcatch)
    {
        surface_set_target(bodysurf);
        draw_clear_alpha(c_white, 0);
        if (game.caught)
        {
            draw_sprite_ext(_n.sprite_index, _n.image_index, _n.x, (_n.y - (y - 270)) + _n.yoffset, _n.image_xscale * _n.scale, _n.image_yscale * _n.scale, 0, c_white, _n.image_alpha);
            offset = x - _n.x;
        }
        if (sharkvsp < 0)
        {
            draw_sprite(mt4_spr_shark, 0, x - offset, sharky);
        }
        else
        {
            draw_sprite(mt4_spr_shark_close, 0, x - offset, sharky);
        }
        surface_reset_target();
        surface_set_target(headsurf);
        draw_clear_alpha(c_white, 0);
        draw_sprite(mt4_spr_shark_mouth, 0, x - offset, sharky);
        surface_reset_target();
    }
    var bottom_dither_pixels = 4;
    var sf_w = surface_get_width(headsurf);
    var sf_h = surface_get_height(headsurf);
    if (sharkvsp < 0 && attemptcatch)
    {
        draw_surface_part(headsurf, 0, 0, sf_w, sf_h - bottom_dither_pixels, 0, y - 270);
        shader_set_ditherfade(0.5, surface_get_texture(headsurf));
        draw_surface_part(headsurf, 0, sf_h - bottom_dither_pixels, sf_w, bottom_dither_pixels, 0, (y - 270) + (sf_h - bottom_dither_pixels));
        shader_reset();
    }
    if (_n.y < y && !game.caught)
    {
        draw_sprite_ext(_n.sprite_index, _n.image_index, _n.x, _n.y + _n.yoffset, _n.image_xscale, _n.image_yscale, 0, c_white, _n.image_alpha);
    }
    if (attemptcatch)
    {
        draw_surface_part(bodysurf, 0, 0, sf_w, sf_h - bottom_dither_pixels, 0, y - 270);
        shader_set_ditherfade(0.5, surface_get_texture(bodysurf));
        draw_surface_part(bodysurf, 0, sf_h - bottom_dither_pixels, sf_w, bottom_dither_pixels, 0, (y - 270) + (sf_h - bottom_dither_pixels));
        shader_reset();
    }
    if (_n.y >= y && !game.caught)
    {
        draw_sprite_ext(_n.sprite_index, _n.image_index, _n.x, _n.y + _n.yoffset, _n.image_xscale, _n.image_yscale, 0, c_white, _n.image_alpha);
    }
}

function mt4scr_nyte_init()
{
    sprite_index = mt4_spr_nyte;
    startx = -1;
    starty = -1;
    xprev = x;
    game = get_meta_object();
    timer = 0;
    yoffset = 0;
    scale = 1;
    prev_image_index = 0;
    sharkpeak = 0;
}

function mt4scr_nyte_tick()
{
    if (startx == -1)
    {
        startx = x;
        starty = y;
    }
    x = startx + ((sin(timer / 35) * 60) / get_game_speed());
    y = starty + ((sin(timer / 20) * 20) / get_game_speed());
    if (!game.caught)
    {
        if (floor(image_index) == 5 && floor(prev_image_index) == 4)
        {
            sfx_play(mt4_snd_flap, false, 1, 0, 1, 0, 
            {
                x: x,
                y: y,
                z: 0
            });
        }
        timer += (1 * get_game_speed());
        if (xprev < x)
        {
            image_xscale = -1;
        }
        else
        {
            image_xscale = 1;
        }
    }
    else
    {
        var s = game.player;
        if (s.sharkvsp >= 0)
        {
        }
        else
        {
            sharkpeak = s.sharky;
        }
    }
    if (game.player.sharkvsp > 0 && game.caught)
    {
        sprite_index = spr_none;
    }
    xprev = x;
    prev_image_index = image_index;
}

function mt4scr_nyte_draw()
{
}

function mt4scr_wall_init()
{
    sprite_index = mt4_spr_wall;
    image_alpha = 0.3;
    width = 10;
    height = 10;
    x1 = x;
    y1 = y;
    x2 = x;
    y2 = y;
    x3 = x;
    y3 = y;
    x4 = x;
    y4 = y;
    set = false;
}

function mt4scr_wall_tick()
{
    if (!set)
    {
        set = true;
        width = sprite_get_width(sprite_index) * image_xscale;
        height = sprite_get_height(sprite_index) * image_yscale;
        var a = image_angle;
        x1 = x + lengthdir_x(width / 2, a + 180) + lengthdir_x(height / 2, a + 90);
        y1 = y + lengthdir_y(width / 2, a + 180) + lengthdir_y(height / 2, a + 90);
        x2 = x + lengthdir_x(width / 2, a) + lengthdir_x(height / 2, a + 90);
        y2 = y + lengthdir_y(width / 2, a) + lengthdir_y(height / 2, a + 90);
        x3 = x + lengthdir_x(width / 2, a) + lengthdir_x(height / 2, a - 90);
        y3 = y + lengthdir_y(width / 2, a) + lengthdir_y(height / 2, a - 90);
        x4 = x + lengthdir_x(width / 2, a + 180) + lengthdir_x(height / 2, a - 90);
        y4 = y + lengthdir_y(width / 2, a + 180) + lengthdir_y(height / 2, a - 90);
        create_collision_instance();
    }
}

function mt4scr_wall_draw()
{
}

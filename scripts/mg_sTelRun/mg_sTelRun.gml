function mg_sTelRun() : minigame_constructor() constructor
{
    name = "Wire Run";
    prompt = "DODGE!";
    time_limit = 10;
    win_on_timeover = true;
    music = ms7_mus;
    music_bpm = 128;
    control_style = build_control_style(["dleft", "dright", "spacebar"]);
    metascript_init = ms7_metascript_init;
    metascript_start = ms7_metascript_start;
    metascript_tick_before = ms7_metascript_tick_before;
    metascript_draw_before = ms7_metascript_draw_before;
    metascript_draw_after = ms7_metascript_draw_after;
    define_object("dude", 
    {
        tick: ms7scr_guy_tick,
        draw: ms7scr_guy_draw
    }, 
    {
        sprite_index: ms7_spr_dude,
        x: 150,
        xstart: 150,
        y: 90,
        walksp: 3,
        grv: 0.44999999999999996,
        hsp: 0,
        vsp: 0,
        die: false,
        hitspr: 0,
        floorlevel: 60,
        deathx: 0,
        deathy: 0,
        shakeamt: 0
    });
    define_object("dude_afterimage", 
    {
        tick: ms7scr_dude_afterimage_tick,
        draw: ms7scr_dude_afterimage_draw
    }, 
    {
        sprite_index: ms7_spr_dude,
        startx: 0,
        image_blend: c_aqua
    });
    define_object("bird", 
    {
        tick: ms7scr_bird_tick
    }, 
    {
        sprite_index: ms7_spr_bird,
        i: 0
    });
}

function ms7_metascript_init()
{
    birdamt = 5;
    possiblepos = [450, 595, 740, 885, 1030];
    dude = create_object("dude");
    shake = 0;
    car_bump = 0;
    car_bump_time = room_speed * 2;
    pole_overlap = 13;
    start_scroll = 0;
    
    get_scroll = function()
    {
        return get_game_speed() * -get_current_frame() * 3;
    };
    
    floor_at_x = function(arg0)
    {
        arg0 -= get_scroll();
        var dip = 10;
        var down = abs(dsin(((arg0 + 45) / (sprite_get_width(ms7_spr_bg_pole) - pole_overlap)) * 180)) * dip;
        var wires_top = 111;
        return wires_top + down;
    };
}

function ms7_metascript_start()
{
    start_scroll = get_scroll();
    show_debug_message("start scroll: " + string(start_scroll));
    repeat (birdamt)
    {
        rand = irandom_range(0, array_length(possiblepos) - 1);
        create_object("bird", 
        {
            x: possiblepos[rand] - start_scroll
        });
    }
    create_object("bird", 
    {
        x: possiblepos[array_length(possiblepos) - 1] - start_scroll
    });
}

function ms7_metascript_tick_before()
{
    if (car_bump > 0)
    {
        car_bump -= 0.125;
    }
    car_bump_time--;
    if (car_bump_time <= 0)
    {
        car_bump = 2;
        car_bump_time = room_speed * 2;
    }
}

function ms7_metascript_draw_before()
{
    draw_clear(c_black);
    shader_set_wavy(ms7_spr_bg_sky, get_current_frame() / 10, 0.2, 100, 1, 0.5, 200, 3);
    draw_sprite(ms7_spr_bg_sky, 0, -get_current_frame() / 8, 0);
    shader_reset();
    shader_set_wavy(ms7_spr_bg_wavy, get_current_frame() / 120, 0.5, 2, 120, 0.7, 10, 30);
    blendmode_set_add();
    draw_sprite_ext(ms7_spr_bg_wavy, 0, 200 + (-get_current_frame() / 8), 100, 1, 1, 0, c_white, 0.9);
    blendmode_reset();
    shader_reset();
    shake -= 0.1;
    shake = clamp(shake, 0, 100);
    s = random_range(-shake, shake);
    var i = 0;
    while (i <= 1440)
    {
        draw_sprite_ext(ms7_spr_bg_trees, 0, (get_scroll() / 2) + i + s, 50, 1, 1, 0, c_white, 1);
        i += sprite_get_width(ms7_spr_bg_trees);
    }
    i = 0;
    while (i <= 4800)
    {
        draw_sprite_ext(ms7_spr_bg_pole, 0, ((get_scroll() + i) - 45) + s, 270, 1, 1, 0, c_white, 1);
        i += (sprite_get_width(ms7_spr_bg_pole) - pole_overlap);
    }
}

function ms7_metascript_draw_after()
{
    draw_sprite(ms7_spr_bg_car, 0, 0, clamp((-10 - car_bump) + s, -10, 10));
}

function ms7scr_guy_tick()
{
    var input = get_input();
    var ikey = input.key;
    var game = get_meta_object();
    if (!die)
    {
        var move = ikey.right - ikey.left;
        hsp = move * walksp;
        x += hsp;
        y += (vsp * get_game_speed());
        vsp += (grv * get_game_speed());
        x = clamp(x, 150, 380);
        if (y < floorlevel)
        {
            sprite_index = ms7_spr_dude_jump;
            image_angle -= 10;
        }
        else
        {
            sprite_index = ms7_spr_dude;
            image_angle = 0;
        }
        floorlevel = game.floor_at_x(x) - 23;
        if (y > floorlevel)
        {
            y = floorlevel;
            if (ikey.space_press)
            {
                vsp = -7.5;
                sfx_play(ms7_snd_jump);
            }
        }
        var aft = create_object("dude_afterimage", 
        {
            x: x,
            y: y,
            startx: x,
            sprite_index: sprite_index,
            image_index: image_index,
            image_angle: image_angle,
            image_speed: 0
        });
        aft.startx += x + (get_game_speed() * -get_current_frame() * 2);
    }
    else if (hitspr > 0)
    {
        sprite_index = ms7_spr_dude_trip;
        hitspr--;
        shakeamt = lerp(shakeamt, 0, 0.05);
        shakeamt = 0;
        x = deathx + random_range(-shakeamt, shakeamt);
        y = deathy + random_range(-shakeamt, shakeamt);
    }
    else
    {
        sprite_index = ms7_spr_dude_fall;
        y += vsp;
        vsp += (grv / 2);
        image_angle += 5;
    }
}

function ms7scr_guy_draw()
{
    var game = get_meta_object();
    draw_sprite_ext(sprite_index, image_index, x + game.s, y + game.s, image_xscale, image_yscale, image_angle, c_white, 1);
    if (!die)
    {
        if (y >= floorlevel)
        {
            draw_sprite(ms7_spr_spark, get_current_frame() / 2, x - 12, y + 20);
        }
    }
}

function ms7scr_dude_afterimage_tick()
{
    x -= (get_game_speed() * 4);
    if (image_alpha <= 0)
    {
        destroy_object();
    }
    image_alpha -= (0.15 * get_game_speed());
}

function ms7scr_dude_afterimage_draw()
{
    _draw_self();
}

function ms7scr_bird_tick()
{
    var game = get_meta_object();
    if (i == 1)
    {
        start = x;
    }
    i++;
    if (i > 1)
    {
        x = (start + game.get_scroll()) - 45;
        y = game.floor_at_x(x);
    }
    if (!game.dude.die)
    {
        if (collide_obj_fast(self, x, y, game.dude, game.dude.x, game.dude.y))
        {
            game.dude.die = true;
            game.dude.vsp = -3;
            game.dude.hitspr = 10;
            game.dude.deathx = game.dude.x;
            game.dude.deathy = game.dude.y;
            game.shake = 5;
            game_lose();
        }
    }
}

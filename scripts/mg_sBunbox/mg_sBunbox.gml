function mg_sBunbox() : minigame_constructor() constructor
{
    name = "Bunny Boxes";
    prompt = "SORT!";
    time_limit = 16;
    music = ms3_mus;
    music_bpm = 128;
    control_style = build_control_style(["cmove", "cclick"]);
    metascript_init = ms3_metascript_init;
    metascript_draw_before = ms3_metascript_draw_before;
    define_object("hand", 
    {
        init: ms3scr_hand_init,
        tick: ms3scr_hand_tick
    });
    define_object("bunny", 
    {
        init: ms3scr_bunny_init,
        tick: ms3scr_bunny_tick
    });
    define_object("heart", 
    {
        init: ms3scr_heart_init,
        tick: ms3scr_heart_tick
    });
    define_object("box", 
    {
        tick: ms3scr_box_tick,
        draw: ms3scr_box_draw
    }, 
    {
        sprite_index: ms3_spr_bluebox,
        color: "blue",
        y: 241.5,
        depth: 2
    });
}

function ms3_metascript_init()
{
    boxside = choose(1, 2);
    if (boxside == 1)
    {
        bluebox = create_object("box", 
        {
            x: 67.5,
            color: "blue",
            sprite_index: ms3_spr_bluebox,
            xscale: 1
        });
        pinkbox = create_object("box", 
        {
            x: 408,
            color: "pink",
            sprite_index: ms3_spr_pinkbox,
            xscale: 1
        });
    }
    else
    {
        bluebox = create_object("box", 
        {
            x: 408,
            color: "blue",
            sprite_index: ms3_spr_bluebox,
            xscale: -1
        });
        pinkbox = create_object("box", 
        {
            x: 67.5,
            color: "pink",
            sprite_index: ms3_spr_pinkbox,
            xscale: -1
        });
    }
    hand = create_object("hand");
    bunny_count = 3 + floor(get_game_difficulty() / 2);
    buns_sorted = 0;
    bunnies = [];
    var blue_bunny_count = clamp(round(bunny_count / random_range(1.75, 2.25)), 1, bunny_count - 1);
    colors = [];
    for (var i = 0; i < bunny_count; i++)
    {
        if (i < blue_bunny_count)
        {
            array_push(colors, "blue");
        }
        else
        {
            array_push(colors, "pink");
        }
    }
    var bun_spacing = 45 / (bunny_count / 3);
    for (var i = 0; i < bunny_count; i++)
    {
        array_shuffle_ext(colors);
        var buncol = colors[0];
        array_delete(colors, 0, 1);
        var bunx = 115 + ((90 / (bunny_count - 1)) * i);
        bunx *= 1.5;
        array_push(bunnies, create_object("bunny", 
        {
            x: bunx,
            y: 222,
            color: buncol
        }));
    }
}

function ms3_metascript_draw_before()
{
    draw_sprite(ms3_spr_bg, 0, 240, 135);
}

function ms3scr_hand_init()
{
    sprite_index = ms3_spr_hand_open;
    holding_inst = -1;
    depth = -2;
    var input = get_input();
    var imouse = input.mouse;
    prev_mouse_x = imouse.x;
    prev_mouse_y = imouse.y;
    won = false;
    bun_a = 180;
    bun_av = 0;
    camx = 0;
    camy = 0;
    hsnd = -1;
}

function ms3scr_hand_tick()
{
    var input = get_input();
    var imouse = input.mouse;
    var game = get_meta_object();
    x = imouse.x;
    y = imouse.y;
    camera_apply(cam2d_get_view());
    sprite_index = ms3_spr_hand_open;
    if (imouse.click)
    {
        sprite_index = ms3_spr_hand_pinch;
    }
    if (won)
    {
        sprite_index = ms3_spr_hand_thumbsup;
    }
    else
    {
        if (imouse.click_press)
        {
            var buns = game.bunnies;
            var closest_dist = infinity;
            var closest_dist_inst = -1;
            for (var i = 0; i < array_length(buns); i++)
            {
                var bun = buns[i];
                var _dist = point_distance(bun.x, bun.y, x, y);
                if (_dist < 45 && y < (bun.y + 30) && _dist < closest_dist)
                {
                    closest_dist_inst = bun;
                    closest_dist = _dist;
                }
            }
            if (closest_dist_inst != -1)
            {
                closest_dist_inst.state = 1;
                holding_inst = closest_dist_inst;
                holding_inst.depth = -1;
                hsnd = sfx_play(ms3_snd_wiggle, true);
                update_draw_order();
            }
        }
        if (holding_inst != -1)
        {
            if (imouse.click)
            {
                holding_inst.x = x;
                holding_inst.y = y;
                var bun_ag = 180 + (((prev_mouse_x - imouse.x) + (prev_mouse_y - imouse.y)) * 5);
                bun_av += ((((bun_ag - bun_a) * 0.5) - bun_av) * 0.3);
                bun_a += bun_av;
                holding_inst.image_angle = bun_a - 180;
                audio_sound_pitch(hsnd, 1 + (bun_av / 180));
            }
            else
            {
                audio_stop_sound(hsnd);
                holding_inst.state = 2;
                holding_inst.image_angle = 0;
                holding_inst.depth = 0;
                update_draw_order();
                holding_inst = -1;
                bun_a = 180;
                bun_av = 0;
            }
        }
    }
    prev_mouse_x = imouse.x;
    prev_mouse_y = imouse.y;
    var camnudge = 0.05;
    camx = lerp(camx, (imouse.x - 240) * camnudge, 0.1);
    camy = lerp(camy, (imouse.y - 135) * camnudge, 0.1);
    camera_set_view_pos(cam2d_get_view(), round(camx), round(camy));
}

function ms3scr_bunny_init()
{
    sprite_index = ms3_spr_blueidle;
    color = "blue";
    state = 0;
    floor_y = 222;
}

function ms3scr_bunny_tick()
{
    var game = get_meta_object();
    var sprprefix = "ms3_spr_" + color;
    switch (state)
    {
        case 0:
            sprite_index = asset_get_index(sprprefix + "idle");
            break;
        case 1:
            sprite_index = asset_get_index(sprprefix + "pickup");
            break;
        case 2:
            sprite_index = asset_get_index(sprprefix + "fall");
            y += (4.5 * max(1, get_game_speed()));
            if ((x < 142.5 || x > 337.5) && y > 162)
            {
                var side = sign(x - 240) * game.bluebox.xscale;
                var box_inst = -1;
                switch (side)
                {
                    case -1:
                        box_inst = game.bluebox;
                        break;
                    case 1:
                        box_inst = game.pinkbox;
                        break;
                }
                with (box_inst)
                {
                    image_yscale = 0.7;
                }
                if (color == box_inst.color)
                {
                    repeat (3)
                    {
                        create_object("heart", 
                        {
                            x: x,
                            y: y
                        });
                    }
                    with (game)
                    {
                        buns_sorted++;
                        sfx_play(ms3_snd_deposit);
                        if (buns_sorted == bunny_count)
                        {
                            game_win();
                            hand.won = true;
                        }
                    }
                }
                else
                {
                    sfx_play(ms3_snd_wrong);
                    box_inst.sprite_index = asset_get_index("ms3_spr_" + box_inst.color + "boxfail");
                    game_lose();
                }
                x = -105;
                state = 3;
            }
            if (y >= floor_y && state == 2)
            {
                state = 0;
            }
            break;
    }
    y = min(y, floor_y);
}

function ms3scr_box_tick()
{
    image_yscale += ((1 - image_yscale) * 0.3);
    image_xscale = (1 / image_yscale) * xscale;
}

function ms3scr_box_draw()
{
    gpu_set_blendmode_multiply();
    switch (color)
    {
        case "blue":
            var drawx = x + (16 * image_xscale);
            var drawy = y + -6;
            draw_sprite_ext(ms3_spr_blueshadowmultiply, 0, drawx, drawy, image_xscale, image_yscale, 0, c_white, 1);
            break;
        case "pink":
            var drawx = x + (-62 * image_xscale);
            var drawy = y + -6;
            draw_sprite_ext(ms3_spr_pinkshadowmultiply, 0, drawx, drawy, image_xscale, image_yscale, 0, c_white, 1);
            break;
    }
    gpu_set_blendmode(bm_normal);
    _draw_self();
}

function ms3scr_heart_init()
{
    sprite_index = ms3_spr_singleheart;
    hsp = random_range(-2, 2);
    vsp = random_range(-2, -4);
    grv = 0.2;
    maxlife = 60;
    life = maxlife;
}

function ms3scr_heart_tick()
{
    life--;
    if (life <= 0)
    {
        destroy_object();
    }
    x += hsp;
    y += vsp;
    vsp += grv;
    image_alpha = life / maxlife;
}

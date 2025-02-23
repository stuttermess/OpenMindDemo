function mg_sBrush() : minigame_constructor() constructor
{
    name = "Hairbrush";
    prompt = "BRUSH!";
    time_limit = 8;
    music = ms2_mus;
    music_bpm = 128;
    control_style = build_control_style(["cmove"]);
    screen_w = 480;
    screen_h = 270;
    metascript_init = ms2_metascript_init;
    metascript_draw_before = ms2_metascript_draw_before;
    metascript_draw_after = ms2_metascript_draw_after;
    define_object("girl", 
    {
        tick: ms2scr_girl_tick
    }, 
    {
        x: 480,
        y: 0,
        sprite_index: ms2_spr_girl
    });
    define_object("hair", 
    {
        init: ms2scr_hair_init,
        draw: ms2scr_hair_draw
    });
    define_object("brush", 
    {
        init: ms2scr_brush_init,
        tick: ms2scr_brush_tick
    });
    define_object("sparkle", 
    {
        init: ms2scr_sparkle_init,
        tick: ms2scr_sparkle_tick,
        draw: ms2scr_sparkle_draw
    });
    define_object("sparkles", {}, 
    {
        x: 222,
        y: 154.5,
        sprite_index: ms2_spr_sparkles
    });
    define_object("hitbox", {}, 
    {
        sprite_index: ms2_spr_hitbox,
        image_alpha: 0
    });
    define_object("hitbox2", {}, 
    {
        sprite_index: ms2_spr_hitbox2,
        image_alpha: 0
    });
    define_object("animal", 
    {
        tick: ms2scr_animal_tick
    }, 
    {
        animal: 0,
        animalset: 0
    });
}

function ms2_metascript_init()
{
    girl = create_object("girl");
    hair = create_object("hair");
    brush = create_object("brush");
    hitbox1 = create_object("hitbox", 
    {
        x: 248,
        y: 75
    });
    hitbox2 = create_object("hitbox2", 
    {
        x: 323,
        y: 120
    });
}

function ms2_metascript_draw_before()
{
    draw_clear(c_white);
}

function ms2_metascript_draw_after()
{
    gpu_set_blendmode_multiply();
    draw_sprite(ms2_spr_overlay, 0, 0, 0);
    gpu_set_blendmode(bm_normal);
}

function ms2scr_girl_tick()
{
    if (get_win_state() == -1)
    {
        sprite_index = ms2_spr_girllose;
    }
}

function ms2scr_hair_init()
{
    x = 258;
    y = 92;
    sprite_index = ms2_spr_hair;
    image_speed = 0;
    depth = -1;
    xsk = 0;
    ysk = 0;
    xscale = 1;
    yscale = 1;
}

function ms2scr_hair_draw()
{
    draw_sprite_skew_ext(sprite_index, image_index, x, y, 1, 1, 0, -1, 1, xsk, ysk);
}

function ms2scr_brush_init()
{
    sprite_index = ms2_spr_brush;
    prev_mouse_x = 0;
    prev_y = 0;
    depth = -2;
    brush_dir = 0;
    brush_spd = 0;
    brushed = 0;
    brushing = false;
    springspdy = 0;
    springspdx = 0;
    brush_snd = -1;
}

function ms2scr_brush_tick()
{
    var input = get_input();
    var imouse = input.mouse;
    var game = get_meta_object();
    x = imouse.x * 1;
    y = imouse.y * 1;
    hitb1 = collide_obj_fast(self, x, y, game.hitbox1, game.hitbox1.x, game.hitbox1.y);
    hitb2 = collide_obj_fast(self, x, y, game.hitbox2, game.hitbox2.x, game.hitbox2.y);
    var startbrush = brushing;
    if (!brushing)
    {
        var _springy = spring(game.hair.ysk, springspdy, 1, 0.2, 0.3);
        game.hair.ysk = _springy[0];
        springspdy = _springy[1];
        var _springx = spring(game.hair.xsk, springspdx, 1, 0.2, 0.3);
        game.hair.xsk = _springx[0];
        springspdx = _springx[1];
    }
    if (hitb1 || hitb2)
    {
        if (!startbrush && get_win_state() == 0)
        {
        }
        brushing = true;
    }
    if (get_win_state() == 0)
    {
        if (point_distance(game.hair.x, game.hair.y, imouse.x, imouse.y) > 130)
        {
            if (brushing)
            {
                brushing = false;
                brush_snd = sfx_play(ms2_snd_brush);
                audio_sound_pitch(brush_snd, 1 + (game.hair.image_index * 0.07));
                game.hair.image_index++;
                repeat (random_range(3, 5))
                {
                    create_object("sparkle", 
                    {
                        x: game.hair.x - 20,
                        y: game.hair.y + 20
                    });
                }
            }
        }
    }
    if (brushing && get_win_state() == 0)
    {
        if (imouse.y >= game.hair.y)
        {
            game.hair.ysk = (game.hair.y - imouse.y) / 1.8;
            if (imouse.x <= (game.hair.x + 50))
            {
                game.hair.xsk = (game.hair.x - imouse.x) / 1.8;
            }
        }
    }
    else
    {
        var _springy = spring(game.hair.ysk, springspdy, 1, 0.2, 0.3);
        game.hair.ysk = _springy[0];
        springspdy = _springy[1];
        var _springx = spring(game.hair.xsk, springspdx, 1, 0.2, 0.3);
        game.hair.xsk = _springx[0];
        springspdx = _springx[1];
    }
    if (game.hair.image_index >= (sprite_get_number(game.hair.sprite_index) - 1))
    {
        if (get_win_state() == 0)
        {
            game_win();
            sfx_play(ms2_snd_sparkle, false);
            create_object("sparkles");
            for (var i = 0; i < 3; i++)
            {
                create_object("animal", 
                {
                    animal: i
                });
            }
        }
    }
    if (get_win_state() == 1)
    {
        brushing = 0;
        image_index = 3;
    }
    prev_mouse_x = imouse.x;
    prev_y = imouse.y;
}

function ms2scr_animal_tick()
{
    if (!animalset)
    {
        animalset = true;
        switch (animal)
        {
            case 0:
            default:
                sprite_index = ms2_spr_cat;
                x = 76.5;
                y = 36;
                break;
            case 1:
                sprite_index = ms2_spr_dog;
                x = 187.5;
                y = 39;
                break;
            case 2:
                sprite_index = ms2_spr_bun;
                x = 66;
                y = 220.5;
                break;
        }
    }
    image_index += (sprite_get_speed(sprite_index) / room_speed);
    image_index %= sprite_get_number(sprite_index);
}

function ms2scr_sparkle_init()
{
    spd = random_range(3, 7);
    dir = random_range(300, 200);
    maxlife = 40;
    life = maxlife;
    alpha = 1;
    sprite_index = choose(ms2_spr_sparkle_1, ms2_spr_sparkle_2, ms2_spr_sparkle_3);
    depth = -100;
    update_draw_order();
}

function ms2scr_sparkle_tick()
{
    x += lengthdir_x(spd, dir);
    y += lengthdir_y(spd, dir);
    spd = lerp(spd, 0, 0.04);
    alpha = (abs(life - maxlife) / maxlife) - 0.1;
    life--;
    if (life <= 0)
    {
        destroy_object();
    }
}

function ms2scr_sparkle_draw()
{
    shader_set_ditherfade(alpha, sprite_get_texture(sprite_index, image_index));
    _draw_self();
    shader_reset();
}

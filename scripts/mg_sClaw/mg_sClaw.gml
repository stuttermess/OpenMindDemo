function mg_sClaw() : minigame_constructor() constructor
{
    name = "Claw Machine";
    prompt = "GRAB!";
    time_limit = 8;
    music = ms6_mus;
    music_bpm = 128;
    control_style = build_control_style(["spacebar"]);
    metascript_init = ms6_metascript_init;
    metascript_draw_before = ms6_metascript_draw_before;
    metascript_draw_after = ms6_metascript_draw_after;
    metascript_cleanup = ms6_metascript_cleanup;
    define_object("claw", 
    {
        tick: ms6scr_claw_tick,
        draw: ms6scr_claw_draw
    }, 
    {
        claw_close: 0,
        xv: 3,
        grabbing: 0,
        toy_grabbed: -1,
        toygrabbed_diffy: 0
    });
    define_object("toy", {}, 
    {
        toy: "bear"
    });
}

function ms6_metascript_init()
{
    claw_side = choose(-1, 1);
    var claw_x = 75;
    if (claw_side == 1)
    {
        claw_x = 480 - claw_x;
    }
    claw = create_object("claw", 
    {
        x: claw_x,
        y: 40.5
    });
    claw.xv *= -claw_side;
    var toy_x;
    if (claw_side == 1)
    {
        toy_x = random_range(180, 297);
    }
    else
    {
        toy_x = random_range(183, 300);
    }
    toy = create_object("toy", 
    {
        x: toy_x,
        y: 178.5
    });
    toy.toy = choose("bear", "rabbit", "creature");
    with (toy)
    {
        switch (toy)
        {
            case "bear":
            default:
                sprite_index = ms6_spr_bear;
                break;
            case "creature":
                sprite_index = ms6_spr_creature;
                break;
            case "rabbit":
                sprite_index = ms6_spr_rabbit;
                break;
        }
    }
    var girlspr = ms6_spr_her;
    girl_sf1 = surface_create(sprite_get_width(girlspr), sprite_get_height(girlspr));
    girl_sf2 = surface_create(sprite_get_width(girlspr), sprite_get_height(girlspr));
}

function ms6_metascript_draw_before()
{
    draw_sprite(ms6_spr_inside_bg, 0, 0, 0);
    draw_sprite(ms6_spr_bgtoys, 0, 0, 0);
}

function ms6_metascript_draw_after()
{
    draw_sprite(ms6_spr_misctoys, 0, 0, 0);
    gpu_set_blendmode_multiply();
    draw_sprite(ms6_spr_MULTsideshadow, 0, 0, 0);
    gpu_set_blendmode(bm_normal);
    draw_sprite(ms6_spr_whitereflect, 0, 0, 0);
    draw_sprite(ms6_spr_window, 0, 0, 0);
    if (!surface_exists(girl_sf1))
    {
        var girlspr = ms6_spr_her;
        girl_sf1 = surface_create(sprite_get_width(girlspr), sprite_get_height(girlspr));
    }
    if (!surface_exists(girl_sf2))
    {
        var girlspr = ms6_spr_her;
        girl_sf2 = surface_create(sprite_get_width(girlspr), sprite_get_height(girlspr));
    }
    var thissf = surface_get_target();
    surface_reset_target();
    surface_set_target(girl_sf1);
    var eyex = ((claw.x - 240) / 165) * 4;
    var eyey = ((claw.y - 40.5) / 94.5) * 3.1;
    draw_sprite_ext(ms6_spr_whiteeyes, 0, 85.5, 73.5, 1, 1, 0, c_white, 1);
    gpu_set_tex_filter(true);
    draw_sprite_ext(ms6_spr_pupils, 0, 85.5 + eyex, 73.5 + eyey, 1, 1, 0, c_white, 1);
    gpu_set_tex_filter(false);
    draw_sprite_ext(ms6_spr_her, 0, 0, 0, 1, 1, 0, c_white, 1);
    surface_reset_target();
    surface_set_target(girl_sf2);
    draw_clear(c_white);
    draw_surface_ext(girl_sf1, 0, 0, 1, 1, 0, c_white, 0.5);
    surface_reset_target();
    surface_set_target(thissf);
    gpu_set_blendmode_multiply();
    draw_surface_ext(girl_sf2, 240 - (surface_get_width(girl_sf2) / 2), 67.5, 1, 1, 0, c_white, 1);
    gpu_set_blendmode(bm_normal);
    draw_sprite(ms6_spr_bg, 1, 0, 0);
}

function ms6_metascript_cleanup()
{
    surface_free(girl_sf1);
    surface_free(girl_sf2);
}

function ms6scr_claw_tick()
{
    var input = get_input();
    var ikey = input.key;
    var game = get_meta_object();
    var spd = max(1.1, 1.1 * get_game_speed());
    switch (floor(grabbing))
    {
        case 0:
            if (ikey.space_press)
            {
                grabbing = 1;
            }
            x += (xv * spd);
            if (x > 405 || x < 75)
            {
                xv *= -1;
                x = clamp(x, 75, 405);
            }
            break;
        case 1:
            if (y < 127.5)
            {
                claw_close -= (0.5 * spd);
                y += (2 * spd * 1.5);
            }
            else
            {
                claw_close += (1 * spd);
                if (claw_close >= 14)
                {
                    grabbing = 2;
                    if (point_distance(x, 0, game.toy.x, 0) < 37.5)
                    {
                        toy_grabbed = game.toy;
                        toygrabbed_diffy = toy_grabbed.y - y;
                        sfx_play(ms6_snd_squeak);
                        game_win();
                    }
                    else
                    {
                        game_lose();
                    }
                }
            }
            break;
        case 2:
            grabbing += ((1 / (room_speed * 0.1)) * spd);
            claw_close += (0.25 * spd);
            break;
        case 3:
            y -= (1 * spd * 1.5);
            if (toy_grabbed != -1)
            {
                toy_grabbed.x += (x - toy_grabbed.x) * (0.15 * spd);
                toy_grabbed.y = y + toygrabbed_diffy;
            }
            break;
    }
    if (grabbing != 0 && point_distance(x, 0, game.toy.x, 0) < 22.5 && y > 90 && get_time() < 0.5)
    {
        game_win();
    }
    y = clamp(y, 40.5, 135);
    claw_close = clamp(claw_close, -16, 29);
}

function ms6scr_claw_draw()
{
    var string_stretch = 0;
    draw_sprite_ext(ms6_spr_string, 0, x, y - 30, 1, 1 + string_stretch, 0, c_white, 1);
    draw_sprite(ms6_spr_metal_thing, 0, x, y - 15);
    draw_sprite_ext(ms6_spr_clawL, 0, x, y, 1, 1, claw_close, c_white, 1);
    draw_sprite_ext(ms6_spr_clawR, 0, x, y, 1, 1, -claw_close, c_white, 1);
    draw_sprite(ms6_spr_heart_piece, 0, x, y);
}

function mg_sChao() : minigame_constructor() constructor
{
    name = "Skrunkly Garden";
    prompt = "CARE!";
    time_limit = 16;
    music = ms1_mus;
    music_bpm = 128;
    control_style = build_control_style(["cmove", "cclick"]);
    metascript_init = ms1_metascript_init;
    metascript_draw_before = ms1_metascript_draw_before;
    metascript_draw_after = ms1_metascript_draw_after;
    define_object("skrunkly", 
    {
        init: ms1scr_skrunkly_init,
        tick: ms1scr_skrunkly_tick,
        draw: ms1scr_skrunkly_draw
    });
    define_object("item", 
    {
        init: ms1scr_item_init,
        tick: ms1scr_item_tick,
        draw: ms1scr_item_draw
    });
    define_object("hand", 
    {
        init: ms1scr_hand_init,
        tick: ms1scr_hand_tick
    });
}

function ms1_metascript_init()
{
    skrunks = [];
    skrunks_happy = 0;
    skrunk_amount = choose(1, 2);
    if (get_game_difficulty() >= 2 && get_game_speed() < 1.5)
    {
        skrunk_amount = choose(2, 3);
    }
    var positions = [[95, 91], [169, 70], [25, 123]];
    var wants = ["food", "water", "fun"];
    array_shuffle_ext(positions);
    array_shuffle_ext(wants);
    for (var i = 0; i < skrunk_amount; i++)
    {
        var spx = (320 - positions[i][0]) + 80;
        var spy = positions[i][1] + 45;
        var spw = wants[i];
        array_push(skrunks, create_object("skrunkly", 
        {
            x: spx,
            y: spy,
            want: spw
        }));
    }
    create_object("item", 
    {
        y: 128,
        item: "food"
    });
    create_object("item", 
    {
        y: 165,
        item: "water"
    });
    create_object("item", 
    {
        y: 202,
        item: "fun"
    });
    create_object("hand", 
    {
        x: 0,
        y: 0
    });
}

function ms1_metascript_draw_before()
{
    draw_clear(#562350);
    draw_sprite(ms1_spr_bg, 0, 80, 45);
}

function ms1_metascript_draw_after()
{
    var _sf = surface_create(get_screen_width(), get_screen_height());
    var targ = surface_get_target();
    surface_reset_target();
    surface_set_target(_sf);
    draw_sprite(ms1_spr_multiplyscreenoverlay, 0, 0, 0);
    draw_sprite(ms1_spr_multiplylcd, 0, get_screen_width() / 2, get_screen_height() / 2);
    surface_reset_target();
    surface_set_target(targ);
    gpu_set_blendmode_multiply();
    draw_surface(_sf, 0, 0);
    surface_free(_sf);
    gpu_set_blendmode(bm_normal);
    draw_sprite(ms1_spr_handheld, 0, 0, 0);
    gpu_set_blendmode_multiply();
    draw_sprite(ms1_spr_multiplyhandheldshade, 0, 0, 0);
    gpu_set_blendmode(bm_normal);
}

function ms1scr_skrunkly_init()
{
    x = 0;
    y = 0;
    sprite_index = ms1_spr_skrunkly_body;
    image_index = 0;
    bublsubimg = 0;
    happy = 0;
    want = "food";
    senseoff_y = -15;
    sense_x = [0];
    sense_y = [0];
    heart_up = 0;
    bubdir = choose(-1, 1);
}

function ms1scr_skrunkly_tick()
{
    sense_x[0] = x;
    sense_y[0] = y + senseoff_y;
    sense_x[1] = x + (30 * bubdir);
    sense_y[1] = y - 42;
    bublsubimg += (sprite_get_speed(ms1_spr_askfood) / room_speed);
    bublsubimg %= sprite_get_number(ms1_spr_askfood);
    if (happy)
    {
        heart_up += ((1 - heart_up) * 0.1);
        switch (want)
        {
            case "food":
                sprite_index = ms1_spr_skrunkly_eat;
                break;
            case "water":
                sprite_index = ms1_spr_skrunkly_drinking;
                break;
            case "fun":
                sprite_index = ms1_spr_skrunkly_holdbear;
                break;
        }
    }
}

function ms1scr_skrunkly_draw()
{
    if (get_win_state() == -1 && !happy)
    {
        sprite_index = ms1_spr_tomb;
    }
    switch (sprite_index)
    {
        default:
            _draw_self();
            break;
        case ms1_spr_skrunkly_body:
            _draw_self();
            draw_sprite(ms1_spr_skrunkly_head, 0, x + (2.5 * sin(get_current_frame() / 15)), y - 13);
            break;
    }
    if (happy)
    {
        draw_sprite(ms1_spr_heart, 0, x + 15, y - 35 - (5 * heart_up));
    }
    if (get_win_state() == 0 && !happy)
    {
        var bublspr = ms1_spr_askfood;
        switch (want)
        {
            case "food":
                bublspr = ms1_spr_askfood;
                break;
            case "water":
                bublspr = ms1_spr_askwater;
                break;
            case "fun":
                bublspr = ms1_spr_askbear;
                break;
        }
        if (x > 285)
        {
            bubdir = -1;
        }
        draw_sprite_ext(bublspr, bublsubimg, x + (15 * bubdir), y - 30, bubdir, 1, 0, c_white, 1);
    }
}

function ms1scr_item_init()
{
    x = 155;
    y = 0;
    ori_x = 0;
    ori_y = 0;
    item = "food";
    drag = 0;
    depth = -1;
}

function ms1scr_item_tick()
{
    var input = get_input();
    var imouse = input.mouse;
    game = get_meta_object();
    switch (drag)
    {
        case 0:
            if (imouse.click_press && point_distance(x, y, imouse.x, imouse.y) < 20)
            {
                drag = 1;
                ori_x = x;
                ori_y = y;
                sfx_play(ms1_snd_click);
            }
            break;
        case 1:
            var taken = false;
            for (var i = 0; i < array_length(game.skrunks) && !taken; i++)
            {
                var skrunk = game.skrunks[i];
                var skrunksense = false;
                for (var j = 0; j < array_length(skrunk.sense_x); j++)
                {
                    if (point_distance(x, y, skrunk.sense_x[j], skrunk.sense_y[j]) < 25 && item == skrunk.want)
                    {
                        taken = true;
                        skrunk.happy = true;
                        sfx_play(ms1_snd_heart);
                        game.skrunks_happy++;
                        if (game.skrunks_happy == array_length(game.skrunks))
                        {
                            game_win();
                        }
                        taken = true;
                        j = array_length(skrunk.sense_x);
                    }
                }
            }
            if (!imouse.click)
            {
                drag = 0;
                x = ori_x;
                y = ori_y;
            }
            else
            {
                x = imouse.x;
                y = imouse.y;
            }
            if (taken)
            {
                drag = 0;
                x = -20;
                y = -20;
            }
            break;
    }
    var spr = ms1_spr_apple;
    var uimode = x < 198;
    switch (item)
    {
        case "food":
            if (uimode)
            {
                spr = ms1_spr_ui_apple;
            }
            else
            {
                spr = ms1_spr_apple;
            }
            break;
        case "water":
            if (uimode)
            {
                spr = ms1_spr_ui_bottle;
            }
            else
            {
                spr = ms1_spr_bottle;
            }
            break;
        case "fun":
            if (uimode)
            {
                spr = ms1_spr_ui_bear;
            }
            else
            {
                spr = ms1_spr_bear;
            }
            break;
    }
    sprite_index = spr;
}

function ms1scr_item_draw()
{
    _draw_self();
}

function ms1scr_hand_init()
{
    sprite_index = ms1_spr_hand;
    image_speed = 0;
    image_index = 0;
    depth = -3;
}

function ms1scr_hand_tick()
{
    var input = get_input();
    var imouse = input.mouse;
    x = clamp(imouse.x, 80, get_screen_width() - 80);
    y = clamp(imouse.y, 45, get_screen_height() - 45);
    if (imouse.click)
    {
        image_index = 1;
    }
    else
    {
        image_index = 0;
    }
}

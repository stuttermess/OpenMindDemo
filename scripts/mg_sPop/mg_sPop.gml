function mg_sPop() : minigame_constructor() constructor
{
    name = "Pop";
    prompt = "POP!";
    time_limit = 10;
    music = ms5_mus;
    music_bpm = 128;
    control_style = build_control_style(["cmove", "cclick"]);
    metascript_init = ms5_metascript_init;
    metascript_tick_before = ms5_metascript_tick_before;
    metascript_draw_before = ms5_metascript_draw_before;
    metascript_draw_after = ms5_metascript_draw_after;
    define_object("hand", 
    {
        tick: ms5scr_hand_tick
    }, 
    {
        sprite_index: ms5_spr_hand,
        image_speed: 0,
        depth: -100
    });
    define_object("face", 
    {
        init: ms5scr_face_init,
        tick: ms5scr_face_tick
    });
    define_object("bubblepop", {}, 
    {
        sprite_index: ms5_spr_bubble_pop,
        depth: 0
    });
    define_object("bubble", 
    {
        tick: ms5scr_bubble_tick
    }, 
    {
        sprite_index: ms5_spr_bubble_unpop,
        image_index: 0,
        depth: 0,
        pop: false
    });
}

function ms5_metascript_init()
{
    maxunpoppedamt = 5;
    unpoppedamt = 0;
    pop = true;
    buffer = 30;
    xspacing = 19;
    yspacing = 10;
    surf = -1;
    zoom = 1;
    pop_x = 240;
    pop_y = 135;
    spawnamt = 5 + (get_game_difficulty() - 1);
    if (get_game_speed() > 1.5)
    {
        spawnamt -= ((get_game_speed() - 1) / 0.5);
        spawnamt = max(2, ceil(spawnamt));
    }
    bubblexstart = 27;
    bubbleystart = 45;
    bubblesize = sprite_get_width(ms5_spr_bubble_unpop);
    sounds = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
    for (i = 0; i < array_length(sounds); i++)
    {
        sounds[i] = asset_get_index("ms5_snd_pop" + string(sounds[i]));
    }
    var bubblePositions = [];
    var i = 0;
    for (var iy = 0; iy < 4; iy++)
    {
        for (var ix = 0; ix < 7; ix++)
        {
            var xpos = 72 + (ix * 57.5);
            var ypos = 44 + (iy * 54);
            xpos += irandom_range(-2, 2);
            ypos += irandom_range(-2, 2);
            ypos += (dsin((ix / 7) * 360) * 5);
            bubblePositions[i] = [xpos, ypos];
            i++;
        }
    }
    index = 0;
    for (i = 0; i < array_length(bubblePositions); i++)
    {
        var bubx = bubblePositions[i][0];
        var buby = bubblePositions[i][1];
        popbubble[index] = create_object("bubblepop", 
        {
            x: bubx,
            y: buby
        });
        popbubble[index].image_xscale = choose(1, -1);
        popbubble[index].image_yscale = choose(1, -1);
        index++;
    }
    var usedIndexes = array_create(index, false);
    for (i = 0; i < spawnamt; i++)
    {
        var _rand;
        do
        {
            _rand = irandom_range(0, index - 1);
        }
        until (!usedIndexes[_rand]);
        usedIndexes[_rand] = true;
        var _inst = popbubble[_rand];
        var ixx = _inst.x;
        var iyy = _inst.y;
        bubble = create_object("bubble", 
        {
            x: ixx,
            y: iyy
        });
        bubble.index = _rand;
        unpoppedamt++;
        destroy_object(popbubble[_rand]);
    }
    sfx = [];
    last_sfx_tick = -1;
}

function ms5_metascript_tick_before()
{
    var inp = get_input();
    cur_x = inp.mouse.x;
    cur_y = inp.mouse.y;
    cur_h = inp.mouse.click;
    var sub_beats = 0.5;
    var do_sound = true;
    if (do_sound && array_length(sfx) > 0)
    {
        var _snd = sfx_play(sfx[0]);
        array_delete(sfx, 0, 1);
    }
    last_sfx_tick = floor(get_time() / sub_beats) * sub_beats;
    zoom = lerp(zoom, 1, 0.2);
}

function ms5_metascript_draw_before()
{
    if (!surface_exists(surf))
    {
        surf = surface_create(480, 270);
    }
    surface_set_target(surf);
    draw_clear(c_white);
    shader_set_wavy(ms5_spr_bg_table, get_current_frame() / 6, 0, 0, 0, 0.35, 200, 3);
    draw_sprite_tiled(ms5_spr_bg_table, 0, 0, 0);
    shader_reset();
    gpu_set_blendmode(bm_normal);
    draw_sprite(ms5_spr_bg_wrap, 0, 0, 0);
}

function ms5_metascript_draw_after()
{
    surface_reset_target();
    var x_origin = 240 + (pop_x - 240);
    var y_origin = 135 + (pop_y - 135);
    angle = 0;
    var matrix_translate_origin = matrix_build(-x_origin, -y_origin, 0, 0, 0, 0, 1, 1, 1);
    var matrix_rotate_and_scale = matrix_build(0, 0, 0, 0, 0, angle, zoom, zoom, 1);
    var matrix_translate_back = matrix_build(x_origin, y_origin, 0, 0, 0, 0, 1, 1, 1);
    var matrix_new_origin = matrix_multiply(matrix_translate_origin, matrix_rotate_and_scale);
    matrix_new_origin = matrix_multiply(matrix_new_origin, matrix_translate_back);
    matrix_set(2, matrix_new_origin);
    draw_surface(surf, 0, 0);
    matrix_set(2, matrix_build_identity());
    draw_sprite(ms5_spr_hand, cur_h, cur_x, cur_y);
}

function ms5scr_hand_tick()
{
    var input = get_input();
    var imouse = input.mouse;
    x = imouse.x;
    y = imouse.y;
    image_index = 0;
    if (imouse.click)
    {
        image_index = 1;
    }
}

function ms5scr_face_init()
{
    var spr = irandom_range(0, 3);
    switch (spr)
    {
        case 0:
            sprite_index = ms5_spr_face1;
            break;
        case 1:
            sprite_index = ms5_spr_face2;
            break;
        case 2:
            sprite_index = ms5_spr_face3;
            break;
        case 3:
            sprite_index = ms5_spr_face4;
            break;
    }
    image_alpha = 1;
    depth = -1;
    life = 30;
}

function ms5scr_face_tick()
{
    life--;
    image_index += (sprite_get_speed(sprite_index) / room_speed);
    image_index %= sprite_get_number(sprite_index);
    if (life <= 0)
    {
        image_alpha -= 0.05;
    }
}

function ms5scr_bubble_tick()
{
    var input = get_input();
    var imouse = input.mouse;
    var game = get_meta_object();
    if (imouse.click_press && !pop)
    {
        if (point_in_circle(x, y, imouse.x, imouse.y, 26))
        {
            var xx = x;
            var yy = y;
            var popped = create_object("bubblepop", 
            {
                x: xx,
                y: yy
            });
            game.pop_x = x;
            game.pop_y = y;
            popped.image_xscale = choose(1, -1);
            popped.image_yscale = choose(1, -1);
            var sndI = irandom(array_length(game.sounds) - 1);
            array_push(game.sfx, game.sounds[sndI]);
            array_delete(game.sounds, sndI, 1);
            game.unpoppedamt--;
            if (game.unpoppedamt <= 0)
            {
                game_win();
            }
            image_index = 1;
            pop = true;
            face = create_object("face", 
            {
                x: xx + 24,
                y: yy - 24
            });
            game.zoom = 1.05;
        }
    }
}

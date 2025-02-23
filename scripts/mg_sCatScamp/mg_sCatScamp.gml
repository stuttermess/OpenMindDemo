function mg_sCatScamp() : minigame_constructor() constructor
{
    name = "Cat Catch";
    prompt = "CATCH!";
    time_limit = 8;
    efin_skip_amount = 4;
    music = ms8_mus;
    music_bpm = 128;
    control_style = build_control_style(["cmove", "cclick"]);
    screen_w = 320;
    screen_h = 180;
    metascript_init = ms8OLD_metascript_init;
    metascript_tick_after = ms8OLD_metascript_tick_after;
    metascript_draw_before = ms8OLD_metascript_draw_before;
    metascript_draw_after = ms8OLD_metascript_draw_after;
    define_object("litteshit", 
    {
        tick: ms8OLDscr_littleshit_tick,
        draw: ms8OLDscr_littleshit_draw
    }, 
    {
        sprite_index: ms8_spr_littleshit,
        image_alpha: 1,
        trys: 3,
        xbias: 1,
        ybias: 1,
        meow_countdown: 5,
        afterimages: []
    });
    define_object("hand", 
    {
        tick: ms8OLDscr_hand_tick
    }, 
    {
        sprite_index: ms8_spr_hand,
        image_alpha: 1,
        depth: -100
    });
    define_object("thing", {}, {});
}

function ms8OLD_metascript_init()
{
    var border = 30;
    var randx = random_range(border, get_screen_width() - border);
    var randy = random_range(border, get_screen_height() - border);
    shit = create_object("litteshit", 
    {
        x: randx,
        y: randy
    });
    hand = create_object("hand", 
    {
        x: 0,
        y: 0
    });
    things = [];
    var _sprite_offset = irandom(3);
    var _positions = [[30, 28], [291, 26], [295, 160], [20, 162]];
    array_shuffle_ext(_positions);
    var _sprites = [ms8_spr_thing1, ms8_spr_thing2, ms8_spr_thing3, ms8_spr_thing4];
    for (var i = 0; i < 4; i++)
    {
        var _sprite = _sprites[(i + _sprite_offset) % array_length(_sprites)];
        var _position = _positions[i];
        _position[0] = lerp(_position[0], 160, 0.1);
        _position[1] = lerp(_position[1], 90, 0.1);
        things[i] = create_object("thing", 
        {
            x: _position[0],
            y: _position[1],
            sprite_index: _sprite,
            depth: 10
        });
    }
    xx = 0;
    yy = 0;
    winstate = false;
    winstatetimmer = 30;
}

function ms8OLD_metascript_tick_after()
{
    rot = random_range(-6, 6);
    if (winstate)
    {
        winstatetimmer--;
    }
    if (winstatetimmer <= 0)
    {
        for (var i = 0; i < array_length(things); i++)
        {
            things[i].image_alpha = 0;
        }
    }
}

function ms8OLD_metascript_draw_before()
{
    draw_clear(c_white);
}

function ms8OLD_metascript_draw_after()
{
    if (winstatetimmer <= 0)
    {
        shit.x = 1000;
        hand.x = 1000;
        draw_sprite_ext(ms8_spr_littleshitcatch, get_current_frame() / 2, 185, 55, 1, 1, rot, c_white, 1);
        draw_sprite(ms8_spr_catcatch, get_current_frame() / 6, get_screen_width() / 2, (get_screen_height() / 2) + 15);
    }
}

function ms8OLDscr_littleshit_tick()
{
    var input = get_input();
    var imouse = input.mouse;
    var game = get_meta_object();
    meow_countdown--;
    if (meow_countdown <= 0)
    {
        var snd = sfx_play(ms8_snd_meow);
        audio_sound_pitch(snd, random_range(1, 1.3));
        audio_sound_gain(snd, random_range(0.5, 1.2), 0);
        meow_countdown = irandom_range(6, 17);
    }
    for (var i = 0; i < array_length(afterimages); i++)
    {
        afterimages[i][5]--;
        if (afterimages[i][5] <= 0)
        {
            array_delete(afterimages, i, 1);
            i--;
        }
    }
    var startx = x;
    var starty = y;
    image_angle = random_range(-2, 2);
    if (!game.winstate)
    {
        var spd = 10 * (get_game_speed() / 2);
        var randx;
        if (x >= (get_screen_width() / 2))
        {
            randx = random_range(-spd * xbias, (spd / 1.02) * xbias);
        }
        else
        {
            randx = random_range((-spd / 1.02) * xbias, spd * xbias);
        }
        var randy = random_range(-spd * ybias, spd * ybias);
        x += randx;
        y += randy;
        image_xscale = -sign(randx);
        image_angle = sign(randy) * 10;
        var border = 60;
        x = clamp(x, border, get_screen_width() - border);
        y = clamp(y, border, get_screen_height() - border);
        if (trys > 0)
        {
            if (point_in_circle(x, y, imouse.x, imouse.y, 32))
            {
                var dir = point_direction(x, y, imouse.x, imouse.y);
                xbias = lengthdir_x(32, -dir);
                ybias = lengthdir_y(32, dir);
                trys--;
            }
        }
        xbias = lerp(xbias, 1, 0.3);
        ybias = lerp(ybias, 1, 0.3);
        if (point_in_circle(x, y, imouse.x, imouse.y, 32))
        {
            if (imouse.click_press)
            {
                sfx_play(ms8_snd_catch);
                game.winstate = true;
                game_win();
            }
        }
        game.xx = x;
        game.yy = y;
    }
    else
    {
        sprite_index = ms8_spr_littleshitcatch;
    }
}

function ms8OLDscr_littleshit_draw()
{
    var game = get_meta_object();
    draw_sprite(ms8_spr_shadow, 0, x, y + 35);
    if (!game.winstate)
    {
        for (var i = 0; i < array_length(afterimages); i++)
        {
            var _i = afterimages[i];
            var _t = _i[5] / 10;
            draw_sprite_ext(sprite_index, _i[2], _i[0], _i[1], _i[3], 1, _i[4], c_white, 1 * _t);
        }
    }
    _draw_self();
}

function ms8OLDscr_hand_tick()
{
    var input = get_input();
    var imouse = input.mouse;
    var game = get_meta_object();
    if (!game.winstate)
    {
        x = imouse.x;
        y = imouse.y;
        if (imouse.click)
        {
            sprite_index = ms8_spr_handhold;
        }
        else
        {
            sprite_index = ms8_spr_hand;
        }
    }
    else
    {
        sprite_index = ms8_spr_handhold;
        if (game.winstatetimmer > 0)
        {
            x = game.xx;
            y = game.yy + 12;
        }
    }
}

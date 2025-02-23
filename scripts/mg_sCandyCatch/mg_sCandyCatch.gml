function mg_sCandyCatch() : minigame_constructor() constructor
{
    name = "Candy Catch";
    prompt = "CATCH!";
    time_limit = 8;
    efin_skip_amount = 99;
    music = ms14_mus;
    music_bpm = 128;
    control_style = build_control_style(["cmove"]);
    win_on_timeover = true;
    metascript_init = ms14_metascript_init;
    metascript_start = ms14_metascript_start;
    metascript_tick_before = ms14_metascript_tick_before;
    metascript_draw_before = ms14_metascript_draw_before;
    metascript_draw_after = ms14_metascript_draw_after;
    define_object("hands", 
    {
        init: ms14scr_hands_init,
        tick: ms14scr_hands_tick
    });
    define_object("candy", 
    {
        init: ms14scr_candy_init,
        tick: ms14scr_candy_tick,
        draw: ms14scr_candy_draw
    });
    define_object("candydropped", 
    {
        init: ms14scr_candydropped_init
    });
    define_object("yayparticle", 
    {
        init: ms14scr_yayparticle_init,
        tick: ms14scr_yayparticle_tick,
        draw: ms14scr_yayparticle_draw
    });
}

function ms14scr_candydropped_init()
{
    sprite_index = spr_missing;
    game_lose();
}

function ms14scr_candy_tick()
{
    var game = get_meta_object();
    var _beat = get_time_limit() - get_time();
    prog = ((_beat - create_beat) / (land_beat - create_beat)) + 0.045;
    if (collected)
    {
        x = game.hand.x + (tox * game.hand.image_xscale);
        y = game.hand.y + (toy * game.hand.image_yscale);
        image_xscale = 1 * game.hand.image_xscale;
    }
    else
    {
        image_xscale = startscale - (2 * prog);
    }
    image_xscale = clamp(image_xscale, 0.7, 999);
    image_yscale = image_xscale;
    if (image_xscale <= 0.7 && cancollect)
    {
        cancollect = false;
        wefuckingdies = true;
        image_alpha = 0;
        var inst = create_object("candydropped");
        sfx_play(ms14_snd_drop);
        with (inst)
        {
            image_xscale = other.image_xscale;
            image_yscale = other.image_yscale;
            x = other.x;
            y = other.y;
            sprite_index = other.sprite_index;
        }
    }
}

function ms14scr_candy_init()
{
    sprite_index = choose(ms14_spr_candy1, ms14_spr_candy2, ms14_spr_candy3, ms14_spr_candy4);
    var dir = random(360);
    var len = random(100);
    var xlimit = 170;
    var ylimit = 90;
    var rx = lengthdir_x(len / 100, dir) * xlimit;
    var ry = lengthdir_y(len / 100, dir) * ylimit;
    x = (get_screen_width() / 2) + rx;
    y = (get_screen_height() / 2) + ry;
    startscale = 3;
    fallspd = 0.05 * get_game_speed();
    cancollect = true;
    collected = false;
    wefuckingdies = false;
    tox = -1;
    toy = -1;
    create_beat = 0;
    land_beat = 0;
    image_xscale = startscale;
    image_yscale = image_xscale;
}

function ms14scr_candy_draw()
{
    _draw_self();
}

function ms14scr_hands_init()
{
    sprite_index = ms14_spr_hands;
    bumptime = 0;
    bump = 0;
}

function ms14scr_hands_tick()
{
    var input = get_input();
    imouse = input.mouse;
    var game = get_meta_object();
    x = imouse.x;
    y = imouse.y;
    for (var i = 0; i < game.i && get_win_state() == 0; i++)
    {
        var inst = game.candy[i];
        if (inst.cancollect && inst.image_xscale <= 1)
        {
            if (collide_obj_fast(self, x, y, inst, inst.x, inst.y))
            {
                var _snd = sfx_play(ms14_snd_catch);
                audio_sound_pitch(_snd, get_game_speed());
                inst.collected = true;
                inst.cancollect = false;
                inst.tox = -(x - inst.x);
                inst.toy = -(y - inst.y);
                game.bgwave = 1;
                bumptime = 1;
                var _dir_sep = 60;
                var _dir = point_direction(inst.x, inst.y, get_screen_width() / 2, get_screen_height() / 2);
                _dir += random_range(-15, 15);
                var _dirchange = choose(-1, 1);
                var _sprs = [1, 2, 3];
                for (var j = 0; j < 3; j++)
                {
                    var _part = create_object("yayparticle");
                    var sprnum = irandom(array_length(_sprs) - 1);
                    _part._spr = _sprs[sprnum];
                    array_delete(_sprs, sprnum, 1);
                    _part.dir = _dir + (j * _dir_sep);
                    _part.x = inst.x;
                    _part.y = inst.y;
                    _part.dirchange = 0;
                    array_push(game.particles, _part);
                }
            }
        }
    }
    if (bumptime > 0)
    {
        bumptime -= 0.1;
        bump = dsin(bumptime * 180);
    }
    image_xscale = 1 - (bump * 0.08);
    image_yscale = 1 - (bump * 0.08);
}

function ms14scr_yayparticle_init()
{
    _spr = 1;
    sprite_index = asset_get_index("ms14_spr_particle" + string(_spr));
    dir = 0;
    dirchange = 1;
    vel = 10;
    vanishtimer = 6;
}

function ms14scr_yayparticle_tick()
{
    sprite_index = asset_get_index("ms14_spr_particle" + string(_spr));
    x += lengthdir_x(vel, dir);
    y += lengthdir_y(vel, dir);
    x = clamp(x, 30, get_screen_width() - 30);
    y = clamp(y, 30, get_screen_height() - 30);
    var game = get_meta_object();
    if (vel <= 0)
    {
        vanishtimer--;
    }
    if (vanishtimer <= 0)
    {
        image_alpha -= 0.16666666666666666;
    }
    if (image_alpha <= 0)
    {
        array_delete(game.particles, 0, 1);
        destroy_object();
    }
    dir += (dirchange * 6);
    vel += sign(0 - vel);
}

function ms14scr_yayparticle_draw()
{
    draw_sprite_ditherfaded(sprite_index, image_index, x, y, 1 - image_alpha, image_xscale, image_yscale, image_angle, image_blend, 1);
}

function ms14_metascript_init()
{
    hand = create_object("hands");
    i = 0;
    prevbeat = -1;
    beats = 0;
    candy = [];
    particles = [];
    bgwave = 0;
    losescreen = 0;
    loseframe = 0;
    spawn_beats = [1, 3, 5];
    land_beats = [3, 5, 7];
    leadin_sound = -1;
}

function ms14_metascript_start()
{
    leadin_sound = sfx_play(ms14_snd_leadin);
    audio_sound_pitch(leadin_sound, get_game_speed());
}

function ms14_metascript_tick_before()
{
    var input = get_input();
    imouse = input.mouse;
    var curbeat = get_time_limit() - get_time();
    if (floor(curbeat) > floor(prevbeat))
    {
        if (array_contains(spawn_beats, floor(curbeat)) && array_length(spawn_beats) > i)
        {
            candy[i] = create_object("candy");
            candy[i].create_beat = round(curbeat);
            candy[i].land_beat = land_beats[i];
            i++;
        }
        beats++;
    }
    prevbeat = curbeat;
    bgwave += ((0 - bgwave) * 0.1 * get_game_speed());
    if (get_win_state() == -1)
    {
        losescreen += ((1 - losescreen) * 0.5);
        loseframe += (sprite_get_speed(ms14_spr_loseright) / 60);
    }
}

function ms14_metascript_draw_before()
{
    draw_clear(c_teal);
    var curbeat = get_time();
    shader_set_wavy(ms14_spr_bg, curbeat, 0, 0, 0, 10, 100, 30 * bgwave);
    var bg_scale = 1 + (bgwave * 0.2);
    draw_sprite_ext(ms14_spr_bg, 0, get_screen_width() / 2, get_screen_height() / 2, bg_scale, bg_scale, 0, c_white, 1);
    shader_reset();
}

function ms14_metascript_draw_after()
{
    with (hand)
    {
        _draw_self();
    }
    for (var ii = 0; ii < i; ii++)
    {
        with (candy[ii])
        {
            perform_event("draw");
        }
    }
    for (var ii = 0; ii < array_length(particles); ii++)
    {
        with (particles[ii])
        {
            _draw_self();
        }
    }
    gpu_set_blendmode_multiply();
    draw_sprite(ms14_spr_multshadow, 0, 0, 0);
    gpu_set_blendmode(bm_normal);
    draw_sprite(ms14_spr_window, 0, 0, 0);
    draw_sprite(ms14_spr_loseleft, loseframe, 0 + ((get_screen_width() / 2) * losescreen), get_screen_height() / 2);
    draw_sprite(ms14_spr_loseright, loseframe, get_screen_width() - ((get_screen_width() / 2) * losescreen), get_screen_height() / 2);
}

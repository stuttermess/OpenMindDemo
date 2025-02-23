function mg_sHugRun() : minigame_constructor() constructor
{
    name = "HugRun";
    prompt = "MASH!";
    time_limit = 20;
    efin_skip_amount = 3;
    music = ms9_mus;
    music_bpm = 128;
    control_style = build_control_style(["keyboard"]);
    screen_w = 480;
    screen_h = 270;
    metascript_init = ms9OLD_metascript_init;
    metascript_tick_before = ms9OLD_metascript_tick_before;
    metascript_tick_after = ms9OLD_metascript_tick_after;
    metascript_draw_before = ms9OLD_metascript_draw_before;
    metascript_draw_after = ms9OLD_metascript_draw_after;
    metascript_cleanup = ms9OLD_metascript_cleanup;
    define_object("sparkle", 
    {
        tick: ms9OLDscr_sparkle_tick,
        draw: ms9OLDscr_sparkle_draw
    }, 
    {
        sprite_index: ms9_spr_sparkle_body,
        x: 60,
        y: 110,
        ystart: 110,
        xstart: 60,
        legrot: 0,
        superspeed: false,
        launchtimer: 30,
        launch: false,
        willwin: false,
        death: false,
        intensity: 10,
        mash: 0,
        depth: -600,
        sound_countdown: 0
    });
    define_object("jenny", 
    {
        tick: ms9OLDscr_jenny_tick,
        draw: ms9OLDscr_jenny_draw
    }, 
    {
        sprite_index: ms9_spr_jenny,
        x: 1700,
        y: 160
    });
    define_object("npc", 
    {
        tick: ms9OLDscr_npc_tick,
        draw: ms9OLDscr_npc_draw
    }, 
    {
        sprite_index: ms9_spr_npc,
        death: false
    });
    define_object("deathparticle", 
    {
        tick: ms9OLDscr_deathparticle_tick,
        draw: ms9OLDscr_deathparticle_draw
    }, 
    {
        sprite_index: ms9_spr_hit,
        depth: 10000,
        image_xscale: 1
    });
}

function ms9OLD_metascript_init()
{
    ds_list_add(master.input_keys_check, "any");
    var _keys = "QWERTYUIOPASDFGHJKLZXCVBNM";
    for (var _i = 1; _i <= string_length(_keys); _i++)
    {
        ds_list_add(master.input_keys_check, string_char_at(_keys, _i));
    }
    keys_to_mash_chars = [""];
    keys_to_mash = [32];
    key_ind = 0;
    switch (get_game_difficulty())
    {
        case 0:
            break;
        case 1:
            keys_to_mash = choose("SL", "WI", "TP", "AK", "XM", "RP");
            break;
        case 2:
            if (get_game_speed() > 1.7)
            {
                keys_to_mash = choose("AHL", "RUP", "ZBM", "QTI");
            }
            else
            {
                keys_to_mash = choose("SL", "WI", "TP", "AK", "XM", "RP");
            }
            break;
    }
    if (is_string(keys_to_mash))
    {
        var _arr = [];
        var _str = "";
        for (var i = 1; i <= string_length(keys_to_mash); i++)
        {
            var _char = string_char_at(keys_to_mash, i);
            _str += (_char + ",");
            _arr[i - 1] = ord(_char);
            keys_to_mash_chars[i - 1] = _char;
        }
        keys_to_mash = _arr;
        show_debug_message(_str);
    }
    gamesf = surface_create(320, 180);
    original_sf = -1;
    surfinput = -1;
    mashnum = 1;
    camx = 0;
    gamewon = false;
    gamelost = false;
    pixel = 0;
    s = 0;
    sparkle = create_object("sparkle");
    jenny = create_object("jenny");
    for (var i = 0; i < 25; i++)
    {
        randx = random_range(200, 3000);
        randy = random_range(90, 140);
        npc = create_object("npc", 
        {
            x: randx,
            y: randy
        });
    }
}

function ms9OLD_metascript_tick_before()
{
    if (mashnum <= 0 && sparkle.launch)
    {
        gamelost = true;
    }
    if (get_timer() <= 1 && sparkle.willwin)
    {
        gamewon = true;
    }
}

function ms9OLD_metascript_tick_after()
{
    if (gamewon || gamelost)
    {
        pixel += 20;
    }
}

function ms9OLD_metascript_draw_before()
{
    if (!surface_exists(gamesf))
    {
        gamesf = surface_create(320, 180);
    }
    original_sf = surface_get_target();
    surface_reset_target();
    surface_set_target(gamesf);
    var i = 0;
    while (i <= 640)
    {
        draw_sprite(ms9_spr_bg_sky, 0, (camx / 30) + i, 0);
        i += sprite_get_width(ms9_spr_bg_sky);
    }
    i = 0;
    while (i <= 6400)
    {
        draw_sprite(ms9_spr_bg_building1, 0, (camx / 10) + i, 132);
        i += (sprite_get_width(ms9_spr_bg_building1) * 4);
    }
    i = 0;
    while (i <= 6400)
    {
        draw_sprite(ms9_spr_bg_building2, 0, (camx / 8) + i, 132);
        i += (sprite_get_width(ms9_spr_bg_building2) * 5);
    }
    i = 0;
    while (i <= 6400)
    {
        draw_sprite(ms9_spr_bg_building3, 0, (camx / 6) + i, 132);
        i += (sprite_get_width(ms9_spr_bg_building3) * 3);
    }
    i = 0;
    while (i <= 6400)
    {
        draw_sprite(ms9_spr_bg_car, 0, (camx / 1.4) + i, 140);
        i += (sprite_get_width(ms9_spr_bg_car) * 3);
    }
    i = 0;
    while (i <= 6400)
    {
        draw_sprite(ms9_spr_bg_tree, 0, (camx / 1.2) + i, 140);
        i += (sprite_get_width(ms9_spr_bg_tree) * 5);
    }
    i = 0;
    while (i <= 12800)
    {
        draw_sprite(ms9_spr_bg_sidewalk, 0, camx + i, 180);
        i += sprite_get_width(ms9_spr_bg_sidewalk);
    }
}

function ms9OLD_metascript_draw_after()
{
    surface_reset_target();
    surface_set_target(original_sf);
    var _tar;
    if (!sparkle.launch)
    {
        _tar = mashnum / 50 / 1.5;
    }
    if (sparkle.launch || gamewon)
    {
        _tar = 0;
    }
    s = lerp(s, _tar, 0.2);
    var _scale = 1.5 + s;
    draw_surface_ext(gamesf, -s * 40, -s * 70, _scale, _scale, 0, c_white, 1);
    var time = get_current_frame();
    if (gamewon)
    {
        shader_set_pixelate(pixel, ms9_spr_winframe, time * 3);
        draw_sprite_ext(ms9_spr_winframe, (time / 60) * 5, 240, 135, 1, 1, 0, c_white, pixel / 100);
        shader_reset();
        game_win();
    }
    if (gamelost && !gamewon)
    {
        shader_set_pixelate(pixel, ms9_spr_loseframe, time * 3);
        draw_sprite_ext(ms9_spr_loseframe, (time / 60) * 5, 160, 90, 1, 1, 0, c_white, pixel / 100);
        shader_reset();
        game_lose();
    }
    if (!surface_exists(surfinput))
    {
        surfinput = surface_create(320, 180);
    }
    surface_set_target(surfinput);
    draw_clear_alpha(c_white, 0);
    if (get_win_state() != 1)
    {
        if (!sparkle.launch)
        {
            var _keys_amt = array_length(keys_to_mash);
            var _cx = 200 - (9 * (_keys_amt - 1));
            var _keyy = 70;
            draw_set_color(#2B4D72);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_font(fnt_dialogue);
            for (var i = 0; i < _keys_amt; i++)
            {
                var _frame = 0;
                if (key_ind == i)
                {
                    _frame = get_current_frame() / 4;
                    if (sparkle.mash > 0)
                    {
                        _frame = get_current_frame() / 2;
                    }
                }
                _frame = floor(_frame) % 3;
                var _spr = ms9_spr_mashprompt_key;
                var _spacemode = keys_to_mash[i] == 32;
                if (_spacemode)
                {
                    _spr = ms9_spr_mashprompt_space;
                }
                var _keyx = _cx + (20 * i);
                draw_sprite(_spr, _frame, _keyx, _keyy);
                if (!_spacemode)
                {
                    var _char_yoff = 0;
                    switch (_frame)
                    {
                        case 0:
                            _char_yoff += 0;
                            break;
                        case 1:
                            _char_yoff += 6;
                            break;
                        case 2:
                            _char_yoff -= 1;
                            break;
                    }
                    draw_text(_keyx, _keyy + _char_yoff, keys_to_mash_chars[i]);
                }
                if (key_ind == i && _keys_amt > 1)
                {
                    draw_sprite(ms9_spr_mashprompt_key_arrow, _frame, _keyx, _keyy);
                }
            }
            draw_set_color(c_white);
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            draw_set_font(fnt_pixel);
        }
        if (mashnum < 50 && !sparkle.launch)
        {
            var barx = 130;
            var bary = 110;
            var barh = 70;
            draw_rectangle(barx, bary, barx + 5, bary - barh, true);
            draw_rectangle(barx, bary, barx + 5, bary + (-barh * (mashnum / 50)), false);
        }
    }
    surface_reset_target();
    draw_surface_ext(surfinput, 30, 0, 1.5, 1.5, 0, c_white, 1);
}

function ms9OLDscr_sparkle_tick()
{
    var input = get_input();
    var ikey = input.key;
    var game = get_meta_object();
    if (sound_countdown >= 0)
    {
        var sound_countdown_speed = 0;
        if (game.mashnum > 2 && game.mashnum < 10)
        {
            sound_countdown_speed = 0.05;
        }
        else if (game.mashnum < 20)
        {
            sound_countdown_speed = 0.1;
        }
        else if (game.mashnum < 30)
        {
            sound_countdown_speed = 0.15;
        }
        else if (game.mashnum < 40)
        {
            sound_countdown_speed = 0.3;
        }
        else
        {
            sound_countdown_speed = 0.45;
        }
        sound_countdown -= (sound_countdown_speed * 1.1);
    }
    else if (get_win_state() == 0 && game.mashnum > 2)
    {
        sound_countdown = 1;
        sfx_play(ms9_snd_step);
    }
    if (!launch)
    {
        if (ikey.any_press)
        {
            if (keyboard_check_pressed(game.keys_to_mash[game.key_ind]))
            {
                game.mashnum += 5 * (get_game_speed() / 2);
                mash = 10;
                game.key_ind++;
                game.key_ind = game.key_ind % array_length(game.keys_to_mash);
            }
            else
            {
                game.mashnum -= 5 * (get_game_speed() / 2);
                game.mashnum = max(game.mashnum, 0);
                mash = 10;
                sfx_play(ms12_snd_error);
            }
        }
        game.mashnum -= 0.05;
        game.mashnum = max(game.mashnum, 0);
    }
    else
    {
        game.camx -= (game.mashnum / 2) * (0.5 + (get_game_speed() / 2));
        game.mashnum -= 1;
    }
    if (game.mashnum >= 30)
    {
    }
    if (game.mashnum >= 50 && launch == false)
    {
        launch = true;
        game.mashnum = 80;
        superspeed = false;
        sfx_play(ms9_snd_launch);
    }
    if (launch)
    {
        x = lerp(x, xstart + (game.mashnum / 2), 0.2 * get_game_speed());
    }
    if (game.camx <= (-game.jenny.x + 60))
    {
        game.camx = -game.jenny.x + 60;
    }
    if (get_win_state() == 1)
    {
        game.mashnum = lerp(game.mashnum, 0, 0.1 * get_game_speed());
        launch = false;
    }
    if (launch && get_time() <= 1)
    {
        game.camx = -game.jenny.x + 60;
    }
    game.mashnum = clamp(game.mashnum, 0, 1000);
    y = ystart + (sin(legrot / 100) * 10);
    if (game.mashnum <= 0 && launch && !game.gamewon)
    {
        death = true;
        sprite_index = ms9_spr_sparkle_body_shock;
        intensity = lerp(intensity, 0, 0.1);
        x += random_range(-intensity, intensity);
        y += random_range(-intensity, intensity);
    }
    legrot += game.mashnum;
    mash--;
}

function ms9OLDscr_sparkle_draw()
{
    _draw_self();
    var timer = get_timer();
    var game = get_meta_object();
    superspeed = game.mashnum > 35 && !launch;
    if (!superspeed)
    {
        mylegrot = -abs(sin(legrot / 100)) * 70;
        draw_sprite_ext(ms9_spr_sparkle_leg, 0, x, y, 1, 1, 45 - mylegrot, c_white, 1);
        draw_sprite_ext(ms9_spr_sparkle_leg, 0, x, y, -1, 1, -45 - -mylegrot, c_white, 1);
        if (!death)
        {
            sprite_index = ms9_spr_sparkle_body;
        }
    }
    if (!launch && superspeed)
    {
        sprite_index = ms9_spr_sparkle_body_fast;
        draw_sprite(ms9_spr_sparkle_leg_fast, get_current_frame(), x, y);
    }
}

function ms9OLDscr_jenny_tick()
{
    var game = get_meta_object();
    if (collide_obj_fast(game.sparkle, game.sparkle.x, game.sparkle.y, self, x + game.camx, y))
    {
        image_index = 1;
        game.mashnum = lerp(game.mashnum, 0, 0.16);
        game.gamewon = true;
        if (get_win_state() == 0)
        {
            sfx_play(ms8_snd_catch);
        }
        game_win();
    }
}

function ms9OLDscr_jenny_draw()
{
    var game = get_meta_object();
    draw_sprite_ext(sprite_index, image_index, x + game.camx, y, 1, 1, 0, c_white, 1);
}

function ms9OLDscr_npc_tick()
{
    var game = get_meta_object();
    depth = -y;
    if (point_distance(x + game.camx, y, game.sparkle.x, game.sparkle.y) < 60)
    {
        if (collide_obj_fast(game.sparkle, game.sparkle.x, game.sparkle.y, self, x + game.camx, y))
        {
            death = true;
            create_object("deathparticle", 
            {
                x: x + 20,
                y: y
            });
        }
    }
    if (death)
    {
        y -= 10;
        x += 15;
        image_angle += 10;
    }
}

function ms9OLDscr_npc_draw()
{
    var game = get_meta_object();
    draw_sprite_ext(sprite_index, 0, x + game.camx, y, 1, 1, image_angle, c_white, 1);
}

function ms9OLDscr_deathparticle_tick()
{
    if (!struct_exists(self, "r"))
    {
        r = random_range(4, 20);
    }
    image_angle += r;
    image_xscale = lerp(image_xscale, 0, 0.13);
    image_yscale = image_xscale;
}

function ms9OLDscr_deathparticle_draw()
{
    var game = get_meta_object();
    draw_sprite_ext(sprite_index, 0, x + game.camx, y, image_xscale, image_yscale, image_angle, c_white, 1);
}

function ms9OLD_metascript_cleanup()
{
    surface_free(gamesf);
}

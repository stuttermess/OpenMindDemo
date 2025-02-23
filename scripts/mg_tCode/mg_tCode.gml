function mg_tCode() : minigame_constructor() constructor
{
    name = "Code";
    prompt = "VERIFY!";
    prompt_y_offset = -70;
    use_prompt = true;
    use_timer = true;
    time_limit = 16;
    show_timer_at = 8;
    efin_skip_amount = 4;
    if (instance_exists(obj_minigame_controller) && obj_minigame_controller.endless_mode)
    {
        efin_skip_amount = 8;
    }
    music = mt1_mus;
    music_bpm = 128;
    music_loops = false;
    music_ignore_bpm = false;
    gimmick_blacklist = [gimmick_flip];
    control_style = build_control_style(["keyboard"]);
    screen_w = 480;
    screen_h = 270;
    metascript_init = mt1_metascript_init;
    metascript_tick_before = mt1_metascript_tick_before;
    metascript_tick_after = metascript_blank;
    metascript_draw_before = mt1_metascript_draw_before;
    metascript_draw_after = metascript_blank;
    metascript_cleanup = mt1_metascript_cleanup;
    define_object("guy", 
    {
        init: mt1scr_guy_init,
        tick: mt1scr_guy_tick,
        draw: mt1scr_guy_draw
    }, 
    {
        sprite_index: mt1_spr_head,
        image_speed: 0
    });
    define_object("code", 
    {
        init: mt1scr_code_init,
        tick: mt1scr_code_tick,
        draw: mt1scr_code_draw
    }, 
    {
        x: 313,
        y: 145
    });
    define_object("static", 
    {
        draw: mt1scr_static_draw
    }, 
    {
        sprite_index: mt1_spr_static
    });
}

function mt1_metascript_init()
{
    var _keys = "1234567890QWERTYUIOPASDFGHJKLZXCVBNM";
    for (var _i = 1; _i <= string_length(_keys); _i++)
    {
        ds_list_add(master.input_keys_check, string_char_at(_keys, _i));
    }
    ds_list_add(master.input_keys_check, "backspace");
    _static = create_object("static", 
    {
        x: 0,
        y: 0
    });
    _code = create_object("code");
    _guy = create_object("guy", 
    {
        x: 0,
        y: 0
    });
    _chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    _allowed_chars = "ACDEFGHJKMNPQRTUVWXYZ3467934679";
    _str = "";
    var difficulty = get_game_difficulty();
    switch (difficulty)
    {
        case 0:
            char_count = 4;
            break;
        case 1:
            char_count = 5;
            break;
        case 2:
        default:
            char_count = 6;
            break;
    }
    var egg = false;
    var gamespeed = get_game_speed();
    if (gamespeed > 1.5)
    {
        char_count /= ((gamespeed - 1) / 0.5);
        char_count = max(char_count, 4);
    }
    if (egg)
    {
        var _eggs = [];
        _str = string_upper(_eggs[irandom(array_length(_eggs) - 1)]);
    }
    else
    {
        repeat (char_count)
        {
            var charspace = irandom_range(1, string_length(_allowed_chars));
            _str += string_char_at(_allowed_chars, charspace);
            _allowed_chars = string_delete(_allowed_chars, charspace, 1);
        }
    }
    _code._str = _str;
    portal_sf = surface_create(480, 270);
    t = 0;
    bg_yscale = choose(-1, 1);
}

function mt1_metascript_tick_before()
{
    var input = get_input();
    t++;
}

function mt1_metascript_draw_before()
{
    draw_clear(c_black);
    draw_sprite(mt1_spr_portal, 0, 0, 0);
    if (portal_sf == -1)
    {
        exit;
    }
    if (!surface_exists(portal_sf))
    {
        portal_sf = surface_create(480, 270);
    }
    surface_set_target(portal_sf);
    draw_clear_alpha(c_black, 0);
    draw_sprite(mt1_spr_portal, 0, 0, 0);
    gpu_set_colorwriteenable(1, 1, 1, 0);
    shader_set_wavy(mt1_spr_bg, t / 60, 0.5, 2, 120, 0.7, 30, 50);
    var _scale = 0.29768467475192945;
    draw_sprite_ext(mt1_spr_bg, 0, sin(t / 60) * 20, (135 - (135 * bg_yscale)) + (cos(t / 50) * 20), 0.5, 0.5 * bg_yscale, 0, c_white, 1);
    shader_reset();
    gpu_set_colorwriteenable(1, 1, 1, 1);
    surface_reset_target();
    draw_surface(portal_sf, 0, 0);
}

function mt1_metascript_cleanup()
{
    _code.cleanup();
    if (audio_emitter_exists(_guy.emitter))
    {
        audio_emitter_free(_guy.emitter);
    }
    surface_free(portal_sf);
    portal_sf = -1;
}

function mt1scr_static_draw()
{
    draw_sprite_ditherfaded(sprite_index, image_index, x, y, 1 - image_alpha);
}

function mt1scr_code_init()
{
    sfs = [];
    var passes = 3;
    sf_w = 160;
    sf_h = 160;
    for (var i = 0; i < passes; i++)
    {
        sfs[i] = surface_create(sf_w, sf_h);
    }
    cleaned = false;
    
    cleanup = function()
    {
        for (var i = 0; i < array_length(sfs); i++)
        {
            surface_free(sfs[i]);
        }
        cleaned = true;
    };
    
    _str = "ABC123";
    var _range_low = 2/3;
    var _range_high = 1.2;
    switch (get_game_difficulty())
    {
        case 0:
            break;
        case 1:
            _range_high = 1.175;
            break;
        case 2:
        default:
            _range_high = 1.35;
            break;
    }
    fx = 
    {
        wavy: 
        {
            xspeed: 0.65,
            xfreq: 3,
            xsize: 6,
            yspeed: 2,
            yfreq: 9,
            ysize: 16
        },
        wavy_range: 
        {
            xspeed: [_range_low, _range_high],
            xfreq: [_range_low, _range_high],
            xsize: [_range_low, _range_high],
            yspeed: [_range_low, _range_high],
            yfreq: [_range_low, _range_high],
            ysize: [_range_low, _range_high]
        },
        compression: 
        {
            xoffset: 0.5,
            xspeed: 0.65,
            xfreq: 1.5,
            xsize: 0.05,
            yoffset: 0.5,
            yspeed: 1,
            yfreq: 1.5,
            ysize: 0.05
        },
        compression_range: 
        {
            xoffset: [_range_low, _range_high],
            xspeed: [_range_low, _range_high],
            xfreq: [_range_low, _range_high],
            xsize: [_range_low, _range_high],
            yoffset: [_range_low, _range_high],
            yspeed: [_range_low, _range_high],
            yfreq: [_range_low, _range_high],
            ysize: [_range_low, _range_high]
        }
    };
    var _fx_mods = ["wavy", "compression"];
    for (var thismod = 0; thismod < array_length(_fx_mods); thismod++)
    {
        var _struct = struct_get(fx, _fx_mods[thismod]);
        var _ranges = struct_get(fx, _fx_mods[thismod] + "_range");
        var _values = struct_get_names(_struct);
        for (var i = 0; i < array_length(_values); i++)
        {
            var _curval = struct_get(_struct, _values[i]);
            var _currange = struct_get(_ranges, _values[i]);
            _curval *= random_range(_currange[0], _currange[1]);
            _curval *= choose(1, -1);
            switch (_values[i])
            {
                case "xoffset":
                case "xfreq":
                case "xsize":
                    _curval *= (sf_w / 200);
                    break;
                case "yoffset":
                case "yfreq":
                case "ysize":
                    _curval *= (sf_h / 200);
                    break;
            }
            struct_set(_struct, _values[i], _curval);
        }
    }
    starttime = random(300);
}

function mt1scr_code_tick()
{
    var game = get_meta_object();
    if (get_win_state() == 1)
    {
        image_alpha = lerp(image_alpha, 0, 0.15);
        game._static.image_alpha = image_alpha;
    }
}

function mt1scr_code_draw()
{
    if (cleaned)
    {
        exit;
    }
    var _t = starttime + (get_current_frame() / 20);
    var _old_sf = surface_get_target();
    surface_reset_target();
    var sf;
    for (var i = 0; i < array_length(sfs); i++)
    {
        sf = sfs[i];
        if (!surface_exists(sf))
        {
            sfs[i] = surface_create(sf_w, sf_h);
            sf = sfs[i];
        }
        var prev_sf;
        if (i > 0)
        {
            prev_sf = sfs[i - 1];
        }
        surface_set_target(sf);
        draw_clear_alpha(c_white, 0);
        switch (i)
        {
            case 0:
                var _fnt = draw_get_font();
                draw_set_font(mt1_fnt_code);
                var strwid = string_width(_str);
                var xscale = 1;
                var _maxwid = 150 * (sf_w / 200);
                if (strwid > _maxwid)
                {
                    xscale = _maxwid / strwid;
                }
                draw_clear_alpha(c_white, 0);
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_set_color(c_white);
                draw_text_outline(sf_w / 2, sf_h / 2, _str, 0, true, 3, xscale, 1, 0);
                draw_set_halign(fa_left);
                draw_set_valign(fa_top);
                draw_set_color(c_white);
                draw_set_font(_fnt);
                break;
            case 1:
                var _fx = fx.wavy;
                gpu_set_texfilter(true);
                var _spd = 0.25;
                shader_set_wavy_texture(surface_get_texture(prev_sf), _t * _spd, _fx.xspeed, _fx.xfreq, _fx.xsize, _fx.yspeed, _fx.yfreq, _fx.ysize);
                draw_surface(prev_sf, 0, 0);
                shader_reset();
                gpu_set_texfilter(false);
                break;
            case 2:
                var _fx = fx.compression;
                var _spd = 0.6;
                shader_set_compression_texture(surface_get_texture(prev_sf), _t * _spd, _fx.xoffset, _fx.xspeed, _fx.xfreq, _fx.xsize, _fx.yoffset, _fx.yspeed, _fx.yfreq, _fx.ysize);
                draw_surface(prev_sf, 0, 0);
                shader_reset();
                break;
        }
        surface_reset_target();
    }
    surface_set_target(_old_sf);
    draw_surface_ditherfaded(sf, x - sf_w, y - sf_h, 1 - image_alpha, 2, 2);
}

function mt1scr_guy_init()
{
    sprites = [[mt1_spr_backarm_w, "backarm"], [mt1_spr_head_w, "head"], [mt1_spr_bod_w, "bod"], [mt1_spr_frontarm_w, "frontarm"], [mt1_spr_backarm, "backarm"], [mt1_spr_head, "head"], [mt1_spr_bod, "bod"], [mt1_spr_frontarm, "frontarm"]];
    pos = 
    {
        backarm: 
        {
            x: y,
            y: 0
        },
        bod: 
        {
            x: y,
            y: 0
        },
        frontarm: 
        {
            x: y,
            y: 0
        },
        head: 
        {
            x: y,
            y: 0
        }
    };
    _chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    _str = "";
    emitter = audio_emitter_create();
    bus = audio_bus_create();
    audio_emitter_bus(emitter, bus);
    audio_emitter_gain(emitter, audio_emitter_get_gain(master.emit_sfx));
    var _e_x = audio_emitter_get_x(master.emit_sfx);
    var _e_y = audio_emitter_get_y(master.emit_sfx);
    var _e_z = audio_emitter_get_z(master.emit_sfx);
    audio_emitter_position(emitter, _e_x, _e_y, _e_z);
    var _reverb = audio_effect_create(AudioEffectType.Reverb1);
    _reverb.size = 0.7;
    _reverb.mix = 0.8;
    var _delay = audio_effect_create(AudioEffectType.Delay);
    _delay.time = 0.125;
    _delay.mix = 0.8;
    bus.effects[0] = _delay;
    
    _voice_clip_letter = function(arg0)
    {
        var snd = asset_get_index("mt1_snd_" + arg0);
        sfx_play(snd);
        var _id = audio_play_sound_on(emitter, snd, false, 100);
        if (instance_exists(obj_minigame_controller))
        {
            array_push(obj_minigame_controller.sfx_pause_array, _id);
            array_push(obj_minigame_controller.sfx_array, _id);
        }
    };
    
    letter_pos = [];
    letter_shake = [];
}

function mt1scr_guy_tick()
{
    audio_emitter_gain(emitter, audio_emitter_get_gain(master.emit_sfx));
    var _fr = (get_current_frame() / 25) * 360;
    pos.backarm.x = 0.5 + (-dcos(_fr) * 0.5);
    pos.backarm.y = 0.5 + (-dsin(_fr) * 0.5);
    pos.bod.x = 0.5 + (-dcos(_fr + 180) * 0.5);
    pos.bod.y = 1.5 + (-dsin(_fr + 180) * 0.5);
    pos.frontarm.x = pos.backarm.x;
    pos.frontarm.y = pos.backarm.y;
    pos.head.x = pos.bod.x * 2;
    if (sprite_index != mt1_spr_win && image_index >= 0)
    {
        image_index -= (1/3);
    }
    var input = get_input();
    var game = get_meta_object();
    if (get_win_state() == 0)
    {
        var _desired_char = string_char_at(game._str, string_length(_str) + 1);
        var _desired_char_press = struct_get(input.key, _desired_char + "_press");
        if (input.key.any_press)
        {
            if (_desired_char_press)
            {
                _str += _desired_char;
                array_push(letter_pos, 0);
                array_push(letter_shake, [0, 0]);
                image_index = 1;
                _voice_clip_letter(_desired_char);
                if (string_length(_str) == string_length(game._str))
                {
                    sfx_play(mt1_snd_win, 0, 1, 0, get_game_speed());
                    game_win();
                    sprite_index = mt1_spr_win;
                    image_index = 0;
                    image_speed = get_game_speed();
                }
            }
            else
            {
                _str = "";
                letter_pos = [];
                letter_shake = [];
                sfx_play(ms12_snd_error);
            }
        }
    }
    else
    {
    }
    for (var i = 0; i < array_length(letter_pos); i++)
    {
        letter_pos[i] = lerp(letter_pos[i], 1, 0.2);
        letter_shake[i] = [choose(-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1), choose(-1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1)];
    }
}

function mt1scr_guy_draw()
{
    var lx = 35;
    var ly = 106;
    for (var i = 1; i <= string_length(_str); i++)
    {
        var _this_lx = lerp(87, lx, letter_pos[i - 1]) + letter_shake[i - 1][0];
        var _this_ly = lerp(163, ly, letter_pos[i - 1]) + letter_shake[i - 1][1];
        var _char = string_char_at(_str, i);
        var _frame = string_pos(_char, _chars) - 1;
        draw_sprite(mt1_spr_letters, _frame, _this_lx, _this_ly);
        lx += 19;
        ly -= 6;
    }
    if (sprite_index == mt1_spr_win)
    {
        _draw_self();
        if (image_index >= (sprite_get_number(sprite_index) - 1))
        {
            image_speed = 0;
        }
    }
    else
    {
        for (var i = 0; i < array_length(sprites); i++)
        {
            var _spr = sprites[i][0];
            var _pos = struct_get(pos, sprites[i][1]);
            draw_sprite(_spr, ceil(image_index), _pos.x, _pos.y);
        }
    }
}

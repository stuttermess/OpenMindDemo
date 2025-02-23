function ibt_sparkle() : inbetween_constructor() constructor
{
    frame_scale = 1;
    lives_scale = 1;
    lives_frame = 0;
    
    get_intro_jingle = function()
    {
        return ibtS_snd_intro;
    };
    
    get_prep_jingle = function()
    {
        return ibtS_snd_prep;
    };
    
    get_win_jingle = function()
    {
        return ibtS_snd_win;
    };
    
    get_lose_jingle = function()
    {
        return ibtS_snd_lose;
    };
    
    get_speedup_jingle = function()
    {
        return ibtS_snd_speedup;
    };
    
    get_boss_jingle = function()
    {
        return -1;
    };
    
    intro_length = 8;
    draws_minigame_surface = true;
    minigame_intro_length = 1;
    minigame_outro_length = 1;
    act3_intro_length = 25;
    
    __cleanup = function()
    {
        if (obj_minigame_controller.endless_mode)
        {
        }
        else
        {
        }
    };
    
    if (obj_minigame_controller.endless_mode)
    {
        intro_length = 12;
    }
    standard_get_ibt_len = get_inbetween_length;
    
    get_inbetween_length = function(arg0)
    {
        if (!instance_exists(obj_minigame_controller))
        {
            return 4;
        }
        var char = obj_minigame_controller.char;
        var act2_start = !obj_minigame_controller.endless_mode && _round == char.act2_round && _lives > 0;
        var act3_start = !obj_minigame_controller.endless_mode && _round == char.act3_round && _lives > 0 && !act3_intro_seen;
        var act_transition = (act2_start || act3_start) && !obj_minigame_controller.endless_mode;
        if (act_transition)
        {
            if (act2_start)
            {
                return 20;
            }
            if (act3_start)
            {
                return act3_intro_length;
            }
        }
        else
        {
            if (arg0 == 2 && act3_intro_seen)
            {
                arg0 = 0;
            }
            return standard_get_ibt_len(arg0);
        }
    };
    
    __init = function()
    {
        lose_musics = [];
        not_lose_musics = [];
        _scene = 0;
        win1_white_flash = 0;
        act = 1;
        act3_intro_seen = false;
        switch (obj_minigame_controller.inbetween_type)
        {
            case 0:
                __on_return();
                break;
            case 4:
                if (obj_minigame_controller.endless_mode || (!obj_minigame_controller.endless_mode && _round > 0))
                {
                    __on_return();
                }
                break;
        }
        win_ibts = [];
        lose_ibts = [];
        available_lose_ibts = [4, 5];
        if (obj_minigame_controller.endless_mode)
        {
            available_win_ibts = [1, 2, 3, 9, 10];
        }
        else
        {
            available_win_ibts = [1, 2, 3];
        }
        array_copy(win_ibts, 0, available_win_ibts, 0, array_length(available_win_ibts));
        array_copy(lose_ibts, 0, available_lose_ibts, 0, array_length(available_lose_ibts));
        num_angle = 0;
        num_scale = 1;
        _round_display = 0;
        audio_sound_loop_start(mus_sparkle_act1, 3.749);
        audio_sound_loop_start(mus_sparkle_act1_lose, 3.749);
        audio_sound_loop_start(mus_sparkle_act2_inst, 7.246);
        audio_sound_loop_start(mus_sparkle_act2_inst_lose, 7.246);
        audio_sound_loop_start(mus_sparkle_act2_vocal, 7.246);
        audio_sound_loop_start(mus_sparkle_act2_vocal_lose, 7.246);
        audio_sound_loop_start(mus_sparkle_act3, 16.875);
        audio_sound_loop_start(mus_sparkle_act3_lose, 16.875);
        music_act1 = mus_sparkle_act1;
        music_act2_inst = mus_sparkle_act2_inst;
        music_act2_vocal = mus_sparkle_act2_vocal;
        act2_vocals_dropped = false;
        act2_ready_to_drop_vocals = false;
        act2_vocal_drop_points = [17.75, 29.63, 41.884, 54.293];
        act2_vocal_drop_point = -1;
        music_act3 = mus_sparkle_act3;
        act2_bus = audio_bus_create();
        act3_bus = audio_bus_create();
        act2_music_emitter = -1;
        act3_music = -1;
        muffle_effect_a2 = audio_effect_create(AudioEffectType.LPF2);
        muffle_effect_a2.cutoff = 50000;
        muffle_effect_a2.q = 1;
        muffle_effect_a3 = audio_effect_create(AudioEffectType.LPF2);
        muffle_effect_a3.cutoff = 50000;
        muffle_effect_a3.q = 1;
        var mus1 = music_act1;
        with (obj_minigame_controller)
        {
            if (!endless_mode)
            {
                char.music_id = mus1;
                if (is_array(game_music) && is_array(char.music_id))
                {
                    for (var i = 0; i < array_length(game_music); i++)
                    {
                        game_music = audio_play_sound_on(master.emit_mus, char.music_id[i], true, 10, 1, 0);
                    }
                }
                else
                {
                    game_music = audio_play_sound_on(master.emit_mus, char.music_id, true, 10, 1, 0);
                }
            }
            use_minigame_music = false;
        }
    };
    
    _place_lives = function()
    {
        return array_create(_lives);
    };
    
    _draw_lives = function()
    {
        var arr = _place_lives();
        for (var i = 0; i < array_length(arr); i++)
        {
            var this = arr[i];
            var _spr = ibtS_spr_lifewin;
            if (success_state == -1)
            {
                _spr = ibtS_spr_lifelose;
            }
            draw_sprite_ext(_spr, lives_frame, this[0], this[1], this[2], this[2], this[3], c_white, 1);
        }
    };
    
    draw_round_number = function(arg0 = _round_display)
    {
        if (!obj_minigame_controller.game_end_freeze)
        {
            var lspr = ibtS_spr_numL;
            var rspr = ibtS_spr_numR;
            if (success_state == -1)
            {
                lspr = ibtS_spr_numL_blue;
                rspr = ibtS_spr_numR_blue;
            }
            draw_sprite_ext(lspr, floor(_round_display / 10), leftnum_x, leftnum_y, 1, 1, num_angle, c_white, 1);
            draw_sprite_ext(rspr, _round_display, rightnum_x, rightnum_y, 1, 1, num_angle, c_white, 1);
        }
    };
    
    start_beat = 0;
    
    __on_return = function()
    {
        start_track_pos = 0;
        if (instance_exists(obj_minigame_controller))
        {
            if (is_array(obj_minigame_controller.game_music))
            {
                if (array_length(obj_minigame_controller.game_music) > 0)
                {
                    start_track_pos = audio_sound_get_track_position(obj_minigame_controller.game_music[array_length(obj_minigame_controller.game_music) - 1]);
                }
            }
            else
            {
                start_track_pos = audio_sound_get_track_position(obj_minigame_controller.game_music);
            }
        }
        start_beat = round(current_beat);
        bubbles = [];
        sound = 
        {
            lose: 
            {
                life_fall: 
                {
                    sound: ibtS_snd_life_fall
                }
            },
            win1: 
            {
                played: 0
            },
            win2: 
            {
                played: 0
            },
            win4: 
            {
                jump1: 
                {
                    sound: ibtS_snd_win4_jump1
                },
                jump2: 
                {
                    sound: ibtS_snd_win4_jump2
                }
            }
        };
        var _structs = [sound];
        for (var i = 0; i < array_length(_structs); i++)
        {
            var _struct = _structs[i];
            var _names = struct_get_names(_struct);
            for (var j = 0; j < array_length(_names); j++)
            {
                var _name = _names[j];
                var _val = struct_get(_struct, _name);
                if (is_struct(_val))
                {
                    array_push(_structs, _val);
                }
                else
                {
                    struct_set(_struct, "played", 0);
                }
            }
        }
        win5_throw_flowers_position = [0, 0];
        win5_throw_flowers = 0;
        win5_flowers = [];
        var act2_start = false;
        var act3_start = false;
        var act_transition = false;
        if (instance_exists(obj_minigame_controller) && !obj_minigame_controller.endless_mode)
        {
            var char = obj_minigame_controller.char;
            act2_start = _round == char.act2_round && _lives > 0;
            act3_start = _round == char.act3_round && _lives > 0;
            act_transition = act2_start || act3_start;
            if (act2_start)
            {
                act = 2;
                _scene = 7;
                char.music_id = mus_sparkle_act2_inst;
                with (obj_minigame_controller)
                {
                    set_game_speed(1.296875);
                    audio_sound_gain(game_music, 0, 500);
                    audio_sound_end_on_fade(game_music);
                }
                act2_music_emitter = audio_emitter_create();
                audio_emitter_gain(act2_music_emitter, audio_emitter_get_gain(master.emit_mus));
                audio_emitter_bus(act2_music_emitter, act2_bus);
                act2_bus.effects[0] = muffle_effect_a2;
                act3_bus.effects[0] = muffle_effect_a3;
                act2_vocals = audio_play_sound_on(act2_music_emitter, music_act2_vocal, true, 10, 1, 0);
                act2_instrumental = audio_play_sound_on(act2_music_emitter, music_act2_inst, true, 10, 1, 0);
                obj_minigame_controller.game_music = [act2_vocals, act2_instrumental];
                array_push(win_ibts, 9, 10);
            }
            if (act3_start)
            {
                if (act3_intro_seen)
                {
                    act_transition = false;
                }
                else
                {
                    act = 3;
                    _scene = 8;
                    char.music_id = music_act3;
                    var _self = self;
                    audio_emitter_bus(master.emit_mus, act3_bus);
                    var _act3_music = audio_play_sound_on(master.emit_mus, char.music_id, true, 10, 0, 0);
                    with (obj_minigame_controller)
                    {
                        clear_gimmicks();
                        set_game_speed(1);
                        array_push(game_music, _act3_music);
                    }
                    act3_music = _act3_music;
                }
            }
        }
        if (!act_transition && success_state == -1 && !obj_minigame_controller.endless_mode)
        {
            stop_lose_musics();
            lose_musics = [];
            not_lose_musics = [];
            if (is_array(obj_minigame_controller.game_music))
            {
                array_copy(not_lose_musics, 0, obj_minigame_controller.game_music, 0, array_length(obj_minigame_controller.game_music));
                for (var i = 0; i < array_length(not_lose_musics); i++)
                {
                    not_lose_musics[i] = [not_lose_musics[i], audio_sound_get_gain(not_lose_musics[i])];
                }
            }
            else
            {
                not_lose_musics = [[obj_minigame_controller.game_music, 1]];
            }
            var _game_music = obj_minigame_controller.game_music;
            var _gain = 0;
            switch (act)
            {
                case 1:
                    lose_musics[0] = sfx_play(mus_sparkle_act1_lose, true, _gain, audio_sound_get_track_position(_game_music), 1, true, undefined, false);
                    break;
                case 2:
                    if (array_length(_game_music) >= 2)
                    {
                        lose_musics[0] = audio_play_sound_on(act2_music_emitter, mus_sparkle_act2_inst_lose, true, 100, _gain, audio_sound_get_track_position(_game_music[0]));
                        lose_musics[1] = audio_play_sound_on(act2_music_emitter, mus_sparkle_act2_vocal_lose, true, 100, _gain * audio_sound_get_gain(_game_music[1]), audio_sound_get_track_position(_game_music[1]));
                    }
                    break;
                case 3:
                    if (array_length(_game_music) >= 1)
                    {
                        lose_musics[0] = sfx_play(mus_sparkle_act3_lose, true, _gain, audio_sound_get_track_position(_game_music[0]), 1, true, undefined, false);
                    }
                    break;
            }
        }
        if (!act_transition)
        {
            switch (success_state)
            {
                default:
                    _scene = choose(1, 2);
                    break;
                case 1:
                    if (array_length(available_win_ibts) == 0)
                    {
                        array_copy(available_win_ibts, 0, win_ibts, 0, array_length(win_ibts));
                    }
                    var ind = irandom(array_length(available_win_ibts) - 1);
                    _scene = available_win_ibts[ind];
                    array_delete(available_win_ibts, ind, 1);
                    break;
                case -1:
                    if (array_length(available_lose_ibts) == 0)
                    {
                        array_copy(available_lose_ibts, 0, lose_ibts, 0, array_length(lose_ibts));
                    }
                    var ind = irandom(array_length(available_lose_ibts) - 1);
                    _scene = available_lose_ibts[ind];
                    array_delete(available_lose_ibts, ind, 1);
                    break;
            }
        }
        faces = [];
        if (_round == 0 && obj_minigame_controller.endless_mode && instanceof(obj_minigame_controller.char) == "gamechar_sparkle")
        {
            _scene = 6;
        }
        minigame_intro_length = 1;
        switch (_scene)
        {
            case 2:
                bubbles_timer = 30;
                
                spawn_bubbles = function()
                {
                    var bubamt = irandom_range(5, 10);
                    for (var i = 0; i < bubamt; i++)
                    {
                        var bx = random_range(-10, 490);
                        var by = random_range(300, 570);
                        var byspd = random_range(2, 6);
                        var bsprite = asset_get_index("ibtSw2_spr_bub" + string(irandom_range(1, 3)));
                        var t = irandom(60);
                        array_push(bubbles, 
                        {
                            x: bx,
                            y: by,
                            x_base: bx,
                            _time: t,
                            yspd: byspd,
                            sprite: bsprite
                        });
                    }
                };
                
                spawn_bubbles();
                break;
            case 3:
                sfx_play(ibtS_snd_win3_spin, 0, 1, 0, get_game_speed());
                break;
            case 4:
                lose_anim_frame = 0;
                lose_anim_speed = sprite_get_speed(ibtSl1_spr_lose1) / 60;
                sfx_play(ibtS_snd_lose1_crash, false, 1, 0, get_game_speed());
                break;
            case 5:
                lose_anim_frame = 0;
                lose_anim_speed = sprite_get_speed(ibtSl2_spr_oh) / 60;
                sfx_play(ibtS_snd_lose2_cry, false, 1, 0, get_game_speed());
                break;
            case 6:
                faces = [];
                last_new_face = 0;
                break;
            case 8:
                minigame_intro_length = act3_intro_length - 16;
                break;
        }
        if (act == 2)
        {
            if (_round >= obj_minigame_controller.char.act2_vocals_out_round)
            {
                act2_ready_to_drop_vocals = true;
                var _trackpos = audio_sound_get_track_position(act2_vocals);
                for (var i = 0; i < array_length(act2_vocal_drop_points) && act2_vocal_drop_point == -1; i++)
                {
                    if (act2_vocal_drop_points[i] > _trackpos)
                    {
                        act2_vocal_drop_point = act2_vocal_drop_points[i];
                    }
                }
            }
        }
    };
    
    stop_lose_musics = function()
    {
        if (array_length(lose_musics) > 0)
        {
            for (var i = 0; i < array_length(lose_musics); i++)
            {
                audio_stop_sound(lose_musics[i]);
            }
        }
    };
    
    __tick = function()
    {
        var upscale = 0;
        var _beat = current_beat % 1;
        var beat_leadin = 0.2;
        var beat_leadout = 0.7;
        if (_beat < beat_leadout)
        {
            var _num = _beat / beat_leadout;
            var ominum = 1 - _num;
            upscale = ominum * ominum * ominum * ominum;
        }
        else if (_beat < (1 - beat_leadin))
        {
            upscale = 0;
        }
        else
        {
            var _num = (_beat - (1 - beat_leadin)) / beat_leadin;
            upscale = _num * _num * _num * _num;
        }
        var _base_mus_vol = audio_emitter_get_gain(master.emit_mus);
        if (!obj_minigame_controller.game_ended)
        {
            if (success_state == -1)
            {
                var _ibtl = obj_minigame_controller.inbetween_length;
                var _cb = _ibtl - inbetween_timer;
                var _losevol = 0;
                if (_cb < 1)
                {
                    _losevol = lerp(0, 1, _cb / 1);
                }
                else if (_cb < (_ibtl - 1))
                {
                    _losevol = 1;
                }
                else
                {
                    _losevol = lerp(1, 0, clamp((_cb - (_ibtl - 1)) / 0.9, 0, 1));
                }
                for (var i = 0; i < array_length(lose_musics); i++)
                {
                    var _setvol = true;
                    switch (asset_get_index(audio_get_name(lose_musics[i])))
                    {
                        case mus_sparkle_act2_vocal_lose:
                            if (act2_vocals_dropped)
                            {
                                _setvol = false;
                            }
                            break;
                    }
                    if (_setvol)
                    {
                        audio_sound_gain(lose_musics[i], _losevol, 0);
                    }
                }
                for (var i = 0; i < array_length(not_lose_musics); i++)
                {
                    audio_sound_gain(not_lose_musics[i][0], (1 - _losevol) * not_lose_musics[i][1], 0);
                }
                if (_losevol <= 0 && _cb > 1)
                {
                    stop_lose_musics();
                }
            }
            else
            {
                for (var i = 0; i < array_length(not_lose_musics); i++)
                {
                    var _setvol = true;
                    switch (asset_get_index(audio_get_name(not_lose_musics[i][0])))
                    {
                        case mus_sparkle_act1:
                            if (act > 1)
                            {
                                _setvol = false;
                            }
                            break;
                    }
                    if (_setvol)
                    {
                        audio_sound_gain(not_lose_musics[i][0], not_lose_musics[i][1], 0);
                    }
                }
            }
        }
        if (_beat > 0.75 && act == 3)
        {
            act3_intro_seen = true;
        }
        frame_scale = 1 + (upscale * 0.1);
        lives_scale = 1 + (upscale * 0.5);
        var lifesprite = ibtS_spr_lifewin;
        if (success_state == -1)
        {
            lifesprite = ibtS_spr_lifelose;
            lives_scale = 1 + (upscale * 0.1);
        }
        lives_frame += (sprite_get_speed(lifesprite) / room_speed);
        lives_frame %= sprite_get_number(lifesprite);
        num_angle = dsin(((current_beat % 2) / 2) * 360) * 6;
        num_scale = 1;
        _round_display = _round;
        switch (_scene)
        {
            case 1:
                win1_white_flash -= 0.022222222222222223;
                break;
            case 2:
                for (var i = 0; i < array_length(bubbles); i++)
                {
                    var _bub = bubbles[i];
                    _bub.y -= _bub.yspd;
                    _bub._time += _bub.yspd;
                    _bub.x = _bub.x_base + dsin(_bub._time * 5);
                    if (_bub.y < -40)
                    {
                        array_delete(bubbles, i, 1);
                        i--;
                    }
                }
                bubbles_timer--;
                if (bubbles_timer <= 0)
                {
                    bubbles_timer = 30;
                    spawn_bubbles();
                }
                break;
            case 4:
                lose_anim_frame += lose_anim_speed;
                lose_anim_frame %= 4;
                break;
            case 5:
                lose_anim_frame += lose_anim_speed;
                lose_anim_frame %= 3;
                break;
            case 6:
                if (current_beat >= 4)
                {
                    _scene = 1;
                    win1_white_flash = 1.5;
                }
                break;
            case 9:
                break;
            case 10:
                if (win5_throw_flowers == 1)
                {
                    sfx_play(ibtS_snd_win5_toss, false, 1, 0, get_game_speed());
                    win5_throw_flowers = 2;
                    var _throw_amt = irandom_range(3, 5);
                    for (var i = 0; i < _throw_amt; i++)
                    {
                        var _flower = 
                        {
                            spawn_beat: current_beat,
                            frame: irandom(2),
                            x: 0,
                            y: 0,
                            xv: 0,
                            yv: 0,
                            falltime: 0,
                            x_mod: 0,
                            y_mod: 0
                        };
                        _flower.x = win5_throw_flowers_position[0];
                        _flower.y = win5_throw_flowers_position[1];
                        var _dir = 60 + (((i / (_throw_amt - 1)) - 0.5) * 15);
                        var _len = random_range(10, 12);
                        _flower.xv = lengthdir_x(_len, _dir);
                        _flower.yv = lengthdir_y(_len, _dir) / 2;
                        array_push(win5_flowers, _flower);
                    }
                }
                var gamespd = get_game_speed();
                for (var i = 0; i < array_length(win5_flowers); i++)
                {
                    var _flower = win5_flowers[i];
                    with (_flower)
                    {
                        yv += (0.5 * gamespd);
                        yv = min(yv, 4);
                        xv += (sign(0 - xv) * 0.2 * gamespd);
                        var _floor_y = 230;
                        if (abs(xv) < 2 && yv > 1 && y < _floor_y)
                        {
                            falltime += gamespd;
                            var _fall_pendulum = dsin((falltime / 30) * 360);
                            x_mod = _fall_pendulum * 3;
                            y_mod = abs(_fall_pendulum) * -3;
                        }
                        else
                        {
                            falltime = 0;
                            x_mod = lerp(x_mod, 0, 0.3 * gamespd);
                            y_mod = lerp(y_mod, 0, 0.3 * gamespd);
                            x = lerp(x, x + x_mod, 0.3 * gamespd);
                            y = lerp(y, y + y_mod, 0.3 * gamespd);
                        }
                        x += (xv * gamespd);
                        y += (yv * gamespd);
                        if (y > _floor_y)
                        {
                            xv = 0;
                            yv = 0;
                        }
                        y = clamp(y, 0, _floor_y);
                    }
                }
                break;
        }
        if (act2_ready_to_drop_vocals && act2_vocal_drop_point != -1)
        {
            var _pos = audio_sound_get_track_position(act2_vocals);
            if (_pos >= act2_vocal_drop_point)
            {
                act2_vocals_dropped = true;
                audio_sound_gain(act2_vocals, 0, 0);
            }
        }
        if (act > 1)
        {
            var _muffle_start_round = obj_minigame_controller.char.act2_muffle_start_round;
            if (_round >= _muffle_start_round)
            {
                var muffle_low = 100;
                if (act == 2)
                {
                    muffle_effect_a2.cutoff = lerp(muffle_effect_a2.cutoff, muffle_low, 0.01);
                    muffle_effect_a3.cutoff = muffle_effect_a2.cutoff;
                    audio_emitter_gain(act2_music_emitter, audio_emitter_get_gain(master.emit_mus));
                }
                else if (act == 3)
                {
                    var _cb = current_beat - start_beat;
                    if (_scene != 8)
                    {
                        _cb = 50;
                    }
                    audio_sound_gain(act2_vocals, 0, 0);
                    var _a2_gain = lerp(1, 0, clamp(_cb / 2, 0, 1));
                    audio_sound_gain(act2_instrumental, _a2_gain, 0);
                    if (_cb < 4)
                    {
                        audio_emitter_gain(act2_music_emitter, audio_emitter_get_gain(master.emit_mus));
                        muffle_effect_a2.cutoff = lerp(muffle_effect_a2.cutoff, muffle_low, 0.01);
                        var _a3_lerp = clamp(_cb / 4, 0, 1);
                        muffle_effect_a3.cutoff = lerp(muffle_low, 50000, lerp_easeIn(_a3_lerp));
                        audio_sound_gain(act3_music, _a3_lerp, 0);
                    }
                    else
                    {
                        audio_bus_clear_emitters(act2_bus);
                        audio_bus_clear_emitters(act3_bus);
                        if (audio_emitter_exists(act2_music_emitter))
                        {
                            audio_emitter_free(act2_music_emitter);
                        }
                        if (audio_is_playing(act2_vocals))
                        {
                            audio_stop_sound(act2_vocals);
                        }
                        if (audio_is_playing(act2_instrumental))
                        {
                            audio_stop_sound(act2_instrumental);
                        }
                        muffle_effect_a2.bypass = true;
                        muffle_effect_a3.bypass = true;
                    }
                }
            }
            else
            {
                audio_emitter_gain(act2_music_emitter, audio_emitter_get_gain(master.emit_mus));
            }
        }
    };
    
    __draw = function()
    {
        if (array_length(lose_musics) > 0)
        {
            var _pause = obj_minigame_controller.paused;
            for (var i = 0; i < array_length(lose_musics); i++)
            {
                if (_pause)
                {
                    if (!audio_is_paused(lose_musics[i]))
                    {
                        audio_pause_sound(lose_musics[i]);
                    }
                }
                else if (audio_is_paused(lose_musics[i]))
                {
                    audio_resume_sound(lose_musics[i]);
                }
            }
        }
        if (_scene != 0)
        {
            draw_clear_alpha(c_black, 0);
        }
        leftnum_x = 0;
        leftnum_y = 0;
        rightnum_x = 0;
        rightnum_y = 0;
        var hide_controlprompt = false;
        var standard_mg_intro = true;
        switch (_scene)
        {
            case 0:
                if (current_beat < 7.8)
                {
                    obj_minigame_controller.next_mg.use_prompt = false;
                    display_prompt();
                }
                shader_set_wavy(ibtS_spr_bg, current_beat, 1, 100, 3, 0, 0, 0);
                draw_sprite(ibtS_spr_bg, 0, 0, 0);
                shader_reset();
                var overlay_y = 0;
                if (current_beat >= 3.5)
                {
                    overlay_y += (270 * ((current_beat - 3.5) * 2.5));
                }
                var girlframe = 0;
                if (current_beat >= 4)
                {
                    girlframe = clamp((current_beat - 4) / 4, 0, 1);
                    girlframe *= (sprite_get_number(ibtS_spr_introfull) - 1);
                }
                draw_sprite(ibtS_spr_introfull, girlframe, 0, 0);
                gpu_set_blendmode_multiply();
                draw_sprite(ibtS_spr_overlay, 0, 0, overlay_y);
                gpu_set_blendmode(bm_normal);
                var sil_frame = 0;
                var sil_alpha = 0;
                if (current_beat < 1)
                {
                    sil_alpha = clamp(1 - current_beat, 0, 1);
                }
                if (current_beat >= 2 && current_beat < 3)
                {
                    sil_frame = 1;
                    sil_alpha = clamp(1 - (current_beat - 2), 0, 1);
                }
                draw_sprite_ext(ibtS_spr_sillouette, sil_frame, 0, 0, 1, 1, 0, c_white, sil_alpha);
                break;
            case 1:
                draw_clear(#E2ADFF);
                var hearts_x = current_beat * 4;
                var hearts_y = -hearts_x;
                gpu_set_blendmode_multiply();
                draw_sprite_tiled_ext(ibtSw1_spr_multiplyheartbg, 0, hearts_x, hearts_y, 0.9, 0.9, c_white, 1);
                gpu_set_blendmode(bm_normal);
                draw_sprite_tiled_ext(ibtSw1_spr_singleheart, 0, hearts_x, hearts_y, 0.9, 0.9, c_white, 1);
                draw_sprite(ibtSw1_spr_bottom, 0, 0, 270);
                var tri_scroll = (current_beat % 1) * 32;
                gpu_set_blendmode_multiply();
                for (var i = -1; i < 17; i++)
                {
                    draw_sprite_ext(ibtSw1_spr_triangle, 0, tri_scroll + (i * 32), 0, 1, -1, 0, c_white, 1);
                    draw_sprite(ibtSw1_spr_triangle, 0, -tri_scroll + (i * 32), 270);
                }
                gpu_set_blendmode(bm_normal);
                gpu_set_blendmode_multiply();
                draw_sprite(ibtSw1_spr_shadow, 0, 480, 270);
                gpu_set_blendmode(bm_normal);
                var anim_frame = (sprite_get_number(ibtSw1_spr_girl) - 1) * ((current_beat / 2) % 1);
                draw_sprite(ibtSw1_spr_girl, anim_frame, 0, 0);
                var _pitch = get_game_speed();
                switch (floor(anim_frame))
                {
                    case 0:
                    case 11:
                        if (sound.win1.played == 0)
                        {
                            sound.win1.played = 1;
                            sfx_play(ibtS_snd_win1_bob1, false, 1, 0, _pitch);
                        }
                        break;
                    case 5:
                    case 15:
                        sound.win1.played = 0;
                        break;
                }
                
                _place_lives = function()
                {
                    var cx = 90;
                    var cy = 110;
                    var len = 50;
                    var ang_change = 360 / _lives;
                    var lives_rot = dsin(((current_beat % 2) / 2) * 360) * 30;
                    var arr = [];
                    for (var i = 0; i < _lives; i++)
                    {
                        var dir = 67.5 + (ang_change * i);
                        var lx = cx + lengthdir_x(len, dir);
                        var ly = cy + lengthdir_y(len, dir);
                        array_push(arr, [lx, ly, lives_scale, lives_rot]);
                    }
                    return arr;
                };
                
                _draw_lives();
                leftnum_x = 54;
                leftnum_y = 207;
                rightnum_x = 118;
                rightnum_y = 207;
                draw_round_number();
                draw_set_alpha(win1_white_flash);
                draw_rectangle(-1, -1, 481, 271, false);
                draw_set_alpha(1);
                break;
            case 2:
                var hori_reps = 6;
                for (var i = 0; i < 10; i++)
                {
                    var scrolldir = 1;
                    if ((i % 2) == 0)
                    {
                        scrolldir *= -1;
                    }
                    var row_x = (scrolldir * (current_beat % 8) * 15) + (i * 67);
                    var row_y = i * 29;
                    var j = -1 - i;
                    while (j < (hori_reps + i))
                    {
                        draw_sprite(ibtSw2_spr_creatures, current_beat + i, row_x + (120 * j), row_y);
                        j++;
                    }
                }
                blendmode_set_add();
                for (var i = 0; i < array_length(bubbles); i++)
                {
                    var _bub = bubbles[i];
                    draw_sprite_ext(_bub.sprite, 0, _bub.x, _bub.y, 0.95, 0.95, 0, c_white, 1);
                }
                blendmode_reset();
                leftnum_x = 90;
                leftnum_y = 135;
                rightnum_x = 390;
                rightnum_y = 135;
                draw_round_number();
                
                _place_lives = function()
                {
                    var lives_rot = dsin(((current_beat % 2) / 2) * 360) * 30;
                    var arr = [[40, 70], [115, 60], [365, 60], [440, 70]];
                    if (array_length(arr) > _lives)
                    {
                        array_delete(arr, _lives, array_length(arr) - _lives);
                    }
                    for (var i = 0; i < array_length(arr); i++)
                    {
                        arr[i][2] = lives_scale;
                        arr[i][3] = lives_rot;
                    }
                    return arr;
                };
                
                _draw_lives();
                gpu_set_blendmode_multiply();
                draw_sprite(ibtSw2_spr_bgtint, 0, 0, 0);
                gpu_set_blendmode(bm_normal);
                var beatmod = 0;
                if (obj_minigame_controller.endless_mode && (start_beat % 2) == 1)
                {
                    beatmod = 1;
                }
                var anim_frame = (sprite_get_number(ibtSw2_spr_headbump) - 1) * (((current_beat + beatmod) / 4) % 1);
                draw_sprite(ibtSw2_spr_headbump, anim_frame, 0, 0);
                var _pitch = get_game_speed();
                switch (floor(anim_frame))
                {
                    case 0:
                    case 11:
                        if (sound.win2.played == 0)
                        {
                            sound.win2.played = 1;
                            sfx_play(ibtS_snd_win2_bob, false, 1, 0, _pitch);
                        }
                        break;
                    default:
                        sound.win2.played = 0;
                        break;
                }
                break;
            case 3:
                var bg_scale = 1;
                var bgscaleprog = current_beat % 1;
                if (obj_minigame_controller.inbetween_type == 2)
                {
                    bgscaleprog = (current_beat / 2) % 1;
                }
                if (bgscaleprog < 0.9)
                {
                    var prog = clamp(bgscaleprog / 0.5, 0, 1);
                    prog = lerp_easeOut(prog);
                    bg_scale = 1.025 - (prog * 0.025);
                }
                else if (bgscaleprog >= 0.85)
                {
                    var prog = clamp((bgscaleprog - 0.85) / 0.15, 0, 1);
                    prog = lerp_easeIn(prog);
                    bg_scale = 1 + (prog * 0.025);
                }
                var bg_x = 0 - ((480 * (bg_scale - 1)) / 2);
                var bg_y = 0 - ((270 * (bg_scale - 1)) / 2);
                draw_sprite_ext(ibtSw3_spr_bg, 0, bg_x, bg_y, bg_scale, bg_scale, 0, c_white, 1);
                blendmode_set_hardlight();
                var crch_rot = dcos(current_beat * 180) * 10;
                var crch_scl = 1;
                var crch_sclprog = current_beat % 1;
                if (crch_sclprog < 0.9)
                {
                    var prog = clamp(crch_sclprog / 0.5, 0, 1);
                    prog = lerp_easeOut(prog);
                    crch_scl = 1.025 - (prog * 0.025);
                }
                else if (crch_sclprog >= 0.85)
                {
                    var prog = clamp((crch_sclprog - 0.85) / 0.15, 0, 1);
                    prog = lerp_easeIn(prog);
                    crch_scl = 1 + (prog * 0.025);
                }
                crch_scl = 1 + ((crch_scl - 1) * 20);
                draw_sprite_ext(ibtSw3_spr_c1, current_beat, 62, 61, crch_scl, crch_scl, -crch_rot, c_white, 1);
                draw_sprite_ext(ibtSw3_spr_c2, current_beat, 59, 164, crch_scl, crch_scl, crch_rot, c_white, 1);
                draw_sprite_ext(ibtSw3_spr_c3, current_beat, 256, 247, crch_scl, crch_scl, -crch_rot, c_white, 1);
                draw_sprite_ext(ibtSw3_spr_c4, current_beat, 330, 114, crch_scl, crch_scl, crch_rot, c_white, 1);
                draw_sprite_ext(ibtSw3_spr_c5, current_beat, 424, 130, crch_scl, crch_scl, -crch_rot, c_white, 1);
                var anim_frame = clamp((current_beat - start_beat - 0.5) / 3, 0, 1) * 30;
                if (anim_frame == 30 && (floor(current_beat * 2) % 2) == 0)
                {
                    anim_frame -= 4;
                }
                draw_sprite(ibtSw3_spr_spin, anim_frame, 208, 127);
                leftnum_x = 360;
                leftnum_y = 222;
                rightnum_x = 422;
                rightnum_y = 214;
                draw_round_number();
                
                _place_lives = function()
                {
                    var lives_rot = dsin(((current_beat % 2) / 2) * 360) * 30;
                    var arr = [[40, 260], [115, 250], [365, 65], [440, 55]];
                    if (array_length(arr) > _lives)
                    {
                        array_delete(arr, _lives, array_length(arr) - _lives);
                    }
                    for (var i = 0; i < array_length(arr); i++)
                    {
                        arr[i][2] = lives_scale;
                        arr[i][3] = lives_rot;
                    }
                    return arr;
                };
                
                _draw_lives();
                blendmode_reset();
                break;
            case 9:
                draw_clear(#DD9CFF);
                
                _place_lives = function()
                {
                    var lives_rot = dsin(((current_beat % 2) / 2) * 360) * 30;
                    var arr = [[40, 81], [106, 60], [374, 60], [440, 81]];
                    if (array_length(arr) > _lives)
                    {
                        array_delete(arr, _lives, array_length(arr) - _lives);
                    }
                    for (var i = 0; i < array_length(arr); i++)
                    {
                        arr[i][2] = lives_scale;
                        arr[i][3] = lives_rot;
                    }
                    return arr;
                };
                
                var _rows = 7;
                var _per_row = 7;
                var _row_separation = 35;
                var _sparkle_separation = 122;
                for (var i = 0; i < _rows; i++)
                {
                    var _lerp = i / (_rows - 1);
                    var _row_y = lerp(0, 270, _lerp);
                    var _yy = _row_y;
                    var _fade = lerp(0.8, 0, _lerp);
                    var _cb = current_beat % 2;
                    var offsetrow = (i % 2) == 1;
                    var _jump = min(dsin(360 * ((_cb + real(offsetrow)) / 2)), 1);
                    if (_jump < 0)
                    {
                        if (offsetrow)
                        {
                            sound.win4.jump1.played = 0;
                        }
                        else
                        {
                            sound.win4.jump2.played = 0;
                        }
                        _jump = 0;
                        var _landlerp = clamp((current_beat % 1) / 0.25, 0, 1);
                        _yy += lerp(7, 0, _landlerp);
                    }
                    else if (offsetrow)
                    {
                        if (sound.win4.jump1.played == 0)
                        {
                            sound.win4.jump1.played = 1;
                        }
                    }
                    else if (sound.win4.jump2.played == 0)
                    {
                        sound.win4.jump2.played = 1;
                    }
                    var _jump_height = 34;
                    _yy -= (_jump * _jump_height);
                    var _start_x = -9;
                    if ((i % 2) == 1)
                    {
                        _start_x = 45;
                    }
                    _start_x -= (current_beat * 10 * (1 + ((1 / _fade) * 0.5)));
                    _start_x %= _sparkle_separation;
                    var _xx = _start_x;
                    var _frame = _jump > 0;
                    for (var j = 0; j < _per_row; j++)
                    {
                        draw_sprite(ibtSw4_spr_jump, _frame, _xx, _yy);
                        draw_sprite_ext(ibtSw4_spr_jump_pink, _frame, _xx, _yy, 1, 1, 0, c_white, _fade);
                        _xx += _sparkle_separation;
                    }
                }
                if (sound.win4.jump1.played == 1)
                {
                    sound.win4.jump1.played = 2;
                    sfx_play(ibtS_snd_win4_jump1, 0, 1, 0, get_game_speed());
                }
                if (sound.win4.jump2.played == 1)
                {
                    sound.win4.jump2.played = 2;
                    sfx_play(ibtS_snd_win4_jump2, 0, 1, 0, get_game_speed());
                }
                leftnum_x = 204;
                leftnum_y = 45;
                rightnum_x = 276;
                rightnum_y = 45;
                draw_round_number();
                _draw_lives();
                break;
            case 10:
                var _base_scroll = -50;
                var _bg_base_x = 240;
                var _scroll_per_beat = 30;
                var _bg_y = 135;
                var layer_scroll_rate = [0, 0, 0.07, 0.1, 0.175, 0.25, 0.3, 0.65, 1, 1.1];
                var layer_offset = [-50, -50, -50, 0, 160, 160, 160, 160, 160, 160];
                var _layer_scroll = 0;
                for (var i = 0; i < (sprite_get_number(ibtSw5_spr_layers) - 1); i++)
                {
                    _layer_scroll = (_base_scroll - layer_offset[i]) + (layer_scroll_rate[i] * _scroll_per_beat * (current_beat - start_beat));
                    var _layer_x = _bg_base_x - _layer_scroll;
                    var _layer_y = _bg_y;
                    draw_sprite(ibtSw5_spr_layers, i, _layer_x, _layer_y);
                }
                var _beat_offset = 0.3;
                var _cb = (current_beat + _beat_offset) % 1;
                var _sp_x = 161;
                var _sp_y = 180;
                var _sp_x_per_beat = 10;
                var _jump_height = 60;
                _sp_y -= (dsin(_cb * 180) * _jump_height);
                _sp_x -= 50;
                _sp_x += ((current_beat - start_beat) * _sp_x_per_beat);
                var _frame = 1;
                if (_cb < (0.75 + _beat_offset) && _cb > (0.05 + _beat_offset))
                {
                    _frame = 0;
                    if (win5_throw_flowers == 0)
                    {
                        win5_throw_flowers = 1;
                        win5_throw_flowers_position = [(_sp_x - 58) + 87, (_sp_y - 58) + 46];
                    }
                }
                else
                {
                    win5_throw_flowers = 0;
                }
                draw_sprite(ibtSw5_spr_her, _frame, _sp_x, _sp_y);
                for (var i = 0; i < array_length(win5_flowers); i++)
                {
                    var _flower = win5_flowers[i];
                    var _x = _flower.x - (_scroll_per_beat * (current_beat - _flower.spawn_beat));
                    var _y = _flower.y;
                    _x += _flower.x_mod;
                    _y += _flower.y_mod;
                    _frame = _flower.frame;
                    draw_sprite(ibtSw5_spr_flower, _frame, _x, _y);
                    if (_x < -20)
                    {
                        array_delete(win5_flowers, array_get_index(win5_flowers, _flower), 1);
                        i--;
                    }
                }
                for (var i = 9; i < sprite_get_number(ibtSw5_spr_layers); i++)
                {
                    _layer_scroll = (_base_scroll - layer_offset[i]) + (layer_scroll_rate[i] * _scroll_per_beat * (current_beat - start_beat));
                    var _layer_x = _bg_base_x - _layer_scroll;
                    var _layer_y = _bg_y;
                    draw_sprite(ibtSw5_spr_layers, i, _layer_x, _layer_y);
                }
                
                _place_lives = function()
                {
                    var lives_rot = dsin(((current_beat % 2) / 2) * 360) * 30;
                    var arr = [[447, 58], [447, 122], [447, 188], [447, 257]];
                    if (array_length(arr) > _lives)
                    {
                        array_delete(arr, _lives, array_length(arr) - _lives);
                    }
                    for (var i = 0; i < array_length(arr); i++)
                    {
                        arr[i][2] = lives_scale;
                        arr[i][3] = lives_rot;
                    }
                    return arr;
                };
                
                _draw_lives();
                leftnum_x = 53;
                leftnum_y = 48;
                rightnum_x = 125;
                rightnum_y = 48;
                draw_round_number();
                break;
            case 4:
                draw_clear_alpha(c_black, 1);
                draw_sprite(ibtSl1_spr_bgblue, 0, 0, 0);
                
                var _lerpeaseoutbounce = function(arg0)
                {
                    var n1 = 7.5625;
                    var d1 = 2.75;
                    if (arg0 < (1 / d1))
                    {
                        return n1 * arg0 * arg0;
                    }
                    else if (arg0 < (2 / d1))
                    {
                        arg0 -= (1.5 / d1);
                        return (n1 * arg0 * arg0) + 0.75;
                    }
                    else if (arg0 < (2.5 / d1))
                    {
                        arg0 -= (2.25 / d1);
                        return (n1 * arg0 * arg0) + 0.9375;
                    }
                    else
                    {
                        arg0 -= (2.625 / d1);
                        return (n1 * arg0 * arg0) + 0.984375;
                    }
                };
                
                var wompdown = clamp((current_beat - start_beat - 0) / 3, 0, 1);
                wompdown = _lerpeaseoutbounce(wompdown);
                gpu_set_blendmode_multiply();
                draw_sprite(ibtSl1_spr_womp, 0, 0, -270 * (1 - wompdown));
                gpu_set_blendmode(bm_normal);
                draw_sprite(ibtSl1_spr_badaura, 0, 240, 135);
                draw_sprite(ibtSl1_spr_lose1, lose_anim_frame, 240, 270);
                var mask_sf = surface_create(480, 270);
                var targ = surface_get_target();
                surface_reset_target();
                surface_set_target(mask_sf);
                var maskdown = clamp((current_beat - start_beat - 0.5) / 6, 0, 1);
                maskdown = lerp_easeOut(maskdown);
                draw_sprite(ibtSl1_spr_lose1_mask, lose_anim_frame, 0, 0);
                gpu_set_colorwriteenable(1, 1, 1, 0);
                draw_sprite(ibtSl1_spr_sparklemask, 0, 0, -270 * (1 - maskdown));
                gpu_set_colorwriteenable(1, 1, 1, 1);
                draw_sprite(ibtSl1_spr_lose1_invert, lose_anim_frame, 0, 0);
                surface_reset_target();
                surface_set_target(targ);
                gpu_set_blendmode_multiply();
                draw_surface(mask_sf, 0, 0);
                gpu_set_blendmode(bm_normal);
                surface_free(mask_sf);
                var al = clamp((current_beat - start_beat) / 3.5, 0, 1);
                al = lerp_easeOut(al);
                gpu_set_blendmode_multiply();
                draw_sprite_ext(ibtSl1_spr_multiply, 0, 0, 0, 1, 1, 0, c_white, al);
                gpu_set_blendmode(bm_normal);
                leftnum_x = 89;
                leftnum_y = 135;
                rightnum_x = 151;
                rightnum_y = 135;
                draw_round_number();
                
                _place_lives = function()
                {
                    var lives_rot = dsin(((current_beat % 2) / 2) * 360) * 10;
                    var arr = [];
                    for (var i = 0; i < (_lives + 1); i++)
                    {
                        var thisang = lives_rot;
                        var thisscale = lives_scale;
                        var sep = 60;
                        var thisx = 425;
                        var thisy = 135 + ((i - 1.5) * sep);
                        if (i >= _lives)
                        {
                            thisang = 0;
                            thisscale = 1;
                            var cb = current_beat - start_beat - 1;
                            if (cb > 0)
                            {
                                if (sound.lose.life_fall.played == 0)
                                {
                                    sfx_play(ibtS_snd_life_fall, 0, 1, 0, get_game_speed());
                                    sound.lose.life_fall.played = 1;
                                }
                                var xchange = sign(240 - thisx) * cb * 50;
                                thisx += xchange;
                                var tt = -abs(xchange);
                                thisang = tt * 10 * sign(xchange);
                                
                                var formuler = function(arg0)
                                {
                                    arg0 *= 1.5;
                                    var hh = 0;
                                    arg0 += hh;
                                    return -(-power(arg0, 2) + (-70 * arg0)) / 20;
                                };
                                
                                thisscale = max(2 - cb, 1);
                                var ychange = formuler(tt);
                                thisy += ychange;
                            }
                        }
                        array_push(arr, [thisx, thisy, thisscale, thisang]);
                    }
                    return arr;
                };
                
                _draw_lives();
                break;
            case 5:
                draw_sprite(ibtSl2_spr_bg, 0, 0, 0);
                var heartsdown = clamp((current_beat - start_beat - 0.5) / 3, 0, 1);
                heartsdown = lerp_easeOut(heartsdown);
                var hearts_y = -270 * (1 - heartsdown);
                draw_sprite(ibtSl2_spr_hearts, 0, 0, hearts_y);
                var mask_sf = surface_create(480, 270);
                var targ = surface_get_target();
                surface_reset_target();
                surface_set_target(mask_sf);
                draw_sprite(ibtSl2_spr_hearts, 1, 0, hearts_y);
                gpu_set_colorwriteenable(1, 1, 1, 0);
                draw_sprite(ibtSl2_spr_multiplyheartgradient, 0, 0, 0);
                gpu_set_colorwriteenable(1, 1, 1, 1);
                draw_sprite(ibtSl2_spr_hearts, 2, 0, hearts_y);
                draw_rectangle(-1, hearts_y + 270, 481, 271, false);
                surface_reset_target();
                surface_set_target(targ);
                gpu_set_blendmode_multiply();
                draw_surface(mask_sf, 0, 0);
                gpu_set_blendmode(bm_normal);
                surface_free(mask_sf);
                var al = clamp((current_beat - start_beat) / 3.5, 0, 1);
                al = lerp_easeOut(al);
                leftnum_x = 125;
                leftnum_y = 90;
                rightnum_x = 186;
                rightnum_y = 92;
                draw_round_number();
                
                _place_lives = function()
                {
                    var lives_rot = dsin(((current_beat % 2) / 2) * 360) * 10;
                    var arr = [];
                    for (var i = 0; i < (_lives + 1); i++)
                    {
                        var thisang = lives_rot;
                        var thisscale = lives_scale;
                        var sep = 60;
                        var thisx = 55;
                        var thisy = 135 + ((i - 1.5) * sep);
                        if (i >= _lives)
                        {
                            thisang = 0;
                            thisscale = 1;
                            var cb = current_beat - start_beat - 1;
                            if (cb > 0)
                            {
                                if (sound.lose.life_fall.played == 0)
                                {
                                    sfx_play(ibtS_snd_life_fall, 0, 1, 0, get_game_speed());
                                    sound.lose.life_fall.played = 1;
                                }
                                var xchange = sign(240 - thisx) * cb * 50;
                                thisx += xchange;
                                var tt = -abs(xchange);
                                thisang = tt * 10 * sign(xchange);
                                
                                var formuler = function(arg0)
                                {
                                    arg0 *= 1.5;
                                    var hh = 0;
                                    arg0 += hh;
                                    return -(-power(arg0, 2) + (-110 * arg0)) / 20;
                                };
                                
                                thisscale = max(2 - cb, 1);
                                var ychange = formuler(tt);
                                thisy += ychange;
                            }
                        }
                        array_push(arr, [thisx, thisy, thisscale, thisang]);
                    }
                    return arr;
                };
                
                _draw_lives();
                gpu_set_blendmode_multiply();
                draw_sprite(ibtSl2_spr_multiplyfilter, 0, 0, 0);
                gpu_set_blendmode(bm_normal);
                draw_sprite(ibtSl2_spr_oh, lose_anim_frame, 480, 270);
                break;
            case 6:
                draw_clear(c_black);
                var _frames = [2, 1, 0, 3];
                for (var i = 0; i < 4; i++)
                {
                    var _frame = _frames[i];
                    var _angle = _frame * 90;
                    var _beat = i;
                    var _x = 240;
                    var _y = 135;
                    var _cb = current_beat;
                    var _dist = 300;
                    var _lerp = max(_cb - _beat, 0);
                    var _peak = 0.5;
                    if (_lerp < _peak)
                    {
                        _dist *= (1 - lerp_easeOutCubic(_lerp / _peak));
                    }
                    else
                    {
                        _lerp = (_lerp - _peak) / ((1 - _peak) * 5);
                        _dist *= (1 - lerp_easeOutSine(clamp(1 - _lerp, 0, 1)));
                    }
                    _x += lengthdir_x(_dist, _angle);
                    _y += lengthdir_y(_dist, _angle);
                    draw_sprite(ibtS_endlessintro_hers, _frame, _x, _y);
                }
                break;
            case 7:
                var center_x = get_screen_width() / 2;
                var center_y = get_screen_height() / 2;
                var _scale = 1;
                var _cb = current_beat - start_beat;
                var old_mat = matrix_get(2);
                var keyframes = 
                {
                    bg: [[0, 0, lerp_easeOut], [7, 1, -1], [18, 1, lerp_easeInBack], [21, 5, -1]],
                    bunnies: [[0, 1.8, lerp_easeOut], [7, 1, -1], [18, 1, lerp_easeIn], [21, 9, -1]],
                    pandora: [[0, 4, lerp_easeOut], [6, 1, -1], [18, 1, lerp_easeInBack], [21, 10, -1]]
                };
                _scale = lerp(0, 1, lerp_easeOut(clamp(_cb / 2, 0, 1)));
                _scale = value_from_keyframes(keyframes.bg, _cb);
                matrix_set(2, matrix_build(center_x, center_y, 0, 0, 0, 0, _scale, _scale, _scale));
                draw_sprite_ext(ibtSa2_spr_bg, 0, 0, 0, 5, 5, 0, c_white, 1);
                _scale = lerp(1.8, 1, lerp_easeOut(clamp(_cb / 4, 0, 1)));
                _scale = value_from_keyframes(keyframes.bunnies, _cb);
                matrix_set(2, matrix_build(center_x, center_y, 0, 0, 0, 0, _scale, _scale, _scale));
                draw_sprite(ibtSa2_spr_bunnies, current_beat * 2, 0, 0);
                _scale = lerp(4, 1, lerp_easeOut(clamp(_cb / 3, 0, 1)));
                _scale = value_from_keyframes(keyframes.pandora, _cb);
                var _panda_y = 0;
                matrix_set(2, matrix_build(center_x, center_y, 0, 0, 0, 0, _scale, _scale, _scale));
                spinnies = [ibtSa2_spr_starlightright, ibtSa2_spr_levelup, ibtSa2_spr_starlightleft, ibtSa2_spr_speedup, ibtSa2_spr_cat];
                var spinnies_start_beat = 1;
                var _rotation = (_cb - spinnies_start_beat) * ((90 / array_length(spinnies)) * 4);
                for (var i = 0; i < array_length(spinnies); i++)
                {
                    var _len = 160;
                    var _dir = 50 + _rotation + (360 * (-i / array_length(spinnies)));
                    var _x = lengthdir_x(_len, _dir);
                    var _y = lengthdir_y(1, _dir);
                    var _z = -lengthdir_y(_len, _dir);
                    _scale = 1 + lengthdir_y(0.3, _dir);
                    var _xscale = _scale;
                    var _yscale = _scale;
                    var _frame = (sprite_get_number(spinnies[i]) - 1) * (_cb % 1);
                    var _visible = _cb - spinnies_start_beat - i;
                    spinnies[i] = [spinnies[i], _x, _y, _z, _xscale, _yscale, _frame, _visible];
                }
                
                var draw_spinnies = function(arg0, arg1, arg2)
                {
                    for (var i = 0; i < array_length(spinnies); i++)
                    {
                        var _spinny = spinnies[i];
                        var _spr = _spinny[0];
                        var _x = arg0 + _spinny[1];
                        var _y = arg1 + _spinny[2];
                        var _z = _spinny[3];
                        var _xscale = _spinny[4];
                        var _yscale = _spinny[5];
                        var _frame = _spinny[6];
                        var _show = _spinny[7];
                        if (arg2)
                        {
                            _show = _show && _z < 0;
                        }
                        else
                        {
                            _show = _show && _z > 0;
                        }
                        if (_show)
                        {
                            draw_sprite_ext(_spr, _frame, _x, _y, _xscale, _yscale, 0, c_white, 1);
                        }
                    }
                };
                
                draw_spinnies(0, _panda_y, 0);
                draw_sprite(ibtSa2_spr_panda, current_beat * 4, 0, _panda_y);
                draw_spinnies(0, _panda_y, 1);
                matrix_set(2, matrix_build_identity());
                break;
            case 8:
                var _cb = current_beat - start_beat;
                var _lights_on_beat = 4;
                var _lights_fade_end_beat = _lights_on_beat + 3;
                var _pan_start_beat = 7.5;
                var _pan_end_beat = 17;
                var _pull_beat = 20;
                var _curtains_apart_start_beat = _pull_beat;
                var _curtains_apart_end_beat = _curtains_apart_start_beat + 4;
                var _starlight_anim_start = _pull_beat - 2.5;
                var _starlight_anim_end = _pull_beat + 2.5;
                var _rope_move_start = _pull_beat + 2;
                var _rope_move_end = act3_intro_length - 1;
                standard_mg_intro = false;
                if (_cb <= (minigame_outro_length + 1))
                {
                    standard_mg_intro = true;
                }
                if (_cb >= _pull_beat)
                {
                    draw_minigame_surface(240, 135, 1, 1, 0);
                }
                if (_cb < _lights_on_beat)
                {
                }
                else
                {
                    var cam_y = -563;
                    cam_y = round(lerp(-563, 0, clamp((_cb - _pan_start_beat) / (_pan_end_beat - _pan_start_beat), 0, 1)));
                    matrix_set(2, matrix_build(240, 270 - cam_y, 0, 0, 0, 0, 1, 1, 1));
                    var curtains_apart = max((_cb - _curtains_apart_start_beat) / (_curtains_apart_end_beat - _curtains_apart_start_beat), 0);
                    curtains_apart = lerp_easeInOut(curtains_apart);
                    var curtains_x = lerp(0, 250, curtains_apart);
                    draw_sprite(ibtSa3_spr_curt3L, 0, -curtains_x, 0);
                    draw_sprite(ibtSa3_spr_curt3R, 0, curtains_x, 0);
                    blendmode_set_multiply();
                    draw_sprite(ibtSa3_spr_curt3shadow, 0, 0, 0);
                    blendmode_reset();
                    draw_sprite(ibtSa3_spr_curt2, 0, 0, 0);
                    blendmode_set_multiply();
                    draw_sprite(ibtSa3_spr_curt2shadow, 0, 0, 0);
                    blendmode_reset();
                    draw_sprite(ibtSa3_spr_curt1, 0, 0, 0);
                    blendmode_set_add();
                    draw_sprite(ibtSa3_spr_act3figmentsL, _cb * 2, -curtains_x * 0.8, 0);
                    draw_sprite(ibtSa3_spr_act3figmentsR, _cb * 2, curtains_x * 0.8, 0);
                    draw_sprite(ibtSa3_spr_boss, _cb * 2, 0, 0);
                    blendmode_reset();
                    var _starlight_lerp = clamp((_cb - _starlight_anim_start) / (_starlight_anim_end - _starlight_anim_start), 0, 1);
                    var _starlight_frame = (sprite_get_number(ibtSa3_spr_starlightnohands) - 1) * _starlight_lerp;
                    var _rope_y = lerp(60, -270, lerp_easeIn(clamp((_cb - _rope_move_start) / (_rope_move_end - _rope_move_start), 0, 1)));
                    draw_sprite(ibtSa3_spr_starlightnohands, _starlight_frame, 0, 0);
                    draw_sprite(ibtSa3_spr_rope, _starlight_frame, 0, _rope_y);
                    draw_sprite(ibtSa3_spr_starlighthands, _starlight_frame, 0, 0);
                    matrix_set(2, matrix_build_identity());
                    var _flash_alpha = lerp(1, 0, clamp((_cb - _lights_on_beat) / (_lights_fade_end_beat - _lights_on_beat), 0, 1));
                    draw_set_alpha(_flash_alpha);
                    draw_rectangle(-1, -1, 481, 271, false);
                    draw_set_alpha(1);
                }
                break;
        }
        var ndis = 30;
        var fdis = 95;
        var round_num_dist = fdis;
        if (obj_minigame_controller.inbetween_type == 2 && 0)
        {
        }
        else
        {
            var ibtdown = 1.5;
            inbetween_timer += ibtdown;
            if (inbetween_timer < 7 && obj_minigame_controller.inbetween_type != 3)
            {
                var prog = 0;
                var rprog = 0;
                if (inbetween_timer > 6)
                {
                    prog = 1 - (inbetween_timer - 6);
                    rprog = lerp_easeOut(prog);
                    round_num_dist = fdis + ((-fdis + ndis) * rprog);
                }
                else
                {
                    round_num_dist = ndis;
                }
            }
            inbetween_timer -= ibtdown;
        }
        var speed_or_levelup_cutin = 0;
        var cutin_start_beat = 3.5;
        var cutin_end_beat = 8.3;
        var cutin_multi_sprite = -1;
        var monitor_sprite = -1;
        switch (obj_minigame_controller.inbetween_type)
        {
            case 1:
                speed_or_levelup_cutin = 1;
                cutin_multi_sprite = ibtS_spr_multiplyblue;
                monitor_sprite = ibtS_spr_speed_text;
                break;
            case 5:
                speed_or_levelup_cutin = 2;
                cutin_multi_sprite = ibtS_spr_multiplyred;
                monitor_sprite = ibtS_spr_levelup_text;
                break;
        }
        if (speed_or_levelup_cutin > 0 && (current_beat - start_beat) < cutin_end_beat)
        {
            var cutin_prog = clamp((current_beat - start_beat - cutin_start_beat) / (cutin_end_beat - cutin_start_beat), 0, 1);
            var all_in = lerp_easeOut(clamp(cutin_prog / 0.1, 0, 1));
            if (cutin_prog > 0.9)
            {
                all_in = 1 - lerp_easeIn(clamp((cutin_prog - 0.9) / 0.1, 0, 1));
            }
            var multi_up = all_in;
            gpu_set_blendmode_multiply();
            draw_sprite(cutin_multi_sprite, 0, 0, 0 + (270 * (1 - multi_up)));
            gpu_set_blendmode(bm_normal);
            var monitor_down = all_in;
            var monitor_x = 240;
            var monitor_y = -270 + (270 * monitor_down);
            var monitor_scale = 1;
            draw_sprite_ext(ibtS_spr_monitor, speed_or_levelup_cutin - 1, monitor_x, monitor_y, monitor_scale, monitor_scale, 0, c_white, 1);
            var mtext_scale = 1;
            var mtextprog = current_beat % 1;
            if (speed_or_levelup_cutin == 2)
            {
                mtextprog = (current_beat / 2) % 1;
            }
            if ((current_beat - start_beat) < (cutin_end_beat - 0.5))
            {
                if (mtextprog < 0.9)
                {
                    var prog = clamp(mtextprog / 0.5, 0, 1);
                    prog = lerp_easeOut(prog);
                    mtext_scale = 0.8 + (prog * 0.2);
                }
                else if (mtextprog >= 0.85)
                {
                    var prog = clamp((mtextprog - 0.85) / 0.15, 0, 1);
                    prog = lerp_easeIn(prog);
                    mtext_scale = 1 - (prog * 0.2);
                }
            }
            draw_sprite_ext(monitor_sprite, current_beat * 4, monitor_x, monitor_y + 110, mtext_scale, mtext_scale, 0, c_white, 1);
            var speakers_frame = (sprite_get_number(ibtS_spr_bunspeaker) - 1) * (current_beat % 1);
            var speakers_up = all_in;
            var speakers_y = 288 + (270 * (1 - speakers_up));
            draw_sprite(ibtS_spr_catspeaker, speakers_frame, 80, speakers_y);
            draw_sprite(ibtS_spr_bunspeaker, speakers_frame, 400, speakers_y);
            var girl_up = all_in;
            var girlframe = (current_beat - start_beat) * 2;
            draw_sprite(ibtS_spr_dance, girlframe, 240, 270 * (2 - girl_up));
        }
        _draw_100_stars();
        var cprompt_time = 3 - inbetween_timer;
        if (_scene == 0)
        {
            cprompt_time = 1.75 - inbetween_timer;
        }
        if (!hide_controlprompt && cprompt_time > 0 && obj_minigame_controller.inbetween_type != 3)
        {
            _draw_control_prompt(next_control_style, cprompt_time);
        }
        if (standard_mg_intro)
        {
            var _mask_spr = -1;
            var _outline_spr = -1;
            var _time = 0;
            var _mg_scale = 1;
            if (inbetween_timer < minigame_intro_length && _scene != 8)
            {
                if (obj_minigame_controller.inbetween_type != 3)
                {
                    _mask_spr = ibtS_spr_mgintro_mask;
                    _outline_spr = ibtS_spr_mgintro_outline;
                    _time = (minigame_intro_length - inbetween_timer) / minigame_intro_length;
                }
            }
            else if ((obj_minigame_controller.inbetween_length - inbetween_timer) <= minigame_outro_length)
            {
                if (success_state != 0)
                {
                    _mask_spr = ibtS_spr_mgintro_mask;
                    _outline_spr = ibtS_spr_mgintro_outline;
                    _time = 1 - (obj_minigame_controller.inbetween_length - (inbetween_timer / minigame_outro_length));
                    _mg_scale = 1;
                }
            }
            var _mask_sizes = [[0, 0], [1, 1], [7, 6], [16, 11], [25, 18], [38, 26], [48, 42], [68, 61], [100, 92], [138, 129], [255, 215], [480, 270], [480, 270], [480, 270], [480, 270], [480, 270], [480, 270]];
            var _frame = clamp(_time, 0, 1) * sprite_get_number(_mask_spr);
            var _frame_mask_size = _mask_sizes[_frame];
            _mg_scale = max(_frame_mask_size[0] / 480, _frame_mask_size[1] / 270);
            if (_time > 0)
            {
                draw_sprite(_outline_spr, sprite_get_number(_outline_spr) * _time, 240, 135);
                var _transition_sf = surface_create(480, 270);
                var _prev_targ = surface_get_target();
                surface_reset_target();
                surface_set_target(_transition_sf);
                draw_clear_alpha(c_white, 0);
                gpu_set_blendenable(false);
                gpu_set_colorwriteenable(false, false, false, true);
                draw_set_alpha(0);
                draw_rectangle(-1, -1, 481, 271, false);
                draw_set_alpha(1);
                draw_sprite(_mask_spr, sprite_get_number(_mask_spr) * _time, 240, 135);
                gpu_set_colorwriteenable(true, true, true, false);
                draw_minigame_surface(240, 135, _mg_scale, _mg_scale, 0);
                gpu_set_colorwriteenable(true, true, true, true);
                surface_reset_target();
                surface_set_target(_prev_targ);
                draw_surface(_transition_sf, 0, 0);
                surface_free(_transition_sf);
            }
        }
    };
    
    _draw_control_prompt = function(arg0, arg1 = -1)
    {
        if (is_array(arg0))
        {
            arg0 = build_control_style(arg0);
        }
        if (!is_struct(arg0))
        {
            exit;
        }
        var styles = [];
        var use_arrows = false;
        var use_spacebar = false;
        var use_cursor = false;
        var use_keyboard = false;
        var use_special = is_string(arg0.special);
        if (use_special)
        {
            array_push(styles, arg0.special);
        }
        else
        {
            use_arrows = arg0.arrows.any;
            use_spacebar = arg0.spacebar;
            use_cursor = arg0.cursor.any;
            use_keyboard = arg0.keyboard;
            if (use_arrows)
            {
                array_push(styles, "arrows");
            }
            if (use_spacebar)
            {
                array_push(styles, "spacebar");
            }
            if (use_cursor)
            {
                array_push(styles, "cursor");
            }
            if (use_keyboard)
            {
                array_push(styles, "keyboard");
            }
        }
        var stylescount = array_length(styles);
        var dx = 240;
        var dy = 135;
        var _spr = -1;
        switch (stylescount)
        {
            case 1:
                var _style = styles[0];
                switch (_style)
                {
                    case "arrows":
                        _spr = ibtS_spr_controlprompt_arrows;
                        break;
                    case "spacebar":
                        _spr = ibtS_spr_controlprompt_space;
                        break;
                    case "cursor":
                        _spr = ibtS_spr_controlprompt_mouse;
                        break;
                    case "keyboard":
                        _spr = ibtS_spr_controlprompt_keyboard;
                        break;
                }
                break;
            case 2:
                if (array_contains(styles, "arrows") && array_contains(styles, "spacebar"))
                {
                    _spr = ibtS_spr_controlprompt_arrows_space;
                }
                if (array_contains(styles, "arrows") && array_contains(styles, "cursor"))
                {
                    _spr = ibtS_spr_controlprompt_arrows_space_mouse;
                }
                if (array_contains(styles, "space") && array_contains(styles, "cursor"))
                {
                    _spr = ibtS_spr_controlprompt_arrows_space_mouse;
                }
                if (array_contains(styles, "keyboard") && array_contains(styles, "cursor"))
                {
                    _spr = ibtS_spr_controlprompt_keyboard_mouse;
                }
                break;
            case 3:
                if (array_contains(styles, "arrows") && array_contains(styles, "cursor") && array_contains(styles, "space"))
                {
                    _spr = ibtS_spr_controlprompt_arrows_space_mouse;
                }
                break;
        }
        if (_spr == -1)
        {
            exit;
        }
        var _r = 0;
        var _s = 0;
        arg1 = clamp(arg1 / 0.25, 0, 1);
        var _prog = 0;
        if (arg1 < 0.2)
        {
            _prog = clamp(arg1 / 0.2, 0, 1);
            _r = lerp(-10, 10, _prog);
            _s = lerp(1.3, 0.8, _prog);
        }
        else
        {
            _prog = lerp_easeOut(clamp((arg1 - 0.2) / 0.8, 0, 1));
            _r = lerp(10, 0, _prog);
            _s = lerp(0.8, 1, _prog);
        }
        draw_sprite_ext(_spr, 0, dx, dy, _s, _s, _r, c_white, 1);
    };
}

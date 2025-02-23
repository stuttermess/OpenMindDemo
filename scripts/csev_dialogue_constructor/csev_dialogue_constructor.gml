function csev_dialogue_constructor() : csev_base_constructor() constructor
{
    _event_type = 1;
    _cutscene_controller = -1;
    background_sequence = -1;
    background_sequence_layer = -1;
    background_sprite = -1;
    background_transition_shader = -1;
    background_sprite_does_pan = true;
    loaded_line_array = [];
    loaded_line_num = -1;
    options = [];
    options_text = [];
    options_setup = [];
    show_options = false;
    option_hover = undefined;
    
    pause_menu.on_resume_click = function()
    {
    };
    
    paused = false;
    speaker = "";
    speaker_sprite = -1;
    characters = [];
    char_id_to_index = {};
    draw_order = [];
    allow_player_input = true;
    wait_countdown = 0;
    intro_anim = 0;
    intro_anim_time = 60;
    intro_ease = lerp_easeOutQuart;
    outro = false;
    outro_anim_time = 30;
    skip_intro = false;
    skip_outro = false;
    insert_sequence_event_countdown = 0;
    insert_sequence_event = -1;
    returning_from_inserted_sequence = false;
    outro_func = -1;
    letterbox_start_in = false;
    continue_cooldown = 0;
    continue_cooldown_max = 10;
    ffwd_base_speed = 3;
    ffwd_speed = 0;
    show_cursor = !instance_exists(obj_lobby_controller);
    cam_side = -1;
    cam_side_display = -1;
    cam_side_move_anim = 1;
    cam_side_move_anim_time = 15;
    letterboxing_angle = -1;
    end_countdown = -1;
    nextseq_on_end = false;
    cancel_input = false;
    played_nextseq = false;
    char_defs = {};
    mwsc = new mwsc_instance();
    mwsc.type = 1;
    mwsc.parent = self;
    mwsc.textbox.width = 190;
    next_event = mwsc.next_event;
    mwsc.text_finish_sound = snd_dialogue_textfinish;
    log_open = false;
    log_list = [];
    log_obj = new dialogue_log_constructor();
    log_obj.list = mwsc.log_list;
    
    log_obj._on_close = function()
    {
        log_open = false;
    };
    
    mwsc.after_script_load = function()
    {
        var _max_last_spoke = 0;
        for (var i = 0; i < array_length(characters); i++)
        {
            var _char = characters[i];
            _max_last_spoke = max(_max_last_spoke, _char.last_spoke);
        }
        for (var i = 0; i < array_length(characters); i++)
        {
            var _char = characters[i];
            _char.last_spoke -= _max_last_spoke;
        }
    };
    
    mwsc.add_custom_parse_func("char", function(arg0)
    {
        arg0 = arg0.args;
        var charname = "";
        var charid = "";
        var charside = 0;
        var charxoff = 0;
        if (array_length(arg0) > 1)
        {
            charname = arg0[1];
        }
        if (array_length(arg0) > 2)
        {
            charid = arg0[2];
        }
        if (array_length(arg0) > 3)
        {
            charside = arg0[3];
        }
        if (array_length(arg0) > 4)
        {
            charxoff = arg0[4];
        }
        if (string_char_at(charxoff, 1) == "-")
        {
            charxoff = string_delete(charxoff, 1, 1);
            charxoff = -real(charxoff);
        }
        else
        {
            charxoff = real(charxoff);
        }
        array_push(mwsc.events, ["define_character", charname, charid, charside, charxoff]);
        struct_set(char_defs, charid, 1);
    });
    mwsc.add_custom_script_event_func("define_character", function(arg0)
    {
        var _ev = arg0.args;
        if (!struct_exists(char_id_to_index, _ev[2]))
        {
            var _char = _script_define_character(_ev[1], _ev[2], _ev[3]);
            _char.x = _ev[4];
            _char.x_prev = _char.x;
            _char.x_new = _char.x;
        }
    });
    mwsc.add_custom_parse_func("default", function(arg0)
    {
        var _script_line = arg0.script_line;
        arg0 = arg0.args;
        if (array_length(arg0) == 1 && struct_exists(char_defs, arg0[0]))
        {
            array_push(mwsc.events, ["set_speaker", arg0[0]]);
        }
        else
        {
            mwsc._add_text_line(mwsc.script[_script_line]);
        }
    });
    mwsc.add_custom_script_event_func("set_speaker", function(arg0)
    {
        var _ev = arg0.args;
        var _speaker_id = _ev[1];
        speaker = _speaker_id;
        mwsc.set_text("");
        var speaker_index = struct_get(char_id_to_index, _speaker_id);
        if (speaker_index != -1)
        {
            var speaker_struct = characters[speaker_index];
            mwsc.text_voice = speaker_struct.voice;
            if (speaker_struct.front_when_speak)
            {
                speaker_struct.last_spoke = mwsc.current_event;
            }
            var _speaker_side = speaker_struct.side;
            if (_speaker_side != cam_side)
            {
                if (intro_anim < 1)
                {
                    cam_side = _speaker_side;
                    cam_side_display = cam_side;
                }
                else
                {
                    cam_side_display = cam_side;
                    cam_side = _speaker_side;
                    cam_side_move_anim = 0;
                }
            }
        }
        update_char_draw_order();
    });
    mwsc.add_custom_parse_func("face", function(arg0)
    {
        var _script_line = arg0.script_line;
        arg0 = arg0.args;
        if (array_length(arg0) == 4)
        {
            array_push(mwsc.events, ["face", arg0[1], real(arg0[2]), real(arg0[3])]);
        }
        else
        {
            show_message("Error in script at event number " + string(_script_line) + ".\n" + mwsc.script[_script_line] + "\nWrong number of arguments for \"face\" (expected 3)");
        }
    });
    mwsc.add_custom_script_event_func("face", function(arg0)
    {
        var _ev = arg0.args;
        var charid = _ev[1];
        var char_index = struct_get(char_id_to_index, charid);
        if (char_index != -1)
        {
            var _char = characters[char_index];
            var newpose = _ev[2];
            var newface = _ev[3];
            if (newpose != _char.pose || newface != _char.face)
            {
                _char.nudge = 8;
            }
            _char.pose = newpose;
            _char.face = newface;
            _char.set_sprites();
        }
    });
    mwsc.add_custom_parse_func("set", function(arg0)
    {
        arg0 = arg0.args;
        array_push(mwsc.events, ["set_character_value", arg0[1], arg0[2], arg0[3]]);
    });
    mwsc.add_custom_script_event_func("set_character_value", function(arg0)
    {
        var _ev = arg0.args;
        var charid = _ev[1];
        var val_name = _ev[2];
        var val = _ev[3];
        var char_index = struct_get(char_id_to_index, charid);
        if (char_index != -1)
        {
            var _char = characters[char_index];
            var prev_val = struct_get(_char, val_name);
            var val_type = typeof(prev_val);
            switch (val_type)
            {
                case "number":
                    val = real(val);
                    break;
            }
            struct_set(_char, val_name, val);
            switch (val_name)
            {
                case "layer":
                    update_char_draw_order();
                    break;
                case "pose":
                case "face":
                    _char.nudge = 8;
                    _char.set_sprites();
                    break;
                case "voice":
                    var _func = asset_get_index(val);
                    _char.voice = new _func();
                    break;
                case "x":
                    _char.x_prev = prev_val;
                    _char.x_new = _char.x;
                    _char.x_change_anim = 0;
                    _char.nudge = 0;
                    if ((cam_side != _char.side && cam_side_move_anim == 1) || (cam_side == _char.side && cam_side_move_anim < 1) || intro_anim < 1)
                    {
                        _char.x_change_anim = 1;
                    }
                    break;
            }
        }
    });
    mwsc.add_custom_parse_func("skip", function(arg0)
    {
        var _script_line = arg0.script_line;
        arg0 = arg0.args;
        if (array_length(arg0) > 1)
        {
            array_push(mwsc.events, ["skip"]);
            array_copy(mwsc.events[_script_line], 1, arg0, 1, array_length(arg0) - 1);
        }
        else
        {
            array_push(mwsc.events, ["skip_event"]);
        }
    });
    mwsc.add_custom_script_event_func("skip", function(arg0)
    {
        var _ev = arg0.args;
        if (array_contains(_ev, "intro"))
        {
            skip_intro = true;
        }
        if (array_contains(_ev, "outro"))
        {
            skip_outro = true;
        }
    });
    mwsc.add_custom_parse_func("wait", function(arg0)
    {
        arg0 = arg0.args;
        var _frames = 0;
        _frames = real(arg0[1]);
        if (array_length(arg0) > 2)
        {
            switch (arg0[2])
            {
                case "s":
                case "sec":
                case "second":
                case "seconds":
                    _frames *= room_speed;
                    break;
                case "f":
                case "fr":
                case "frame":
                case "frames":
                    break;
            }
        }
        array_push(mwsc.events, ["wait", _frames]);
    });
    mwsc.add_custom_script_event_func("wait", function(arg0)
    {
        var _ev = arg0.args;
        var _frames = _ev[1];
        wait_countdown = _frames;
        mwsc.script_event.do_next_event = false;
        returning_from_inserted_sequence = false;
    });
    mwsc.add_custom_parse_func("sequence", function(arg0)
    {
        arg0 = arg0.args;
        array_delete(arg0, 0, 1);
        var _seq_id = -1;
        var _seq_script_path = "";
        for (var j = 0; j < (array_length(arg0) - 1); j += 2)
        {
            var _argname = arg0[j];
            var _argvalue = arg0[j + 1];
            switch (_argname)
            {
                case "id":
                    var _seq_string = _argvalue;
                    _argvalue = asset_get_index(_seq_string);
                    if (sequence_exists(_argvalue))
                    {
                        _seq_id = _argvalue;
                    }
                    else
                    {
                        show_message("Sequence with ID \"" + _seq_string + "\" does not exist.");
                    }
                    break;
                case "script":
                    _seq_script_path = _argvalue;
                    break;
            }
        }
        if (_seq_id == -1)
        {
            array_push(mwsc.events, ["skip_event"]);
        }
        else
        {
            array_push(mwsc.events, ["sequence", _seq_id, _seq_script_path]);
        }
    });
    mwsc.add_custom_script_event_func("sequence", function(arg0)
    {
        var _ev = arg0.args;
        var _seq_id = _ev[1];
        var _seq_script_path = _ev[2];
        var _me = self;
        var _new_seq_event = new csev_sequence_constructor();
        _new_seq_event._cutscene_controller = _cutscene_controller;
        with (_new_seq_event)
        {
            sequence_id = _seq_id;
            if (_seq_script_path != "")
            {
                _seq_script_path = "scripts/" + _seq_script_path + ".mwsc";
                _script = load_dialogue_script(_seq_script_path);
                _script_to_events();
            }
            inserted_in_dialogue = _me;
            sequence_layer_depth = _cutscene_controller.controller_object.depth + 0.5;
            skippable = false;
        }
        returning_from_inserted_sequence = false;
        _new_seq_event._init();
        insert_sequence_event = _new_seq_event;
        insert_sequence_event_countdown = 2;
        returning_from_inserted_sequence = true;
        mwsc.script_event.do_next_event = false;
    });
    mwsc.add_custom_parse_func("end_transition", function(arg0)
    {
        arg0 = arg0.args;
        var _transition = -1;
        if (array_length(arg0) >= 2)
        {
            switch (arg0[1])
            {
                case "none":
                    _transition = "none";
                    break;
                case "perlin":
                    _transition = "perlin";
                    break;
                case "ditherfade":
                case "dither":
                    _transition = "ditherfade";
                    break;
            }
        }
        if (_transition == -1)
        {
            array_push(mwsc.events, ["skip_event"]);
        }
        else
        {
            array_push(mwsc.events, ["end_transition", _transition]);
        }
    });
    mwsc.add_custom_script_event_func("end_transition", function(arg0)
    {
        var _ev = arg0.args;
        var _transition = _ev[1];
        
        var _func = function()
        {
        };
        
        switch (_transition)
        {
            case "perlin":
                _func = function()
                {
                    var _tr = start_transition(-1, transition_perlin);
                    _tr.outro.reverse = true;
                    _tr.outro._time = 1;
                };
                
                break;
        }
        outro_func = _func;
    });
    
    _script_to_events = function()
    {
        mwsc.script = _script;
        mwsc.script_to_events();
    };
    
    _init = function()
    {
        if (_cutscene_controller.keep_sequence != -1)
        {
            background_sequence = _cutscene_controller.keep_sequence;
            background_sequence_layer = _cutscene_controller.keep_sequence_layer;
        }
        _script_to_events();
        mwsc.perform_current_event();
    };
    
    _end = function()
    {
        log_obj._destroy();
    };
    
    _tick = function()
    {
        if (allow_player_input && !instance_exists(obj_lobby_controller))
        {
            if (keyboard_check_pressed(vk_tab) && !log_open && !pause_menu.active)
            {
                log_open = true;
                log_obj.open();
            }
        }
        if (pause_menu.active)
        {
            pause_menu.tick();
        }
        else
        {
            if (log_open)
            {
                log_obj._tick();
            }
            var logopen = log_open;
            if (instance_exists(obj_lobby_controller))
            {
                logopen = obj_lobby_controller.logmenu;
            }
            if (!logopen && keyboard_check_pressed(vk_escape))
            {
                pause_menu.open();
            }
        }
        if (instance_exists(obj_lobby_controller))
        {
            obj_lobby_controller.dialoguepause = pause_menu.active;
            
            pause_menu.on_quit_click = function()
            {
                obj_lobby_controller.quit_to_menu();
            };
        }
        if (paused || log_open || pause_menu.active)
        {
            exit;
        }
        letterboxing_angle = cam_side;
        var continue_btn = (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_space)) && allow_player_input;
        var ffwd_btn = keyboard_check(vk_shift) && allow_player_input;
        var _cancel_input = cancel_input;
        if (insert_sequence_event_countdown > 0)
        {
            _cancel_input = true;
        }
        if (_cancel_input)
        {
            continue_btn = false;
            ffwd_btn = false;
        }
        var text_active = intro_anim >= 0.9;
        if (cam_side_move_anim < 1)
        {
            var anim_done = bool(cam_side_move_anim >= 1);
            cam_side_move_anim += ((1 + (ffwd_speed * 0.75)) / cam_side_move_anim_time);
            if (continue_btn)
            {
                cam_side_move_anim = 1;
            }
            cam_side_move_anim = clamp(cam_side_move_anim, 0, 1);
            cam_side_display = lerp(-cam_side, cam_side, lerp_easeInOut(cam_side_move_anim));
            if (!anim_done && cam_side_move_anim >= 1 && !show_options)
            {
            }
        }
        var tick_mwsc = true;
        tick_mwsc = tick_mwsc && cam_side_move_anim == 1 && intro_anim > 0.9 && insert_sequence_event_countdown <= 0;
        if (wait_countdown > 0)
        {
            tick_mwsc = false;
            wait_countdown--;
            if (wait_countdown <= 0)
            {
                tick_mwsc = true;
                continue_btn = false;
                mwsc.next_event();
            }
        }
        if (tick_mwsc)
        {
            mwsc.tick();
        }
        show_options = mwsc.show_options;
        if (show_options)
        {
            if (option_hover != undefined)
            {
                if ((get_input_click(1) && allow_player_input) && option_hover >= 0 && option_hover < array_length(mwsc.options))
                {
                    mwsc.select_option(option_hover);
                    show_options = mwsc.show_options;
                    sfx_play(snd_menu_click_minor);
                }
            }
        }
        if (sign(cam_side) == sign(cam_side_display))
        {
            speaker_sprite = -1;
            if (!show_options)
            {
                var speaker_id = speaker;
                var speaker_index = struct_get(char_id_to_index, speaker_id);
                if (!is_undefined(speaker_index))
                {
                    var speaker_char = characters[speaker_index];
                    speaker_sprite = dialogue_get_character_name_sprite(speaker_char.name);
                }
            }
        }
        for (var i = 0; i < array_length(characters); i++)
        {
            var _char = characters[i];
            with (_char)
            {
                _char.nudge += sign(0 - _char.nudge) * 0.5;
                x = lerp(x_prev, x_new, lerp_easeInOut(clamp(x_change_anim, 0, 1)));
                if (x_change_anim < 1)
                {
                    x_change_anim += (1 / x_change_time);
                }
            }
        }
        if (outro)
        {
            intro_ease = lerp_easeOutQuint;
            if (intro_anim > 0)
            {
                if (skip_outro)
                {
                    intro_anim = 0;
                }
                intro_anim -= (1 / outro_anim_time);
                intro_anim = clamp(intro_anim, 0, 1);
                if (_cutscene_controller != -1 && end_countdown == -1)
                {
                    if (intro_anim == 0)
                    {
                        end_countdown = 0;
                        if (!played_nextseq)
                        {
                            _cutscene_controller.prequeue_next_sequence();
                        }
                        intro_anim += (1 / outro_anim_time);
                        if (skip_outro)
                        {
                            intro_anim = 1;
                        }
                    }
                }
            }
        }
        else if (intro_anim < 1)
        {
            if (skip_intro)
            {
                intro_anim = 1;
            }
            intro_anim += (1 / intro_anim_time);
            intro_anim = clamp(intro_anim, 0, 1);
            if (intro_anim >= 1)
            {
                if (background_sequence != -1 && background_sprite != -1)
                {
                    layer_sequence_destroy(background_sequence);
                    background_sequence = -1;
                    background_sequence_layer = -1;
                }
            }
        }
        if (insert_sequence_event_countdown > 0)
        {
            insert_sequence_event_countdown--;
            if (insert_sequence_event_countdown == 0)
            {
                _cutscene_controller.current_event = insert_sequence_event;
                _cutscene_controller.events[_cutscene_controller.current_event_id] = insert_sequence_event;
                insert_sequence_event = -1;
            }
        }
        if (end_countdown == 0)
        {
            if (played_nextseq || (!played_nextseq && intro_anim == 0))
            {
                _cutscene_controller.next_event();
            }
            with (_cutscene_controller)
            {
                if (keep_sequence != -1)
                {
                    layer_sequence_destroy(keep_sequence);
                    keep_sequence = -1;
                    keep_sequence_layer = -1;
                }
            }
        }
        if (end_countdown > 0)
        {
            end_countdown--;
        }
    };
    
    _draw_background = function()
    {
        if (sprite_exists(background_sprite))
        {
            var offx = sprite_get_xoffset(background_sprite);
            var offy = sprite_get_yoffset(background_sprite);
            var bgx = offx;
            var bgy = offy;
            if (background_sprite_does_pan)
            {
                var __lerp = (cam_side_display + 1) / 2;
                var bg_left_x = 0;
                var bg_right_x = -1 * (sprite_get_width(background_sprite) - 480);
                bgx += lerp(bg_left_x, bg_right_x, __lerp);
            }
            draw_sprite_ditherfaded(background_sprite, 0, bgx, bgy, 1 - intro_ease(intro_anim));
        }
        else
        {
            var bg_scale = 1 + (0.1 * intro_ease(intro_anim));
            var bg_x = 0 - (480 * (bg_scale - 1) * (0.5 + (cam_side_display * 0.3)));
            var bg_y = 0 - ((270 * (bg_scale - 1)) / 2);
            var _sf = surface_create(480, 270);
            surface_copy(_sf, 0, 0, surface_get_target());
            draw_surface_ext(_sf, bg_x, bg_y, bg_scale, bg_scale, 0, c_white, 1);
            blendmode_set_multiply();
            draw_sprite_ext(spr_dialogue_bgmult, 0, 0, 0, 1, 1, 0, c_white, intro_ease(intro_anim));
            blendmode_reset();
            surface_free(_sf);
        }
    };
    
    _draw = function()
    {
        var _save_intro = intro_anim;
        if (skip_outro && outro)
        {
            intro_anim = 0;
            intro_ease = lerp_easeOutQuint;
        }
        var _flip = (cam_side_display + 1) / 2;
        var char_offscreen = 300;
        _draw_background();
        letterboxing_angle = _flip;
        var _lba = letterboxing_angle;
        draw_set_color(c_black);
        var _out = 1 - intro_ease(intro_anim);
        _out *= 40;
        if (letterbox_start_in && !outro)
        {
            _out *= 0.5;
        }
        draw_line_width(-14, lerp(12, -8, _lba) - _out, 494, lerp(12, -8, 1 - _lba) - _out, 40);
        draw_line_width(-14, lerp(255, 280, _lba) + _out, 494, lerp(255, 280, 1 - _lba) + _out, 40);
        draw_set_color(c_white);
        var tb_x = lerp(317, 163, _flip);
        if (intro_anim < 1)
        {
            tb_x -= (320 * cam_side_display * (1 - intro_ease(intro_anim)));
        }
        tb_x = round(tb_x);
        var tb_y = 135;
        var tb_xscale = sign(-cam_side_display);
        draw_sprite_ext(spr_dialoguebox, 0, tb_x, tb_y, tb_xscale, 1, 0, c_white, 1);
        var _tx = tb_x + (5 * tb_xscale);
        var _ty = 143;
        if (show_options && (cam_side_display == cam_side || cam_side_move_anim >= 0.5))
        {
            var _ops = mwsc.options_text;
            var _fnt = draw_get_font();
            draw_set_font(fnt_dialogue);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            option_hover = undefined;
            var _log_open = log_open;
            if (instance_exists(obj_lobby_controller))
            {
                _log_open = obj_lobby_controller.logmenu;
            }
            var _sep = lerp(25, 13, (array_length(_ops) - 1) / 4);
            for (var i = 0; i < array_length(_ops); i++)
            {
                var _txx = round(_tx);
                var _tyy = round(_ty + (_sep * (i - ((array_length(_ops) - 1) / 2))));
                var _str = _ops[i];
                var __col = mwsc.options[i][3];
                if (__col == -1)
                {
                    __col = draw_get_color();
                }
                var coords = [_txx - (string_width(_str) / 2) - 9 - 5, (_tyy - (string_height(_str) / 2) - 1) + 1, _txx + (string_width(_str) / 2) + 5, (_tyy + (string_height(_str) / 2)) - 3];
                if (!pause_menu.active && !_log_open && point_in_rectangle(mouse_x, mouse_y, coords[0], coords[1], coords[2], coords[3]))
                {
                    option_hover = i;
                }
                draw_set_color(__col);
                if (option_hover == i)
                {
                    draw_set_color(c_fuchsia);
                    draw_sprite_ext(spr_dialogue_option_cursor, 0, coords[0] + 10, _tyy - 1, 1, 1, 0, draw_get_color(), 1);
                }
                draw_text(_txx, _tyy, _str);
                var _wid = string_width(_str) + 4;
                var _hei = string_height(_str) - 2;
                draw_line(_txx - (_wid / 2), (_tyy + (_hei / 2)) - 0, _txx + (_wid / 2), (_tyy + (_hei / 2)) - 0);
                draw_set_color(c_white);
            }
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            draw_set_font(_fnt);
        }
        else
        {
            var _text = mwsc.text;
            var _current_letter = mwsc.current_letter;
            mwsc.draw(_tx, _ty);
            option_hover = undefined;
            if (sprite_exists(speaker_sprite))
            {
                draw_sprite_ext(speaker_sprite, real(tb_xscale == -1), tb_x, tb_y, tb_xscale, 1, 0, c_white, 1);
            }
            var _text_done = _current_letter >= string_length(_text);
            _text_done = _text_done && !mwsc.skip_line && mwsc.allow_player_input && wait_countdown <= 0;
            if (_text_done)
            {
                draw_sprite_ext(spr_dialoguebox, 1, tb_x, tb_y, tb_xscale, 1, 0, c_white, 1);
            }
            option_hover = undefined;
        }
        for (var i = 0; i < array_length(draw_order); i++)
        {
            var _char = draw_order[i];
            var orix = _char.x;
            var oriy = _char.y;
            _char.x += 107;
            if (_char.side == 1)
            {
                _char.x = (480 - _char.x) + ((1 - _flip) * char_offscreen);
            }
            else
            {
                _char.x -= _flip * char_offscreen;
            }
            if (intro_anim < 1)
            {
                _char.x += 380 * _char.side * (1 - intro_ease((intro_anim + 0.1) - ((1 - (2 * outro)) * 0.055 * (i / array_length(draw_order)))));
            }
            _char.x -= _char.nudge * _char.dir;
            var speaker_index = struct_get(char_id_to_index, speaker);
            if (!is_undefined(speaker_index))
            {
                var speaker_struct = characters[speaker_index];
                var is_speaking = bool(speaker_struct == _char) || !_char.darken_when_not_speaking || show_options;
                if (speaker_struct.side == _char.side)
                {
                    if (cam_side_move_anim < 1)
                    {
                        _char.speaking_display = real(is_speaking);
                    }
                    else
                    {
                        _char.speaking_display = lerp(_char.speaking_display, real(is_speaking), 0.15);
                    }
                }
            }
            _char._draw(_char);
            _char.x = orix;
            _char.y = oriy;
        }
        var _log_in = intro_ease(intro_anim);
        if (instance_exists(obj_lobby_controller))
        {
            _log_in = 1;
        }
        var _ffw_in = intro_ease(intro_anim);
        draw_sprite(spr_logffwd, 0, 480 + ((1 - _log_in) * 68), 0);
        draw_sprite(spr_logffwd, 1, 480 + ((1 - _ffw_in) * 68), 0);
        if (log_open)
        {
            log_obj._draw();
        }
        if (pause_menu.active)
        {
            pause_menu.draw();
        }
        if (show_cursor)
        {
            var _frame = 0;
            if (option_hover != undefined || (pause_menu.active && pause_menu.cursor_hover != -1) || log_obj.hovering)
            {
                _frame = 1;
                if (mouse_check_button(mb_left))
                {
                    _frame = 2;
                }
            }
            var cursor_alpha = intro_anim;
            if (log_open)
            {
                cursor_alpha = max(cursor_alpha, log_obj.open_display);
            }
            if (pause_menu.active)
            {
                cursor_alpha = 1;
            }
            draw_sprite_ditherfaded(spr_cursor, _frame, mouse_x, mouse_y, 1 - cursor_alpha);
        }
        intro_anim = _save_intro;
    };
    
    on_end = function()
    {
        outro = true;
        intro_anim = 1;
        if (returning_from_inserted_sequence)
        {
            skip_outro = true;
        }
        if (outro_func != -1)
        {
            outro_func();
        }
        if (mwsc.script_event.flags_were_changed)
        {
            if (instance_exists(obj_lobby_controller))
            {
                master.story_flags.room_id = script_get_name(obj_lobby_controller.lobby_id);
                obj_lobby_controller.lobby.saved_since_load = true;
                storymode_save();
            }
        }
        if (nextseq_on_end && !played_nextseq)
        {
            played_nextseq = true;
            _cutscene_controller.prequeue_next_sequence();
        }
    };
    
    mwsc.on_end = on_end;
    
    _script_define_character = function(arg0, arg1, arg2 = "left")
    {
        var dir = 1;
        switch (arg2)
        {
            case "right":
            case 1:
                arg2 = 1;
                dir = -1;
                break;
            case "left":
            case 0:
            case -1:
            default:
                arg2 = -1;
                dir = 1;
                break;
        }
        var _char = new dialogue_character_constructor();
        var name = "";
        var pose = 0;
        var face = 0;
        var _draw = draw_charportrait_basic;
        switch (arg0)
        {
            case "pandora":
                name = "pandora";
                _char.icon = spr_dloghead_pandora;
                _char.voice = new charvoice_pandora();
                _char.pose_face_grid = [[spr_cp_p_p0, spr_cp_p_p0f0, spr_cp_p_p0f1, spr_cp_p_p0f2, spr_cp_p_p0f3, spr_cp_p_p0f4], [spr_cp_p_p1, spr_cp_p_p1f0, spr_cp_p_p1f1, spr_cp_p_p1f2, -1, -1], [spr_cp_p_p2, -1, -1, -1, -1, -1], [spr_cp_p_p3, -1, -1, -1, -1, -1], [spr_cp_p_p4, spr_cp_p_p4f0, -1, -1, -1, -1]];
                break;
            case "smalls":
                name = "smalls";
                _char.icon = spr_dloghead_smalls;
                _char.voice = new charvoice_smalls();
                _char.pose_face_grid = [[spr_cp_s_p0, spr_cp_s_p0f0, spr_cp_s_p0f1, spr_cp_s_p0f2, spr_cp_s_p0f3], [spr_cp_s_p1, spr_cp_s_p1f0, -1, -1, -1], [spr_cp_s_p2, spr_cp_s_p2f0, spr_cp_s_p2f1, -1, -1]];
                break;
            case "abbie":
                name = "abbie";
                _char.icon = spr_dloghead_abbie;
                _char.voice = new charvoice_abbie();
                _char.sprite_dir = -1;
                _char.pose_face_grid = [[spr_cp_ab_p0, spr_cp_ab_p0f0, -1, -1, -1], [spr_cp_ab_p1, spr_cp_ab_p1f0, -1, spr_cp_ab_p1f2, -1], [spr_cp_ab_p2, -1, -1, spr_cp_ab_p2, -1], [spr_cp_ab_p3, -1, spr_cp_ab_p3, -1, -1], [spr_cp_ab_p4, -1, spr_cp_ab_p4, -1, -1], [spr_cp_ab_p5, spr_cp_ab_p5f0, -1, -1, -1], [spr_cp_ab_p6, spr_cp_ab_p6f0, spr_cp_ab_p6f1, spr_cp_ab_p6f2, spr_cp_ab_p6f3]];
                break;
            case "alex":
                name = "alex";
                _char.icon = spr_dloghead_alex;
                _char.voice = new charvoice_default();
                _char.sprite_dir = -1;
                _char.pose_face_grid = [[spr_cp_al_p0, spr_cp_al_p0f0, spr_cp_al_p0f1]];
                break;
            case "dom":
                name = "dom";
                _char.icon = spr_dloghead_dom;
                _char.voice = new charvoice_low();
                _char.sprite_dir = -1;
                _char.pose_face_grid = [[spr_cp_dm_p0, spr_cp_dm_p0f0, spr_cp_dm_p0f1], [spr_cp_dm_p1, spr_cp_dm_p1f0, spr_cp_dm_p1f1]];
                break;
            case "iris":
                name = "iris";
                _char.icon = spr_dloghead_iris;
                _char.voice = new charvoice_default();
                _char.sprite_dir = -1;
                _char.pose_face_grid = [[spr_cp_ir_p0, spr_cp_ir_p0f0, spr_cp_ir_p0f1, spr_cp_ir_p0f2, spr_cp_ir_p0f3], [spr_cp_ir_p1, spr_cp_ir_p1f0, -1, -1, -1], [spr_cp_ir_p2, spr_cp_ir_p2f0, -1, -1, -1]];
                break;
            case "kat":
                name = "kat";
                _char.icon = spr_dloghead_kat;
                _char.voice = new charvoice_high();
                _char.sprite_dir = -1;
                _char.pose_face_grid = [[spr_cp_kt_p0, spr_cp_kt_p0f0, spr_cp_kt_p0f1, spr_cp_kt_p0f2]];
                break;
            case "roxy":
                name = "roxy";
                _char.icon = spr_dloghead_roxy;
                _char.voice = new charvoice_default();
                _char.sprite_dir = -1;
                _char.pose_face_grid = [[spr_cp_rx_p0, spr_cp_rx_p0f0, spr_cp_rx_p0f1], [spr_cp_rx_p1, spr_cp_rx_p1f0, spr_cp_rx_p1f1], [spr_cp_rx_p2, spr_cp_rx_p2f0, spr_cp_rx_p2f1], [spr_cp_rx_p3, spr_cp_rx_p3f0, spr_cp_rx_p3f1]];
                break;
            case "slate":
                name = "slate";
                _char.icon = spr_dloghead_slate;
                _char.voice = new charvoice_low();
                _char.sprite_dir = -1;
                _char.pose_face_grid = [[spr_cp_sl_p0, spr_cp_sl_p0f0], [spr_cp_sl_p1, -1]];
                break;
            case "terminal":
                name = "terminal";
                _char.icon = spr_dloghead_mindscape;
                _char.voice = new charvoice_terminal();
                _char.sprite_dir = -1;
                _char.pose_face_grid = [[spr_cp_terminal, -1]];
                break;
        }
        _char.name = name;
        _char.pose = pose;
        _char.face = face;
        _char.id = arg1;
        _char.dir = dir;
        _char.side = arg2;
        _char._draw = _draw;
        _char.set_sprites();
        struct_set(char_id_to_index, arg1, array_length(characters));
        array_push(characters, _char);
        update_char_draw_order();
        return _char;
    };
    
    update_char_draw_order = function()
    {
        if (array_length(draw_order) != array_length(characters))
        {
            draw_order = [];
            array_copy(draw_order, 0, characters, 0, array_length(characters));
        }
        
        var depthsort = function(arg0, arg1)
        {
            var _layer_diff = arg0.layer - arg1.layer;
            var _sort = 0;
            if (arg0.side == arg1.side || 1)
            {
                if (_layer_diff == 0)
                {
                    var _front_when_speak_diff = arg0.front_when_speak - arg1.front_when_speak;
                    if (_front_when_speak_diff == 0 || 1)
                    {
                        _sort = arg0.last_spoke - arg1.last_spoke;
                    }
                    else
                    {
                        _sort = _front_when_speak_diff;
                    }
                }
                else
                {
                    _sort = _layer_diff;
                }
            }
            else if (arg0.side != cam_side)
            {
                if (struct_exists(arg0.layer_depth_tests, arg1.id))
                {
                    _sort = struct_get(arg0.layer_depth_tests, arg1.id);
                }
            }
            struct_set(arg0.layer_depth_tests, arg1.id, _sort);
            return _sort;
        };
        
        array_sort(draw_order, depthsort);
    };
}

function dialogue_character_constructor() constructor
{
    name = "mystery";
    icon = spr_none;
    pose = 0;
    face = 0;
    pose_sprite = -1;
    face_sprite = -1;
    id = -1;
    x = 0;
    y = 270;
    layer = 0;
    dir = 1;
    nudge = 0;
    side = -1;
    last_spoke = -1;
    front_when_speak = 1;
    speaking_display = 1;
    darken_when_not_speaking = true;
    layer_depth_tests = {};
    voice = new charvoice_default();
    x_prev = x;
    x_new = x;
    x_change_anim = 1;
    x_change_time = 15;
    surface = -1;
    
    set_surface = function()
    {
        if (surface_exists(surface))
        {
            surface_free(surface);
        }
        var _w = round_to_multiple(sprite_get_width(pose_sprite), 2);
        var _h = round_to_multiple(sprite_get_height(pose_sprite), 2);
        surface = surface_create(_w, _h);
    };
    
    _draw = draw_charportrait_basic;
    sprite_dir = 1;
    pose_face_grid = [[spr_cp_p_p0, spr_cp_p_p0f0]];
    
    set_sprites = function()
    {
        set_pose_sprite();
        set_face_sprite();
        set_surface();
    };
    
    set_pose_sprite = function()
    {
        pose_sprite = get_pose_sprite();
    };
    
    set_face_sprite = function()
    {
        var getface = get_face_sprite();
        if (face_sprite != getface)
        {
            face_sprite = getface;
        }
    };
    
    get_pose_sprite = function()
    {
        pose %= array_length(pose_face_grid);
        return pose_face_grid[pose][0];
    };
    
    get_face_sprite = function()
    {
        var _face_spr = pose_face_grid[pose][(face + 1) % array_length(pose_face_grid[pose])];
        return _face_spr;
    };
}

function charvoice_default() constructor
{
    sounds = [snd_charvoice_default];
    pitch = 1;
    gain = 1;
    _mod = 2;
    plays = 1;
    pitch_variance = 0.1;
    
    _play = function()
    {
        if (gain <= 0)
        {
            exit;
        }
        if ((plays % _mod) != 0)
        {
            plays++;
            exit;
        }
        var _ind = irandom(array_length(sounds) - 1);
        var _snd = sounds[_ind];
        var _pitch = pitch + random_range(-pitch_variance, pitch_variance);
        sfx_play(_snd, false, gain, 0, _pitch);
        plays++;
    };
}

function charvoice_none() : charvoice_default() constructor
{
    gain = 0;
}

function charvoice_high() : charvoice_default() constructor
{
    pitch = 1.1;
}

function charvoice_low() : charvoice_default() constructor
{
    pitch = 0.9;
}

function charvoice_terminal() : charvoice_default() constructor
{
    gain = 1.6;
    sounds = [snd_charvoice_terminal];
    pitch = 1;
    pitch_variance = 0.3;
}

function charvoice_announcer() : charvoice_default() constructor
{
    pitch = 1;
    sounds = [snd_charvoice_announcer];
    _mod = 3;
}

function charvoice_announcer_small() : charvoice_announcer() constructor
{
    sounds = [snd_charvoice_announcer_small];
}

function charvoice_pandora() : charvoice_default() constructor
{
}

function charvoice_smalls() : charvoice_low() constructor
{
}

function charvoice_abbie() : charvoice_high() constructor
{
}

function dialogue_get_character_name_struct()
{
    var name_struct = 
    {
        abbie: 
        {
            text: "Abbie",
            sprite: spr_dialogue_speaker_abbie
        },
        pandora: 
        {
            text: "Pandora",
            sprite: spr_dialogue_speaker_pandora
        },
        smalls: 
        {
            text: "Smalls",
            sprite: spr_dialogue_speaker_smalls
        },
        alex: 
        {
            text: "Alex",
            sprite: spr_dialogue_speaker_alex
        },
        dom: 
        {
            text: "Dom",
            sprite: spr_dialogue_speaker_dom
        },
        kat: 
        {
            text: "Kat",
            sprite: spr_dialogue_speaker_kat
        },
        slate: 
        {
            text: "Slate",
            sprite: spr_dialogue_speaker_slate
        },
        roxy: 
        {
            text: "Roxy",
            sprite: spr_dialogue_speaker_roxy
        },
        terminal: 
        {
            text: "Terminal",
            sprite: spr_dialogue_speaker_terminal
        },
        mystery: 
        {
            text: "???",
            sprite: spr_dialogue_speaker_mystery
        }
    };
    return name_struct;
}

function dialogue_get_character_name_string(arg0)
{
    var name_struct = dialogue_get_character_name_struct();
    var _key = arg0;
    if (!struct_exists(name_struct, _key))
    {
        _key = "mystery";
    }
    return struct_get(name_struct, _key).text;
}

function dialogue_get_character_name_sprite(arg0)
{
    var name_struct = dialogue_get_character_name_struct();
    var _key = arg0;
    if (!struct_exists(name_struct, _key))
    {
        _key = "mystery";
    }
    return struct_get(name_struct, _key).sprite;
}

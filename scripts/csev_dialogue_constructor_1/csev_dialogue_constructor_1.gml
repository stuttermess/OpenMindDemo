function csev_dialogue_constructor0() : csev_base_constructor() constructor
{
    _event_type = 1;
    _cutscene_controller = -1;
    background_sequence = -1;
    background_sequence_layer = -1;
    background_sprite = -1;
    background_transition_shader = -1;
    background_sprite_does_pan = true;
    _script = [];
    _events = [];
    _markers = {};
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
    current_event = 0;
    current_letter = 0;
    text = "";
    text_styles = {};
    text_pause = 0;
    text_speed = 1;
    skip_line = 0;
    inline_events = {};
    speaker = "";
    speaker_sprite = -1;
    characters = [];
    char_id_to_index = {};
    draw_order = [];
    flags_were_changed = false;
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
    log_open = false;
    log_list = [];
    log_obj = new dialogue_log_constructor();
    log_obj.list = log_list;
    
    log_obj._on_close = function()
    {
        log_open = false;
    };
    
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
    
    _init = function()
    {
        if (_cutscene_controller.keep_sequence != -1)
        {
            background_sequence = _cutscene_controller.keep_sequence;
            background_sequence_layer = _cutscene_controller.keep_sequence_layer;
        }
        _script_to_events();
        _perform_script_event(current_event);
    };
    
    _end = function()
    {
        log_obj._destroy();
    };
    
    _tick = function()
    {
        if (allow_player_input && !instance_exists(obj_lobby_controller))
        {
            if (keyboard_check_pressed(vk_tab) && !log_open)
            {
                log_open = true;
                log_obj.open();
            }
        }
        if (log_open)
        {
            log_obj._tick();
        }
        if (pause_menu.active)
        {
            pause_menu.tick();
        }
        else
        {
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
        var continue_btn = ((mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_space)) && allow_player_input) || skip_line;
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
        var text_active = intro_anim >= 0.9 && wait_countdown == 0;
        if (wait_countdown > 0)
        {
            wait_countdown--;
            if (wait_countdown <= 0)
            {
                next_event();
            }
        }
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
        if (skip_line == -1 && cam_side_move_anim == 1 && current_letter >= min(1, string_length(text) / 5))
        {
            skip_line = 0;
        }
        if (show_options)
        {
            ffwd_btn = false;
        }
        if (text_active)
        {
            if (show_options)
            {
                if (option_hover != undefined)
                {
                    if ((get_input_click(1) && allow_player_input) && option_hover >= 0 && option_hover < array_length(options))
                    {
                        var _thisop = options[option_hover];
                        switch (_thisop[1])
                        {
                            case 0:
                                var marker_evnum = struct_get(_markers, _thisop[2]);
                                if (!is_undefined(marker_evnum))
                                {
                                    current_event = marker_evnum + 1;
                                    _perform_script_event(current_event);
                                    do_next_event = false;
                                }
                                break;
                            case 1:
                                _script = load_dialogue_script("scripts/" + _thisop[2] + ".mwsc");
                                _script_to_events();
                                current_event = 0;
                                _perform_script_event(current_event);
                                break;
                        }
                        show_options = false;
                        options = [];
                    }
                }
            }
            else
            {
                if (!window_has_focus())
                {
                    continue_cooldown = 10;
                }
                if (current_letter <= string_length(text) && !skip_line)
                {
                    if (cam_side_display == cam_side)
                    {
                        var _prev_letter = current_letter;
                        if (continue_btn || ffwd_speed == 10)
                        {
                            current_letter = string_length(text);
                            continue_cooldown = 0;
                            text_pause = 0;
                        }
                        if (text_pause > 0)
                        {
                            text_pause--;
                        }
                        else
                        {
                            var _textlen = string_length(text);
                            var _inc = 0.75 * (text_speed + ffwd_speed);
                            current_letter += _inc;
                            current_letter = clamp(current_letter, 0, string_length(text) + 1);
                            var i = floor(_prev_letter);
                            while (i < floor(current_letter))
                            {
                                var _letter_inline_events = struct_get(inline_events, i);
                                for (var j = 0; j < array_length(_letter_inline_events); j++)
                                {
                                    _perform_inline_event(_letter_inline_events[j]);
                                }
                                i++;
                            }
                            _prev_letter = current_letter;
                        }
                    }
                }
                else
                {
                    if ((continue_btn && continue_cooldown <= 0) || ffwd_btn || skip_line)
                    {
                        next_event();
                    }
                    if (continue_cooldown > 0)
                    {
                        continue_cooldown--;
                    }
                }
                if (ffwd_btn)
                {
                    ffwd_speed = clamp(ffwd_speed, ffwd_base_speed, 10);
                }
            }
        }
        if (!ffwd_btn)
        {
            ffwd_speed = 0;
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
                    speaker_char.last_spoke = current_event;
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
            blendmode_set_add();
            var col = 2621480;
            draw_clear_alpha(col, intro_ease(intro_anim));
            blendmode_reset();
            blendmode_cleanup();
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
        if (show_options && (cam_side_display == cam_side || cam_side_move_anim >= 0.5))
        {
            var _ret = draw_dialogue_box(tb_x, options_text, -1, speaker_sprite, -cam_side_display, text_styles);
            if (_ret != option_hover && !paused)
            {
                option_hover = _ret;
            }
        }
        else
        {
            draw_dialogue_box(tb_x, text, current_letter, speaker_sprite, -cam_side_display, text_styles, skip_line == 0 && allow_player_input);
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
                var is_speaking = bool(speaker_struct == _char) || !_char.darken_when_not_speaking;
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
    
    next_event = function()
    {
        current_event++;
        if (current_event < array_length(_events))
        {
            _perform_script_event(current_event);
        }
        else if (!outro)
        {
            outro = true;
            intro_anim = 1;
            if (returning_from_inserted_sequence)
            {
                skip_outro = true;
            }
            if (flags_were_changed)
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
        }
    };
    
    _perform_script_event = function(arg0)
    {
        var _ev = _events[arg0];
        var do_next_event = true;
        switch (_ev[0])
        {
            case "skip_event":
                break;
            case "skip":
                if (array_contains(_ev, "intro"))
                {
                    skip_intro = true;
                }
                if (array_contains(_ev, "outro"))
                {
                    skip_outro = true;
                }
                break;
            case "next_line":
                break;
            case "dialogue":
                returning_from_inserted_sequence = false;
                skip_line = -1;
                current_letter = 0;
                text_pause = 0;
                continue_cooldown = continue_cooldown_max;
                text = _ev[1];
                inline_events = _ev[2];
                text_styles = _ev[3];
                text_speed = 1;
                do_next_event = false;
                var _list = log_list;
                if (instance_exists(obj_lobby_controller))
                {
                    _list = obj_lobby_controller.dialogue_log;
                }
                var speaker_index = struct_get(char_id_to_index, speaker);
                var speaker_struct = -1;
                if (speaker_index != -1 && !is_undefined(speaker_index))
                {
                    speaker_struct = characters[speaker_index];
                }
                log_dialogue_line(_list, text, speaker_struct);
                break;
            case "clear_options":
                options = [];
                options_text = [];
                break;
            case "shuffle_options":
                array_shuffle_ext(options);
                break;
            case "add_option":
                var _new_option = _ev[1];
                array_push(options, _new_option);
                break;
            case "options":
                if (is_array(_ev[1]))
                {
                    options = _ev[1];
                }
                options_text = [];
                for (var i = 0; i < array_length(options); i++)
                {
                    options_text[i] = options[i][0];
                }
                show_options = true;
                returning_from_inserted_sequence = false;
                text = "";
                current_letter = 0;
                text_pause = 0;
                continue_cooldown = continue_cooldown_max;
                do_next_event = false;
                break;
            case "set_speaker":
                var _speaker_id = _ev[1];
                speaker = _speaker_id;
                text = "";
                var speaker_index = struct_get(char_id_to_index, _speaker_id);
                if (speaker_index != -1)
                {
                    var speaker_struct = characters[speaker_index];
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
                break;
            case "define_character":
                var _char = _script_define_character(_ev[1], _ev[2], _ev[3]);
                _char.x = _ev[4];
                _char.x_prev = _char.x;
                _char.x_new = _char.x;
                break;
            case "set_character_value":
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
                break;
            case "goto_marker":
                var marker_evnum = struct_get(_markers, _ev[1]);
                if (!is_undefined(marker_evnum))
                {
                    current_event = marker_evnum;
                    _perform_script_event(current_event);
                    do_next_event = false;
                }
                break;
            case "goto_script":
                _script = load_dialogue_script("scripts/" + _ev[1] + ".mwsc");
                _script_to_events();
                current_event = 0;
                _perform_script_event(current_event);
                do_next_event = false;
                break;
            case "flag":
                set_story_flag(_ev[1], _ev[2]);
                flags_were_changed = true;
                break;
            case "increment_flag":
                var _flag_value = get_story_flag(_ev[1], 0);
                if (is_real(_flag_value))
                {
                    set_story_flag(_ev[1], _flag_value + _ev[2]);
                    flags_were_changed = true;
                }
                break;
            case "checkflag":
                var _flagname = _ev[1];
                var _desired_value = _ev[2];
                var _value = get_story_flag(_flagname);
                if (is_real(_value) && is_string(_desired_value))
                {
                    _value = string(_value);
                }
                if (_value == _desired_value)
                {
                }
                else
                {
                    current_event++;
                }
                break;
            case "function":
                var _funcname = _ev[1];
                var _func = asset_get_index(_funcname);
                var _args = _ev[2];
                var _validfunc = false;
                if (script_exists(_func))
                {
                    script_execute_ext(_func, _args);
                    _validfunc = true;
                }
                else if (instance_exists(obj_lobby_controller))
                {
                    if (variable_instance_exists(obj_lobby_controller, _funcname))
                    {
                        var _met = variable_instance_get(obj_lobby_controller, _funcname);
                        if (is_method(_met))
                        {
                            method_call(_met, _args);
                            _validfunc = true;
                        }
                    }
                    else if (variable_struct_exists(obj_lobby_controller.lobby, _funcname))
                    {
                        var _met = variable_struct_get(obj_lobby_controller.lobby, _funcname);
                        if (is_method(_met))
                        {
                            method_call(_met, _args);
                            _validfunc = true;
                        }
                    }
                }
                if (!_validfunc)
                {
                    show_message("Error in script.\nInvalid function.");
                }
                break;
            case "face":
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
                break;
            case "allow_player_input":
                allow_player_input = bool(_ev[1]);
                break;
            case "sequence":
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
                do_next_event = false;
                break;
            case "wait":
                var _frames = _ev[1];
                wait_countdown = _frames;
                do_next_event = false;
                returning_from_inserted_sequence = false;
                break;
        }
        if (do_next_event)
        {
            next_event();
            return true;
        }
        return false;
    };
    
    _perform_inline_event = function(arg0)
    {
        var _ev = arg0;
        switch (_ev[0])
        {
            case "color":
            case "c":
                break;
            case "pause":
            case "p":
                if (ffwd_speed == 0)
                {
                    if (array_length(_ev) == 1)
                    {
                        var _prev_char = string_char_at(text, current_letter - 1);
                        switch (_prev_char)
                        {
                            case ".":
                            case "!":
                            case "?":
                                text_pause = 30;
                                break;
                            case ",":
                            case "-":
                            case ":":
                            case ";":
                            default:
                                text_pause = 10;
                                break;
                        }
                    }
                    else
                    {
                        switch (_ev[1])
                        {
                            case "comma":
                            case "short":
                            case ",":
                                text_pause = 10;
                                break;
                            case "period":
                            case "long":
                            case ".":
                                text_pause = 30;
                                break;
                            default:
                                text_pause = real(_ev[1]);
                                break;
                        }
                    }
                    current_letter = floor(current_letter);
                }
                break;
            case "speed":
                text_speed = real(_ev[1]);
                break;
            case "skip":
                skip_line = true;
                break;
        }
    };
    
    _add_dialogue_line = function(arg0)
    {
        arg0 = string_replace_all(arg0, "\\n", "\n");
        var _inline_events = {};
        var _text_styles = {};
        for (var _letter = 1; _letter < string_length(arg0); _letter++)
        {
            var first_marker = string_pos_ext("|", arg0, _letter);
            var event_letter = first_marker - 1;
            if (first_marker == 0)
            {
                _letter = string_length(arg0);
            }
            else
            {
                var next_marker = string_pos_ext("|", arg0, first_marker + 1);
                if (next_marker != 0 && next_marker != first_marker)
                {
                    var _args_str = string_copy(arg0, first_marker + 1, next_marker - first_marker - 1);
                    var _args = parse_event_arguments(_args_str);
                    if (array_length(_args) > 0)
                    {
                        if (struct_exists(_inline_events, event_letter))
                        {
                            var _arr = struct_get(_inline_events, event_letter);
                            array_push(_arr, _args);
                        }
                        else
                        {
                            struct_set(_inline_events, event_letter, [_args]);
                        }
                        switch (_args[0])
                        {
                            case "style":
                            case "color":
                            case "font":
                                if (struct_exists(_text_styles, event_letter))
                                {
                                    var _arr = struct_get(_text_styles, event_letter);
                                    array_push(_arr, _args);
                                }
                                else
                                {
                                    struct_set(_text_styles, event_letter, [_args]);
                                }
                                break;
                        }
                    }
                    arg0 = string_delete(arg0, first_marker, (next_marker - first_marker) + 1);
                    _letter--;
                }
            }
        }
        array_push(_events, ["dialogue", arg0, _inline_events, _text_styles]);
    };
    
    _add_dialogue_options = function(arg0, arg1)
    {
        if (options_add_mode)
        {
            arg0 = 0;
        }
        _events[arg1] = ["options", arg0];
    };
    
    _script_to_events = function()
    {
        var char_defs = char_id_to_index;
        _events = [];
        _markers = {};
        loaded_line = "";
        options_add_mode = false;
        for (var i = 0; i < array_length(_script); i++)
        {
            var __first_args = parse_event_arguments(_script[i], 2);
            var __skip = false;
            if (string_copy(_script[i], 1, 2) == "//")
            {
                __skip = true;
            }
            if (__skip)
            {
                lalala = 0;
            }
            if (array_length(__first_args) > 0 && !__skip)
            {
                var first_arg = __first_args[0];
                switch (first_arg)
                {
                    case "char":
                        var _args = parse_event_arguments(_script[i]);
                        var charname = "";
                        var charid = "";
                        var charside = 0;
                        var charxoff = 0;
                        if (array_length(_args) > 1)
                        {
                            charname = _args[1];
                        }
                        if (array_length(_args) > 2)
                        {
                            charid = _args[2];
                        }
                        if (array_length(_args) > 3)
                        {
                            charside = _args[3];
                        }
                        if (array_length(_args) > 4)
                        {
                            charxoff = _args[4];
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
                        array_push(_events, ["define_character", charname, charid, charside, charxoff]);
                        struct_set(char_defs, charid, 1);
                        break;
                    case "line":
                        var _args = parse_event_arguments(_script[i]);
                        if (array_length(_args) == 1)
                        {
                            if (loaded_line == "")
                            {
                                array_push(_events, ["skip_event"]);
                            }
                            else
                            {
                                var _last_slash = string_last_pos("/", loaded_line);
                                var _last_period = string_last_pos(".", loaded_line);
                                var _last_char = max(_last_slash, _last_period);
                                var _without_num = string_copy(loaded_line, 1, _last_char);
                                var _num = string_copy(loaded_line, _last_char + 1, string_length(loaded_line) - _last_char);
                                try
                                {
                                    _num = real(_num);
                                }
                                catch (wawa)
                                {
                                }
                                if (is_real(_num))
                                {
                                    loaded_line = _without_num + string(_num + 1);
                                    var _dialogue_str = strloc(loaded_line);
                                    _add_dialogue_line(_dialogue_str);
                                }
                                else
                                {
                                    array_push(_events, ["skip_event"]);
                                }
                            }
                        }
                        else
                        {
                            loaded_line = _args[1];
                            var _dialogue_str = strloc(loaded_line);
                            if (_dialogue_str == "")
                            {
                                _dialogue_str = loaded_line;
                                loaded_line = "";
                            }
                            _add_dialogue_line(_dialogue_str);
                        }
                        break;
                    case "setflag":
                    case "flag":
                        var _args = parse_event_arguments(_script[i]);
                        var flagname = _args[1];
                        var flagvalue = _args[2];
                        try
                        {
                            flagvalue = real(flagvalue);
                        }
                        catch (_exception)
                        {
                        }
                        array_push(_events, ["flag", flagname, flagvalue]);
                        break;
                    case "incflag":
                    case "incrementflag":
                    case "inc_flag":
                    case "increment_flag":
                        var _args = parse_event_arguments(_script[i]);
                        var flagname = _args[1];
                        var flaginc = _args[2];
                        var _valid = true;
                        try
                        {
                            flaginc = real(flaginc);
                        }
                        catch (_exception)
                        {
                            _valid = false;
                        }
                        if (_valid)
                        {
                            array_push(_events, ["increment_flag", flagname, flaginc]);
                        }
                        break;
                    case "set":
                        var _args = parse_event_arguments(_script[i]);
                        array_push(_events, ["set_character_value", _args[1], _args[2], _args[3]]);
                        break;
                    case "skip":
                        var _args = parse_event_arguments(_script[i]);
                        if (array_length(_args) > 1)
                        {
                            array_push(_events, ["skip"]);
                            array_copy(_events[i], 1, _args, 1, array_length(_args) - 1);
                        }
                        else
                        {
                            array_push(_events, ["skip_event"]);
                        }
                        break;
                    case "goto":
                        var _args = parse_event_arguments(_script[i]);
                        switch (_args[1])
                        {
                            case "script":
                                array_push(_events, ["goto_script", _args[2]]);
                                break;
                            case "marker":
                                array_push(_events, ["goto_marker", _args[2]]);
                                break;
                        }
                        break;
                    case "options":
                    case "option":
                        var _args = parse_event_arguments(_script[i]);
                        var skipthis = true;
                        switch (_args[1])
                        {
                            case "function":
                                var _func = asset_get_index(_args[2]);
                                if (script_exists(_func))
                                {
                                    options_setup = _func();
                                }
                                break;
                            case "clear":
                                options_add_mode = false;
                                options_setup = [];
                                array_push(_events, ["clear_options"]);
                                skipthis = false;
                                break;
                            case "shuffle":
                                array_shuffle_ext(options_setup);
                                array_push(_events, ["shuffle_options"]);
                                skipthis = false;
                                break;
                            case "amount":
                                var _amount = real(_args[2]);
                                options_setup = array_create(_amount, 0);
                                for (var j = 0; j < _amount; j++)
                                {
                                    options_setup[j] = ["", 0, -1];
                                }
                                break;
                            case "show":
                                _add_dialogue_options(options_setup, i);
                                options_setup = [];
                                skipthis = false;
                                break;
                            case "add":
                                options_add_mode = true;
                                var option_num = array_length(options_setup);
                                var _new_option = ["", 0, -1];
                                for (var j = 2; j < array_length(_args); j += 2)
                                {
                                    var _type = _args[j];
                                    var _value = _args[j + 1];
                                    switch (_type)
                                    {
                                        case "name":
                                            var _loc = strloc(_value);
                                            if (_loc == "")
                                            {
                                                _loc = _value;
                                            }
                                            _new_option[0] = _loc;
                                            break;
                                        case "marker":
                                            _new_option[1] = 0;
                                            _new_option[2] = _value;
                                            break;
                                        case "script":
                                            _new_option[1] = 1;
                                            _new_option[1] = 1;
                                            _new_option[2] = _value;
                                            break;
                                    }
                                }
                                array_push(_events, ["add_option", _new_option]);
                                skipthis = false;
                                break;
                            default:
                                options_add_mode = false;
                                var option_num = real(_args[1]);
                                switch (_args[2])
                                {
                                    case "name":
                                        var _str = strloc(_args[3]);
                                        if (_str == "")
                                        {
                                            _str = _args[3];
                                        }
                                        var _option = options_setup[option_num];
                                        _option[0] = _str;
                                        break;
                                    case "goto":
                                        switch (_args[3])
                                        {
                                            case "marker":
                                                options_setup[option_num][1] = 0;
                                                options_setup[option_num][2] = _args[4];
                                                break;
                                            case "script":
                                                options_setup[option_num][1] = 1;
                                                options_setup[option_num][2] = _args[4];
                                                break;
                                        }
                                        break;
                                }
                                break;
                        }
                        if (skipthis)
                        {
                            array_push(_events, ["skip_event"]);
                        }
                        break;
                    case "marker":
                        var _args = parse_event_arguments(_script[i]);
                        struct_set(_markers, _args[1], array_length(_events));
                        array_push(_events, ["skip_event"]);
                        break;
                    case "checkflag":
                    case "conditional":
                        var _args = parse_event_arguments(_script[i]);
                        var _flagname = _args[1];
                        var _value = _args[2];
                        array_push(_events, ["checkflag", _flagname, _value]);
                        break;
                    case "func":
                    case "function":
                        var _args = parse_event_arguments(_script[i]);
                        var _func_args = [];
                        if (array_length(_args) > 2)
                        {
                            array_copy(_func_args, 0, _args, 2, array_length(_args) - 2);
                        }
                        array_push(_events, ["function", _args[1], _func_args]);
                        break;
                    case "face":
                    case "pose":
                        var _args = parse_event_arguments(_script[i]);
                        if (array_length(_args) == 4)
                        {
                            array_push(_events, ["face", _args[1], real(_args[2]), real(_args[3])]);
                        }
                        else
                        {
                            show_message("Error in script at event number " + string(i) + ".\n" + _script[i] + "\nWrong number of arguments for \"face\" (expected 3)");
                        }
                        break;
                    case "allow_player_input":
                        var _args = parse_event_arguments(_script[i]);
                        array_push(_events, ["allow_player_input", _args[1]]);
                        break;
                    case "sequence":
                        var _args = parse_event_arguments(_script[i]);
                        array_delete(_args, 0, 1);
                        var _seq_id = -1;
                        var _seq_script_path = "";
                        for (var j = 0; j < (array_length(_args) - 1); j += 2)
                        {
                            var _argname = _args[j];
                            var _argvalue = _args[j + 1];
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
                            array_push(_events, ["skip_event"]);
                        }
                        else
                        {
                            array_push(_events, ["sequence", _seq_id, _seq_script_path]);
                        }
                        break;
                    case "wait":
                        var _args = parse_event_arguments(_script[i]);
                        var _frames = 0;
                        _frames = real(_args[1]);
                        if (array_length(_args) > 2)
                        {
                            switch (_args[2])
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
                        array_push(_events, ["wait", _frames]);
                        break;
                    default:
                        if (array_length(__first_args) == 1 && struct_exists(char_defs, __first_args[0]))
                        {
                            var _args = parse_event_arguments(_script[i]);
                            array_push(_events, ["set_speaker", _args[0]]);
                        }
                        else
                        {
                            _add_dialogue_line(_script[i]);
                        }
                        break;
                }
            }
            else
            {
                array_push(_events, ["skip_event"]);
            }
        }
        var lalala = 0;
    };
    
    parse_event_arguments = function(arg0, arg1 = infinity)
    {
        var _args_array = [];
        var _str = arg0;
        var _endchar = " ";
        while (string_length(_str) > 0 && array_length(_args_array) < arg1)
        {
            var word_end = string_pos(_endchar, _str) - 1;
            while (string_char_at(_str, word_end) == "\\" && word_end != 0)
            {
                word_end = string_pos_ext(_endchar, _str, word_end + 2) - 1;
            }
            if (word_end <= 0)
            {
                word_end = string_length(_str);
            }
            var _this_arg = string_copy(_str, 1, word_end);
            var _arglen = string_length(_this_arg);
            _this_arg = string_replace_all(_this_arg, "\\\"", "\"");
            if (_this_arg != "")
            {
                array_push(_args_array, _this_arg);
            }
            _str = string_delete(_str, 1, _arglen);
            while (string_char_at(_str, 1) == _endchar)
            {
                _str = string_delete(_str, 1, 1);
            }
            while (string_char_at(_str, 1) == " ")
            {
                _str = string_delete(_str, 1, 1);
            }
            if (string_char_at(_str, 1) == "\"")
            {
                _endchar = "\"";
                _str = string_delete(_str, 1, 1);
            }
            else
            {
                _endchar = " ";
            }
        }
        return _args_array;
    };
    
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
                _char.voice = new charvoice_default();
                _char.pose_face_grid = [[spr_cp_p_p0, spr_cp_p_p0f0, spr_cp_p_p0f1, spr_cp_p_p0f2, spr_cp_p_p0f3, spr_cp_p_p0f4], [spr_cp_p_p1, spr_cp_p_p1f0, spr_cp_p_p1f1, spr_cp_p_p1f2, -1, -1], [spr_cp_p_p2, -1, -1, -1, -1, -1], [spr_cp_p_p3, -1, -1, -1, -1, -1], [spr_cp_p_p4, spr_cp_p_p4f0, -1, -1, -1, -1]];
                break;
            case "smalls":
                name = "smalls";
                _char.icon = spr_dloghead_smalls;
                _char.voice = new charvoice_default();
                _char.pose_face_grid = [[spr_cp_s_p0, spr_cp_s_p0f0, spr_cp_s_p0f1, spr_cp_s_p0f2, spr_cp_s_p0f3], [spr_cp_s_p1, spr_cp_s_p1f0, -1, -1, -1], [spr_cp_s_p2, spr_cp_s_p2f0, spr_cp_s_p2f1, -1, -1]];
                break;
            case "abbie":
                name = "abbie";
                _char.icon = spr_dloghead_abbie;
                _char.voice = new charvoice_high();
                _char.sprite_dir = -1;
                _char.pose_face_grid = [[spr_cp_ab_p0, spr_cp_ab_p0f0, -1, -1], [spr_cp_ab_p1, spr_cp_ab_p1f0, -1, spr_cp_ab_p1f2], [spr_cp_ab_p2, -1, -1, spr_cp_ab_p2], [spr_cp_ab_p3, -1, spr_cp_ab_p3, -1], [spr_cp_ab_p4, -1, spr_cp_ab_p4, -1]];
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
                _char.pose_face_grid = [[spr_cp_dm_p0, spr_cp_dm_p0f0, -1], [spr_cp_dm_p1, spr_cp_dm_p1f0, spr_cp_dm_p1f1]];
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
            if (arg0.front_when_speak && speaker == arg0.id)
            {
                return 1;
            }
            if (arg1.front_when_speak && speaker == arg1.id)
            {
                return -1;
            }
            var _layer_diff = arg0.layer - arg1.layer;
            var _sort = 0;
            if (arg0.side == arg1.side)
            {
                if (_layer_diff == 0)
                {
                    var _front_when_speak_diff = arg0.front_when_speak - arg1.front_when_speak;
                    if (_front_when_speak_diff == 0)
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

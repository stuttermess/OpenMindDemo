function csev_sequence_constructor_1() : csev_base_constructor() constructor
{
    _event_type = 0;
    _cutscene_controller = -1;
    start_frame = 0;
    end_frame = infinity;
    sequence_id = -1;
    sequence = -1;
    sequence_layer = -1;
    sequence_layer_depth = 10;
    loop_start_frame = -1;
    loop_end_frame = -1;
    paused = false;
    markers = {};
    destroy_on_end = true;
    inserted_in_dialogue = -1;
    tb_auto = false;
    tb_display = 0;
    tb_show = false;
    tb_letter = 0;
    tb_speed = 0.5;
    inline_events = {};
    text_styles = {};
    _events = [];
    _script = [];
    current_event = -1;
    event_is_dialogue = false;
    next_event_on_frame = -1;
    pause_on_frame = -1;
    no_text_continue_until_frame = -1;
    tb_wavy = 0;
    tb_wavy_intensity = 0;
    tb_wavy_speed = 1;
    tb_wavy_frequency = 80;
    tb_wavy_size = 5;
    tb_wavy_incspd = 0;
    music_tracks = [];
    sfx_tracks = [];
    tb_str = "";
    tb_pause_until_line = -1;
    sq_loop_start = -1;
    sq_loop_end = -1;
    tb_animate = false;
    tb_auto = false;
    tb_auto_time = 120;
    skip = false;
    skippable = true;
    skip_frame = -1;
    skippable_after_skip_frame = true;
    skip_through = false;
    use_as_dialogue_background = false;
    pause_sounds = [];
    
    _init = function()
    {
        volumes_set = false;
        volumes_prev_track_length = -1;
        _play();
        next_event();
        
        pause_menu.on_resume_click = function()
        {
            _user_set_pause(false);
        };
    };
    
    past_first_frame = false;
    
    _tick = function()
    {
        _set_volumes();
        var _dt = delta_time / 1000000;
        if (_dt >= 0.02)
        {
            layer_sequence_headpos(sequence, layer_sequence_get_headpos(sequence));
        }
        past_first_frame = past_first_frame || layer_sequence_get_headpos(sequence) > 0;
        if (!user_paused)
        {
            if (event_is_dialogue)
            {
                tb_letter += tb_speed;
                tb_letter = clamp(tb_letter, 0, string_length(tb_str));
                if (!tb_auto)
                {
                    var continue_btn = mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_space);
                    if (continue_btn)
                    {
                        if (tb_letter < string_length(tb_str))
                        {
                            tb_letter = string_length(tb_str);
                        }
                        else if (no_text_continue_until_frame == -1)
                        {
                            next_event();
                        }
                    }
                }
            }
            var seq_frame = layer_sequence_get_headpos(sequence);
            if (loop_start_frame != -1 && loop_end_frame != -1)
            {
                if (seq_frame >= loop_end_frame || layer_sequence_is_finished(sequence))
                {
                    var diff = seq_frame - loop_end_frame;
                    seq_frame = loop_start_frame + 1 + diff;
                    layer_sequence_headpos(sequence, seq_frame);
                }
            }
            if (seq_frame >= next_event_on_frame && next_event_on_frame >= 0)
            {
                next_event_on_frame = -1;
                next_event();
            }
            if (seq_frame >= pause_on_frame && pause_on_frame >= 0)
            {
                _pause();
                pause_on_frame = -1;
            }
            if (seq_frame >= no_text_continue_until_frame && no_text_continue_until_frame >= 0)
            {
                no_text_continue_until_frame = -1;
            }
            if (tb_wavy_intensity != tb_wavy)
            {
                if (abs(tb_wavy - tb_wavy_intensity) < tb_wavy_incspd)
                {
                    tb_wavy_intensity = tb_wavy;
                }
                else
                {
                    tb_wavy_intensity += (sign(tb_wavy - tb_wavy_intensity) * tb_wavy_incspd);
                }
            }
        }
        if (get_skip_input())
        {
            skip = true;
        }
        else if (get_pause_input())
        {
            if (!user_paused)
            {
                if (!(layer_sequence_is_finished(sequence) || layer_sequence_get_headpos(sequence) >= end_frame))
                {
                    _user_set_pause(!user_paused);
                }
            }
        }
        if (!user_paused && _cutscene_controller != -1)
        {
            if (sequence != -1 && ((layer_sequence_is_finished(sequence) || (skip && skippable) || layer_sequence_get_headpos(sequence) >= end_frame) && loop_end_frame == -1))
            {
                var _isdiag = false;
                var _nextev = true;
                var _destroy_sequence = true;
                if (use_as_dialogue_background)
                {
                    with (_cutscene_controller)
                    {
                        if ((current_event_id + 1) < (array_length(events) - 1))
                        {
                            var newev = events[current_event_id + 1];
                            if (newev._event_type == 1)
                            {
                                _isdiag = true;
                            }
                        }
                    }
                }
                var _skipped = false;
                if (_isdiag)
                {
                    _cutscene_controller.keep_sequence = sequence;
                    _cutscene_controller.keep_sequence_layer = sequence_layer;
                    layer_sequence_headpos(sequence, min(end_frame, layer_sequence_get_length(sequence)) - 1);
                    layer_sequence_pause(sequence);
                }
                else if (skip)
                {
                    _skipped = true;
                    if (layer_sequence_get_headpos(sequence) < skip_frame)
                    {
                        layer_sequence_headpos(sequence, skip_frame);
                        _nextev = false;
                    }
                    else if (destroy_on_end)
                    {
                        layer_sequence_destroy(sequence);
                    }
                    skippable = skippable_after_skip_frame;
                    skip = false;
                }
                else if (destroy_on_end)
                {
                    layer_sequence_destroy(sequence);
                }
                if (_nextev)
                {
                    if (is_struct(inserted_in_dialogue))
                    {
                        _end();
                        _cutscene_controller.current_event = inserted_in_dialogue;
                        _cutscene_controller.events[_cutscene_controller.current_event_id] = inserted_in_dialogue;
                        inserted_in_dialogue.returning_from_inserted_sequence = true;
                        inserted_in_dialogue.next_event();
                    }
                    else if (_skipped)
                    {
                        with (_cutscene_controller)
                        {
                            var _match = true;
                            var _evnum = current_event_id + 1;
                            while (_evnum < array_length(events) && _match)
                            {
                                var _ev = events[_evnum];
                                _match = _ev.skip_through;
                                if (!_match)
                                {
                                    _evnum -= 1;
                                }
                                _evnum++;
                            }
                            if (_evnum >= array_length(events))
                            {
                                _on_finish();
                                instance_destroy(controller_object);
                            }
                            else
                            {
                                end_current_event();
                                current_event_id = _evnum;
                                start_current_event();
                            }
                        }
                    }
                    else
                    {
                        _cutscene_controller.next_event();
                    }
                }
            }
        }
    };
    
    text = 
    {
        paused_text: strloc("system/cutscene/paused_text"),
        skip_button: strloc("system/cutscene/skip_button"),
        skipping_text: strloc("system/cutscene/skipping_text")
    };
    
    _first_frame_draw = function()
    {
    };
    
    _draw = function()
    {
        if (!past_first_frame)
        {
            _first_frame_draw();
        }
        if (string_length(tb_str) > 0)
        {
            var tbx = 240;
            var tby = 251;
            var tbw = 350;
            if (tb_wavy > 0)
            {
                var _tbsf = surface_create(480, 270);
                surface_set_target(_tbsf);
                draw_clear_alpha(c_black, 0);
                _draw_textbox(tbx, tby, tbw);
                surface_reset_target();
                shader_set_wavy_texture(surface_get_texture(_tbsf), current_time / 1000, tb_wavy_speed, tb_wavy_frequency, tb_wavy_size * tb_wavy_intensity, 0, 0, 0);
                draw_surface(_tbsf, 0, 0);
                shader_reset();
                surface_free(_tbsf);
            }
            else
            {
                _draw_textbox(tbx, tby, tbw);
            }
        }
        if (_skip_held_time > 20)
        {
            var _skipstr = text.skipping_text;
            var _prog = (_skip_held_time - 20) / (skip_hold_time - 20);
            _skipstr = string_copy(_skipstr, 1, (string_length(_skipstr) - 3) + ceil(_prog * 3));
            draw_text_outline(5, 5, _skipstr);
        }
        if (user_paused)
        {
            var crframe = 0;
            pause_menu.tick();
            pause_menu.draw();
            if (pause_menu.cursor_hover != -1)
            {
                crframe = 1;
                if (mouse_check_button(mb_left))
                {
                    crframe = 2;
                }
            }
            if (!pause_menu.options_open)
            {
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                if (skippable && user_skippable)
                {
                    var _str = text.skip_button;
                    var _wid = string_width(_str) + 6;
                    var _hei = (string_height(_str) + 6) - 2;
                    var _sc = [5, 5, 5 + _wid, 5 + _hei];
                    draw_rectangle(_sc[0], _sc[1], _sc[2], _sc[3], true);
                    draw_text(mean(_sc[0], _sc[2]), mean(_sc[1], _sc[3]) + 1, _str);
                    if (point_in_rectangle(mouse_x, mouse_y, _sc[0], _sc[1], _sc[2], _sc[3]))
                    {
                        crframe = 1;
                        if (mouse_check_button(mb_left))
                        {
                            crframe = 2;
                        }
                        if (get_input_click())
                        {
                            skip = true;
                            _user_set_pause(false);
                        }
                    }
                }
                draw_set_halign(fa_left);
                draw_set_valign(fa_top);
            }
            draw_sprite(spr_cursor, crframe, mouse_x, mouse_y);
        }
    };
    
    _draw_textbox = function(arg0, arg1, arg2)
    {
        var _str = tb_str;
        var _letter = tb_letter;
        draw_textbox(arg0, arg1, _str, arg2, _letter, 1, 1, text_styles);
        if (!tb_auto && _letter >= string_length(_str) && no_text_continue_until_frame == -1)
        {
            draw_sprite(spr_cutscene_textbox_arrow, 0, 477, 267);
        }
    };
    
    _set_volumes = function()
    {
        var _elem = sequence;
        var _seq_instance = layer_sequence_get_instance(_elem);
        if (_seq_instance == -1)
        {
            exit;
        }
        var _tracks = _seq_instance.activeTracks;
        if (array_length(_tracks) != volumes_prev_track_length)
        {
            volumes_prev_track_length = array_length(_tracks);
            volumes_set = false;
        }
        for (var i = 0; i < array_length(_tracks); i++)
        {
            volumes_set = true;
            var _track = _tracks[i];
            switch (_track.track.type)
            {
                case 2:
                    var _name = _track.track.name;
                    var is_music = string_lower(string_copy(_name, 1, 5)) == "music";
                    _track.gain = audio_emitter_get_gain(master.emit_sfx);
                    var newtrack = false;
                    if (is_music)
                    {
                        if (!array_contains(music_tracks, _track))
                        {
                            array_push(music_tracks, _track);
                            newtrack = true;
                        }
                        _track.gain = audio_emitter_get_gain(master.emit_mus);
                    }
                    else if (!array_contains(sfx_tracks, _track))
                    {
                        array_push(sfx_tracks, _track);
                        newtrack = true;
                    }
                    break;
                case 7:
                    array_copy(_tracks, array_length(_tracks), _track.activeTracks, 0, array_length(_track.activeTracks));
                    break;
            }
        }
    };
    
    _play = function()
    {
        if (sequence == -1)
        {
            sequence_layer = layer_create(sequence_layer_depth);
            sequence = layer_sequence_create(sequence_layer, 240, 135, sequence_id);
            if (start_frame > 0)
            {
                layer_sequence_headpos(sequence, start_frame);
            }
            music_tracks = [];
            sfx_tracks = [];
        }
        else
        {
            _resume();
        }
    };
    
    _user_set_pause = function(arg0)
    {
        if (arg0)
        {
            pause_menu.open();
            if (!paused)
            {
                layer_sequence_pause(sequence);
            }
            user_paused = true;
            for (var i = 0; i < array_length(pause_sounds); i++)
            {
                audio_pause_sound(pause_sounds[i]);
            }
        }
        else
        {
            _user_pause_key = 0;
            _user_skip_key = 0;
            _skip_held_time = 0;
            if (!paused)
            {
                layer_sequence_play(sequence);
            }
            user_paused = false;
            for (var i = 0; i < array_length(pause_sounds); i++)
            {
                audio_resume_sound(pause_sounds[i]);
            }
        }
    };
    
    _pause = function()
    {
        layer_sequence_pause(sequence);
        paused = true;
    };
    
    _resume = function()
    {
        if (tb_pause_until_line == -1)
        {
            layer_sequence_play(sequence);
        }
        paused = false;
    };
    
    _get_markers = function()
    {
        var _markers = sequence_get_markers(sequence_id);
        if (array_length(struct_get_names(_markers)) > 0)
        {
            markers = _markers;
        }
    };
    
    clear_loop = function()
    {
        loop_start_frame = -1;
        loop_end_frame = -1;
    };
    
    _perform_script_event = function(arg0)
    {
        if (!tb_auto)
        {
            event_is_dialogue = false;
        }
        var _ev = _events[arg0];
        var do_next_event = true;
        switch (_ev[0])
        {
            case "skip_event":
                break;
            case "dialogue":
                tb_letter = 0;
                tb_pause = 0;
                tb_str = _ev[1];
                inline_events = _ev[2];
                text_styles = _ev[3];
                tb_auto = bool(_ev[4]);
                do_next_event = tb_auto;
                event_is_dialogue = true;
                break;
            case "clear":
                tb_letter = 0;
                tb_pause = 0;
                tb_str = "";
                inline_events = {};
                text_styles = {};
                break;
            case "wait":
                next_event_on_frame = _ev[1];
                do_next_event = false;
                break;
            case "pause":
                pause_on_frame = _ev[1];
                if (pause_on_frame == -1)
                {
                    _pause();
                }
                break;
            case "resume":
                _resume();
                pause_on_frame = -1;
                break;
            case "jump":
                layer_sequence_headpos(sequence, _ev[1]);
                break;
            case "set_loop_start":
                loop_start_frame = _ev[1];
                break;
            case "set_loop_end":
                loop_end_frame = _ev[1];
                break;
            case "clear_loop":
                clear_loop();
                break;
            case "no_text_continue_until":
                no_text_continue_until_frame = _ev[1];
                break;
            case "text_wavy":
                var _amt = _ev[1];
                var _time = _ev[2];
                tb_wavy = _amt;
                tb_wavy_incspd = 1 / _time;
                break;
            case "flag":
                set_story_flag(_ev[1], _ev[2]);
                break;
        }
        if (do_next_event)
        {
            next_event();
        }
    };
    
    next_event = function()
    {
        current_event++;
        if (current_event < array_length(_events))
        {
            _perform_script_event(current_event);
        }
    };
    
    _script_to_events = function()
    {
        _get_markers();
        _events = [];
        text_auto = false;
        loaded_line = "";
        for (var i = 0; i < array_length(_script); i++)
        {
            var __first_args = parse_event_arguments(_script[i], 2);
            if (array_length(__first_args) > 0)
            {
                var first_arg = __first_args[0];
                switch (first_arg)
                {
                    case "lines":
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
                                var _last_sep = max(_last_slash, _last_period);
                                var _without_num = string_copy(loaded_line, 1, _last_sep);
                                var _num = string_copy(loaded_line, _last_sep + 1, string_length(loaded_line) - _last_sep);
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
                            _add_dialogue_line(_dialogue_str);
                        }
                        break;
                    case "clear":
                        array_push(_events, ["clear"]);
                        break;
                    case "text_auto":
                        var _args = parse_event_arguments(_script[i]);
                        text_auto = real(_args[1]);
                        break;
                    case "wait":
                        var _args = parse_event_arguments(_script[i]);
                        if (_args[1] == "for")
                        {
                            switch (_args[2])
                            {
                                case "frame":
                                    array_push(_events, ["wait", real(_args[3])]);
                                    break;
                                case "marker":
                                    var _marker_name = _args[3];
                                    var _marker = struct_get(markers, _marker_name);
                                    if (!is_undefined(_marker))
                                    {
                                        var _marker_frame = _marker.frame;
                                        array_push(_events, ["wait", _marker_frame]);
                                    }
                                    break;
                            }
                        }
                        break;
                    case "pause":
                        var _args = parse_event_arguments(_script[i]);
                        if (array_length(_args) >= 4)
                        {
                            if (_args[1] == "at")
                            {
                                switch (_args[2])
                                {
                                    case "frame":
                                        array_push(_events, ["pause", real(_args[3])]);
                                        break;
                                    case "marker":
                                        var _marker_name = _args[3];
                                        var _marker = struct_get(markers, _marker_name);
                                        if (!is_undefined(_marker))
                                        {
                                            var _marker_frame = _marker.frame;
                                            array_push(_events, ["pause", _marker_frame]);
                                        }
                                        break;
                                }
                            }
                        }
                        else
                        {
                            array_push(_events, ["pause", -1]);
                        }
                        break;
                    case "resume":
                        array_push(_events, ["resume"]);
                        break;
                    case "jump":
                        var _args = parse_event_arguments(_script[i]);
                        if (array_length(_args) >= 4)
                        {
                            if (_args[1] == "to")
                            {
                                switch (_args[2])
                                {
                                    case "frame":
                                        array_push(_events, ["jump", real(_args[3])]);
                                        break;
                                    case "marker":
                                        var _marker_name = _args[3];
                                        var _marker = struct_get(markers, _marker_name);
                                        if (!is_undefined(_marker))
                                        {
                                            var _marker_frame = _marker.frame;
                                            array_push(_events, ["jump", _marker_frame]);
                                        }
                                        break;
                                }
                            }
                        }
                        else
                        {
                            array_push(_events, ["skip_event"]);
                        }
                        break;
                    case "loop":
                        var _args = parse_event_arguments(_script[i]);
                        switch (array_length(_args))
                        {
                            case 4:
                                var evname = "set_loop_" + string(_args[1]);
                                switch (_args[2])
                                {
                                    case "frame":
                                        array_push(_events, [evname, real(_args[3])]);
                                        break;
                                    case "marker":
                                        var _marker_name = _args[3];
                                        var _marker = struct_get(markers, _marker_name);
                                        if (!is_undefined(_marker))
                                        {
                                            var _marker_frame = _marker.frame;
                                            array_push(_events, [evname, _marker_frame]);
                                        }
                                        break;
                                }
                                break;
                            case 2:
                                if (_args[1] == "clear")
                                {
                                    array_push(_events, ["clear_loop"]);
                                }
                                break;
                        }
                        break;
                    case "no_text_continue_until":
                        var _args = parse_event_arguments(_script[i]);
                        if (array_length(_args) >= 3)
                        {
                            switch (_args[1])
                            {
                                case "frame":
                                    array_push(_events, ["no_text_continue_until", real(_args[2])]);
                                    break;
                                case "marker":
                                    var _marker_name = _args[2];
                                    var _marker = struct_get(markers, _marker_name);
                                    if (!is_undefined(_marker))
                                    {
                                        var _marker_frame = _marker.frame;
                                        array_push(_events, ["no_text_continue_until", _marker_frame]);
                                    }
                                    break;
                            }
                        }
                        break;
                    case "text_wavy":
                        var _args = parse_event_arguments(_script[i]);
                        if (array_length(_args) >= 3)
                        {
                            var _amt = real(_args[1]);
                            var _time = real(_args[2]);
                            array_push(_events, ["text_wavy", _amt, _time]);
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
                    default:
                        _add_dialogue_line(_script[i]);
                        break;
                }
            }
            else
            {
                array_push(_events, ["skip_event"]);
            }
        }
    };
    
    parse_event_arguments = function(arg0, arg1 = infinity)
    {
        var _args_array = [];
        var _str = arg0;
        if (string_copy(_str, 1, 2) == "//")
        {
            return _args_array;
        }
        while (string_length(_str) > 0 && array_length(_args_array) < arg1)
        {
            var word_end = string_pos(" ", _str) - 1;
            if (word_end <= 0)
            {
                word_end = string_length(_str);
            }
            var _this_arg = string_copy(_str, 1, word_end);
            if (_this_arg != "")
            {
                array_push(_args_array, _this_arg);
            }
            _str = string_delete(_str, 1, string_length(_this_arg));
            while (string_char_at(_str, 1) == " ")
            {
                _str = string_delete(_str, 1, 1);
            }
        }
        return _args_array;
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
        array_push(_events, ["dialogue", arg0, _inline_events, _text_styles, text_auto]);
    };
    
    localize_text_tracks = function()
    {
        var _struct = sequence_get(sequence_id);
        for (var i = 0; i < array_length(_struct.tracks); i++)
        {
            var _track = _struct.tracks[i];
            var _name = _track.name;
            var _type = _track.type;
            if (_type == 17 && string_pos("strloc_", _name) == 1)
            {
                var _keyname = string_replace(_name, "strloc_", "");
                for (var j = 0; j < array_length(_track.keyframes); j++)
                {
                    var _keyframe = _track.keyframes[j];
                    _keyframe.channels[0].text = strloc(_keyname);
                }
            }
        }
    };
}

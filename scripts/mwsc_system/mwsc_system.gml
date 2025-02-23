function mwsc_instance() constructor
{
    type = 0;
    parent = -1;
    script = [];
    events = [];
    markers = {};
    current_event = 0;
    current_letter = 0;
    text = "";
    text_styles = {};
    text_pause = 0;
    base_text_speed = 0.6;
    text_speed = 1;
    ffwd_speed = 0;
    event_pause = 0;
    loaded_line = "";
    continue_cooldown_max = 15;
    continue_cooldown = continue_cooldown_max;
    input_cooldown_max = 3;
    input_cooldown = input_cooldown_max;
    allow_player_input = true;
    allow_text_continue = true;
    allow_ffwd = true;
    skip_line = false;
    text_finish_sound = -1;
    
    on_end = function()
    {
    };
    
    after_script_load = function()
    {
    };
    
    speaker = "";
    text_voice = new charvoice_none();
    log_list = [];
    options = [];
    show_options = false;
    options_setup = [];
    options_add_mode = false;
    custom_parse_funcs = {};
    
    add_custom_parse_func = function(arg0, arg1)
    {
        struct_set(custom_parse_funcs, arg0, arg1);
    };
    
    custom_script_event_funcs = {};
    
    add_custom_script_event_func = function(arg0, arg1)
    {
        struct_set(custom_script_event_funcs, arg0, arg1);
    };
    
    script_event = 
    {
        do_next_event: true,
        flags_were_changed: false
    };
    textbox = new textbox_constructor();
    
    set_text = function(arg0)
    {
        var _ret = textbox.set_text(arg0);
        text = textbox.text;
        text_styles = textbox.text_styles;
        inline_events = textbox.inline_events;
        return _ret;
    };
    
    draw = function(arg0, arg1)
    {
        textbox.letter = current_letter;
        textbox.draw(arg0, arg1);
    };
    
    tick = function()
    {
        var continue_btn = mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_space);
        var ffwd_btn = keyboard_check(vk_shift) && allow_player_input && allow_ffwd;
        if (continue_btn)
        {
            input_cooldown = min(input_cooldown, 1);
        }
        if (!master.game_focused)
        {
            input_cooldown = input_cooldown_max;
        }
        continue_btn = continue_btn && allow_player_input && input_cooldown <= 0;
        var text_scroll_paused = event_pause || text_pause;
        if (show_options)
        {
        }
        else if (skip_line)
        {
            skip_line = false;
            next_event();
        }
        else if (current_letter < string_length(text))
        {
            var cancel_pause = false;
            var _prev_letter = current_letter;
            if (continue_btn)
            {
                current_letter = string_length(text) + 1;
                cancel_pause = true;
                text_scroll_paused = false;
            }
            if (!text_scroll_paused)
            {
                var _spd = text_speed * base_text_speed;
                if (ffwd_btn)
                {
                    _spd *= 5;
                    cancel_pause = true;
                }
                current_letter += _spd;
                current_letter = clamp(current_letter, 0, string_length(text) + 1);
                var i = floor(_prev_letter);
                while (i < floor(current_letter))
                {
                    var _letter_inline_events = struct_get(inline_events, i);
                    for (var j = 0; j < array_length(_letter_inline_events); j++)
                    {
                        perform_inline_event(_letter_inline_events[j], i);
                    }
                    i++;
                }
                if (floor(_prev_letter) < floor(current_letter) && text_voice != -1)
                {
                    switch (string_char_at(text, floor(current_letter)))
                    {
                        case " ":
                        case "!":
                        case "?":
                        case ".":
                        case ",":
                        case ":":
                            break;
                        default:
                            text_voice._play();
                            break;
                    }
                }
                if (cancel_pause)
                {
                    text_pause = 0;
                }
            }
        }
        else
        {
            if ((continue_btn && allow_text_continue) || ffwd_btn)
            {
                if (continue_cooldown > 0)
                {
                    continue_cooldown = 0;
                }
                else
                {
                    if (!ffwd_btn && text_finish_sound != -1)
                    {
                        sfx_play(text_finish_sound);
                    }
                    next_event();
                }
            }
            continue_cooldown += sign(0 - continue_cooldown);
        }
        input_cooldown += sign(0 - input_cooldown);
        text_pause += sign(0 - text_pause);
        if (event_pause > 0)
        {
            event_pause += sign(0 - event_pause);
            if (event_pause <= 0)
            {
                next_event();
            }
        }
    };
    
    next_event = function()
    {
        var _evcount = array_length(events);
        if (current_event < _evcount)
        {
            current_event++;
            if (current_event < _evcount)
            {
                perform_current_event();
            }
            else
            {
                on_end();
            }
        }
    };
    
    perform_current_event = function()
    {
        perform_script_event(current_event);
    };
    
    perform_script_event = function(arg0)
    {
        if (arg0 >= array_length(events))
        {
            exit;
        }
        var _ev = events[arg0];
        script_event.do_next_event = true;
        if (struct_exists(custom_script_event_funcs, _ev[0]))
        {
            var _custom_func = struct_get(custom_script_event_funcs, _ev[0]);
            var _args = 
            {
                args: _ev,
                mwsc_inst: self,
                event_num: arg0
            };
            if (is_method(_custom_func))
            {
                var _ret = method_call(_custom_func, [_args]);
            }
            else
            {
                script_execute(_custom_func, _args);
            }
        }
        else
        {
            switch (_ev[0])
            {
                case "skip_event":
                    break;
                case "text":
                    set_text(_ev[1]);
                    text_styles = textbox.text_styles;
                    inline_events = textbox.inline_events;
                    current_letter = 0;
                    text_pause = 0;
                    text_speed = 1;
                    script_event.do_next_event = false;
                    continue_cooldown = continue_cooldown_max;
                    if (type == 1)
                    {
                        var _list = log_list;
                        if (instance_exists(obj_lobby_controller))
                        {
                            _list = obj_lobby_controller.dialogue_log;
                        }
                        var speaker_index;
                        with (parent)
                        {
                            speaker_index = struct_get(char_id_to_index, speaker);
                        }
                        var speaker_struct = -1;
                        if (speaker_index != -1 && !is_undefined(speaker_index))
                        {
                            speaker_struct = parent.characters[speaker_index];
                        }
                        log_dialogue_line(_list, _ev[1], speaker_struct);
                    }
                    if (type == 2)
                    {
                        if (parent.tb_auto)
                        {
                            script_event.do_next_event = true;
                        }
                    }
                    break;
                case "goto_marker":
                    var marker_evnum = struct_get(markers, _ev[1]);
                    if (!is_undefined(marker_evnum))
                    {
                        current_event = marker_evnum;
                        perform_current_event();
                        script_event.do_next_event = false;
                    }
                    break;
                case "goto_script":
                    load_script_file("scripts/" + _ev[1] + ".mwsc");
                    current_event = 0;
                    perform_current_event();
                    script_event.do_next_event = false;
                    break;
                case "flag":
                    set_story_flag(_ev[1], _ev[2]);
                    script_event.flags_were_changed = true;
                    break;
                case "increment_flag":
                    var _flag_value = get_story_flag(_ev[1], 0);
                    if (is_real(_flag_value))
                    {
                        set_story_flag(_ev[1], _flag_value + _ev[2]);
                        script_event.flags_were_changed = true;
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
                case "pause":
                    event_pause = real(_ev[1]);
                    script_event.do_next_event = false;
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
                case "allow_player_input":
                    allow_player_input = bool(_ev[1]);
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
                    set_text("");
                    current_letter = 0;
                    text_pause = 0;
                    continue_cooldown = continue_cooldown_max;
                    script_event.do_next_event = false;
                    break;
            }
        }
        if (script_event.do_next_event)
        {
            next_event();
        }
    };
    
    perform_inline_event = function(arg0, arg1 = 1)
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
                current_letter = arg1;
                break;
        }
    };
    
    script_to_events = function()
    {
        events = [];
        markers = {};
        loaded_line = "";
        options_add_mode = false;
        current_event = 0;
        for (var i = 0; i < array_length(script); i++)
        {
            var __first_args = parse_event_arguments(script[i], 2);
            var __skip = false;
            if (string_copy(script[i], 1, 2) == "//")
            {
                __skip = true;
            }
            if (array_length(__first_args) > 0 && !__skip)
            {
                var first_arg = __first_args[0];
                if (struct_exists(custom_parse_funcs, first_arg))
                {
                    var _custom_func = struct_get(custom_parse_funcs, first_arg);
                    var _args = parse_event_arguments(script[i]);
                    _args = 
                    {
                        args: _args,
                        mwsc_inst: self,
                        script_line: i
                    };
                    if (is_method(_custom_func))
                    {
                        method_call(_custom_func, [_args]);
                    }
                    else
                    {
                        script_execute(_custom_func, _args);
                    }
                }
                else
                {
                    switch (first_arg)
                    {
                        case "line":
                            var _args = parse_event_arguments(script[i]);
                            if (array_length(_args) == 1)
                            {
                                if (loaded_line == "")
                                {
                                    array_push(events, ["skip_event"]);
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
                                        var _text_str = strloc(loaded_line);
                                        _add_text_line(_text_str);
                                    }
                                    else
                                    {
                                        array_push(events, ["skip_event"]);
                                    }
                                }
                            }
                            else
                            {
                                loaded_line = _args[1];
                                var _text_str = strloc(loaded_line);
                                if (_text_str == "")
                                {
                                    _text_str = loaded_line;
                                    loaded_line = "";
                                }
                                _add_text_line(_text_str);
                            }
                            break;
                        case "marker":
                            var _args = parse_event_arguments(script[i]);
                            struct_set(markers, _args[1], array_length(events));
                            array_push(events, ["skip_event"]);
                            break;
                        case "goto":
                            var _args = parse_event_arguments(script[i]);
                            switch (_args[1])
                            {
                                case "script":
                                    array_push(events, ["goto_script", _args[2]]);
                                    break;
                                case "marker":
                                    array_push(events, ["goto_marker", _args[2]]);
                                    break;
                            }
                            break;
                        case "setflag":
                        case "flag":
                            var _args = parse_event_arguments(script[i]);
                            var flagname = _args[1];
                            var flagvalue = _args[2];
                            try
                            {
                                flagvalue = real(flagvalue);
                            }
                            catch (_exception)
                            {
                            }
                            array_push(events, ["flag", flagname, flagvalue]);
                            break;
                        case "incflag":
                        case "incrementflag":
                        case "inc_flag":
                        case "increment_flag":
                            var _args = parse_event_arguments(script[i]);
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
                                array_push(events, ["increment_flag", flagname, flaginc]);
                            }
                            break;
                        case "checkflag":
                            var _args = parse_event_arguments(script[i]);
                            var _flagname = _args[1];
                            var _value = _args[2];
                            array_push(events, ["checkflag", _flagname, _value]);
                            break;
                        case "func":
                        case "function":
                            var _args = parse_event_arguments(script[i]);
                            var _func_args = [];
                            if (array_length(_args) > 2)
                            {
                                array_copy(_func_args, 0, _args, 2, array_length(_args) - 2);
                            }
                            array_push(events, ["function", _args[1], _func_args]);
                            break;
                        case "allow_player_input":
                            var _args = parse_event_arguments(script[i]);
                            array_push(events, ["allow_player_input", _args[1]]);
                            break;
                        case "options":
                        case "option":
                            var _args = parse_event_arguments(script[i]);
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
                                    array_push(events, ["clear_options"]);
                                    skipthis = false;
                                    break;
                                case "shuffle":
                                    array_shuffle_ext(options_setup);
                                    array_push(events, ["shuffle_options"]);
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
                                    var _new_option = ["", 0, -1, -1];
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
                                            case "color":
                                                var __col = color_name_to_color(_value);
                                                _new_option[3] = __col;
                                                break;
                                        }
                                    }
                                    array_push(events, ["add_option", _new_option]);
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
                                array_push(events, ["skip_event"]);
                            }
                            break;
                        default:
                            var _custom_func = struct_get(custom_parse_funcs, "default");
                            if (is_undefined(_custom_func))
                            {
                                _add_text_line(script[i]);
                            }
                            else
                            {
                                var _args = parse_event_arguments(script[i]);
                                _args = 
                                {
                                    args: _args,
                                    mwsc_inst: self,
                                    script_line: i
                                };
                                if (is_method(_custom_func))
                                {
                                    method_call(_custom_func, [_args]);
                                }
                                else
                                {
                                    script_execute(_custom_func, _args);
                                }
                            }
                            break;
                    }
                }
            }
        }
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
    
    _add_text_line = function(arg0, arg1 = "")
    {
        array_push(events, ["text", arg0, arg1]);
    };
    
    load_script_file = function(arg0)
    {
        script = [];
        var file_str = file_text_to_string(arg0);
        var line_start = 1;
        while (line_start <= string_length(file_str))
        {
            while ((string_char_at(file_str, line_start) == "\n" || string_char_at(file_str, line_start) == "\r") && !(string_char_at(file_str, line_start) == "\n" && string_char_at(file_str, line_start + 1) == "\n"))
            {
                line_start++;
            }
            var line_end = min(string_pos_ext("\n", file_str, line_start), string_pos_ext("\r", file_str, line_start));
            if (line_end <= 0)
            {
                line_end = string_length(file_str) + 1;
            }
            var line_str = string_copy(file_str, line_start, line_end - line_start);
            line_start = line_end + 1;
            var _str = line_str;
            _str = string_replace_all(_str, "\\n", "\n");
            _str = string_replace_all(_str, "\r", "");
            array_push(script, _str);
        }
        script_to_events();
        after_script_load();
        return script;
    };
    
    _add_dialogue_options = function(arg0, arg1)
    {
        if (options_add_mode)
        {
            arg0 = 0;
        }
        events[arg1] = ["options", arg0];
    };
    
    select_option = function(arg0)
    {
        var _thisop = options[arg0];
        switch (_thisop[1])
        {
            case 0:
                var marker_evnum = struct_get(markers, _thisop[2]);
                if (!is_undefined(marker_evnum))
                {
                    current_event = marker_evnum + 1;
                    perform_current_event();
                    script_event.do_next_event = false;
                }
                break;
            case 1:
                load_script_file("scripts/" + _thisop[2] + ".mwsc");
                current_event = 0;
                perform_current_event();
                break;
        }
        show_options = false;
        options = [];
    };
}

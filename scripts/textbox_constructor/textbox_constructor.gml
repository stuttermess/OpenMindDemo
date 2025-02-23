function textbox_constructor() constructor
{
    loc_path = "";
    base_text = "";
    text = "";
    letter = infinity;
    text_styles = {};
    inline_events = {};
    batches = [];
    lines = [];
    line_starts = [0];
    line_widths = [];
    width = 200;
    halign = 1;
    valign = 1;
    origin_matches_align = true;
    origin = [halign, valign];
    use_auto_break = true;
    text_space_width = 0;
    text_space_height = 0;
    font = fnt_dialogue;
    color = 16777215;
    style_default = 
    {
        color: color,
        font: font
    };
    longest_line_w = 0;
    
    draw = function(arg0, arg1)
    {
        var _line_width = 0;
        var _line_amt = array_length(lines);
        var _drawx = arg0;
        var _drawy = arg1;
        var _startcol = draw_get_color();
        var _startfnt = draw_get_font();
        var _start_halign = draw_get_halign();
        var _start_valign = draw_get_valign();
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_font(style_default.font);
        draw_set_color(style_default.color);
        var _line_height = 12;
        switch (valign)
        {
            case 1:
                _drawy -= ((((_line_amt - 1) / 2) + 0.5) * _line_height);
                break;
            case 2:
                _drawy -= (((_line_amt - 1) + 1) * _line_height);
                break;
        }
        for (var i = 0; i < array_length(batches); i++)
        {
            var _batch = batches[i];
            if (is_array(_batch))
            {
                _line_width = _batch[0];
                _drawx = arg0;
                switch (halign)
                {
                    case 1:
                        _drawx -= (_line_width / 2);
                        break;
                    case 2:
                        _drawx -= _line_width;
                        break;
                }
                if (i > 0)
                {
                    _drawy += _line_height;
                }
            }
            else
            {
                var _text = _batch.text;
                var _style = _batch.style;
                var _start_letter = _batch.start_letter;
                if (letter >= _start_letter)
                {
                    if (letter < string_length(text))
                    {
                        _text = string_copy(_text, 1, letter - _start_letter);
                    }
                    draw_set_font(_style.font);
                    draw_set_color(_style.color);
                    draw_text(floor(_drawx), floor(_drawy), _text);
                    _drawx += string_width(_text);
                }
            }
        }
        draw_set_halign(_start_halign);
        draw_set_valign(_start_valign);
        draw_set_color(_startcol);
        draw_set_font(_startfnt);
    };
    
    __draw = function(arg0, arg1)
    {
        var col = draw_get_color();
        var fnt = draw_get_font();
        
        var set_default_styles = function(arg0)
        {
            arg0.color = color;
            arg0.font = font;
        };
        
        draw_set_color(color);
        draw_set_font(font);
        var style = 
        {
            color: color,
            font: font
        };
        var letter_styles = [];
        var _start_valign = draw_get_valign();
        var _start_halign = draw_get_halign();
        var _valign = valign;
        var _halign = halign;
        if (!origin_matches_align)
        {
            _valign = origin[1];
            _halign = origin[0];
        }
        var style_is_default = true;
        draw_set_valign(fa_middle);
        var xscale = 1;
        var line_seperation = 12;
        for (var i = 0; i < array_length(lines); i++)
        {
            var _line = lines[i];
            var _line_start = line_starts[i];
            var _line_width = line_widths[i];
            if (letter >= _line_start)
            {
                var _lx;
                switch (_halign)
                {
                    case 0:
                        _lx = arg0;
                        break;
                    case 1:
                        _lx = arg0 - ((_line_width / 2) * abs(xscale));
                        break;
                    case 2:
                        _lx = arg0 - _line_width;
                        break;
                }
                var _ly;
                switch (_valign)
                {
                    case 0:
                        _ly = arg1 + (i * line_seperation) + (string_height(_line) / 2);
                        break;
                    case 1:
                        _ly = arg1 + ((i - ((min(array_length(lines), infinity) / 2) - 0.5)) * line_seperation);
                        break;
                    case 2:
                        _ly = arg1 - (line_seperation * array_length(lines)) - (string_height(_line) / 2);
                        break;
                }
                var _line_letter = min(letter, string_length(text)) - _line_start;
                var _ltx = floor(_lx);
                var _lty = floor(_ly);
                for (var j = 1; j <= _line_letter; j++)
                {
                    var _overall_letter = (_line_start + j) - 1;
                    if (struct_exists(text_styles, _overall_letter))
                    {
                        var _styles = struct_get(text_styles, _overall_letter);
                        for (var k = 0; k < array_length(_styles); k++)
                        {
                            var _key = _styles[k][1];
                            var _first_arg_ind = 2;
                            for (var tries = 0; tries < 1; tries++)
                            {
                                switch (_key)
                                {
                                    case "color":
                                        style.color = color_name_to_color(_styles[k][_first_arg_ind]);
                                        style_is_default = false;
                                        break;
                                    case "font":
                                        switch (_styles[k][_first_arg_ind])
                                        {
                                            case "0":
                                                style.font = fnt_dialogue;
                                                break;
                                            case "1":
                                                style.font = fnt_pixel;
                                                break;
                                            default:
                                                var _ind = asset_get_index(_styles[k][_first_arg_ind]);
                                                if (font_exists(_ind))
                                                {
                                                    style.font = _ind;
                                                }
                                                break;
                                        }
                                        style_is_default = false;
                                        break;
                                    case "reset":
                                        set_default_styles(style);
                                        style_is_default = true;
                                        break;
                                    default:
                                        break;
                                }
                            }
                        }
                    }
                    draw_set_color(style.color);
                    draw_set_font(style.font);
                    var _chr = string_char_at(_line, j);
                    draw_text(_ltx, _lty, _chr);
                    _ltx += floor(string_width(_chr));
                }
            }
        }
        draw_set_color(col);
        draw_set_font(fnt);
        draw_set_valign(_start_valign);
        draw_set_halign(_start_halign);
    };
    
    set_text = function(arg0)
    {
        style_default = 
        {
            color: color,
            font: font
        };
        base_text = arg0;
        get_styles_and_events();
        get_lines();
        get_batches();
    };
    
    set_text_loc = function(arg0)
    {
        loc_path = arg0;
        set_text(strloc(loc_path));
    };
    
    refresh = function()
    {
        set_text(base_text);
    };
    
    get_styles_and_events = function()
    {
        text_styles = {};
        inline_events = {};
        text = "";
        text = base_text;
        if (string_pos("|", base_text) <= 0)
        {
            exit;
        }
        var _str = base_text;
        var _inline_events = {};
        var _text_styles = {};
        for (var _letter = 1; _letter < string_length(_str); _letter++)
        {
            var first_marker = string_pos_ext("|", _str, _letter);
            var event_letter = first_marker - 1;
            if (first_marker == 0)
            {
                _letter = string_length(_str);
            }
            else
            {
                var next_marker = string_pos_ext("|", _str, first_marker + 1);
                if (next_marker != 0 && next_marker != first_marker)
                {
                    var _args_str = string_copy(_str, first_marker + 1, next_marker - first_marker - 1);
                    var _args = parse_event_arguments(_args_str);
                    if (array_length(_args) > 0)
                    {
                        if (struct_exists(_inline_events, event_letter))
                        {
                            var _arr = struct_get(_inline_events, event_letter);
                            _arr[array_length(_arr)] = _args;
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
                                    _arr[array_length(_arr)] = _args;
                                }
                                else
                                {
                                    struct_set(_text_styles, event_letter, [_args]);
                                }
                                break;
                        }
                    }
                    _str = string_delete(_str, first_marker, (next_marker - first_marker) + 1);
                    _letter--;
                }
            }
        }
        text = _str;
        inline_events = _inline_events;
        text_styles = _text_styles;
    };
    
    get_lines = function()
    {
        lines = [];
        var fnt = draw_get_font();
        var _str = text;
        var _font = font;
        var _current_line_num = 0;
        var _current_line_str = "";
        var _current_line_width = 0;
        line_starts = [0];
        line_widths = [];
        var max_line_w = width;
        longest_line_w = 0;
        text_space_width = 0;
        text_space_height = 0;
        _str = string_replace_all(_str, "\\n", "\n");
        for (var i = 1; i <= string_length(_str); i++)
        {
            if (struct_exists(text_styles, i - 1))
            {
                var _letter_styles = struct_get(text_styles, i - 1);
                for (var j = 0; j < array_length(_letter_styles); j++)
                {
                    var _letter_style = _letter_styles[j];
                    if (_letter_style[0] == "style")
                    {
                        if (_letter_style[1] == "font")
                        {
                            _font = asset_get_index(_letter_style[2]);
                            draw_set_font(_font);
                        }
                    }
                }
            }
            var _char = string_char_at(_str, i);
            var _char_width = string_width(_char);
            var _word_width = 0;
            if (_char == " " && _current_line_width > (max_line_w * 0.45))
            {
                var nextspace = string_pos_ext(" ", _str, i + 1);
                if (nextspace <= 0)
                {
                    nextspace = string_length(_str);
                }
                var next_word = string_copy(_str, i + 1, nextspace - (i + 1));
                _word_width = string_width(next_word);
            }
            if (i == string_length(_str))
            {
                _current_line_str += _char;
                lines[_current_line_num] = _current_line_str;
                line_widths[_current_line_num] = _current_line_width;
                text_space_height += string_height(_current_line_str);
            }
            else if (((_current_line_width + _char_width + _word_width) > max_line_w && use_auto_break) || _char == "\n")
            {
                lines[_current_line_num] = _current_line_str;
                line_widths[_current_line_num] = _current_line_width;
                text_space_height += string_height(_current_line_str);
                _current_line_num++;
                line_starts[_current_line_num] = i;
                if (_char == " " || _char == "\n")
                {
                    _char = "";
                }
                _current_line_str = _char;
                _current_line_width = string_width(_current_line_str);
            }
            else
            {
                _current_line_width += _char_width;
                _current_line_str += _char;
            }
            longest_line_w = max(longest_line_w, _current_line_width);
        }
        text_space_width = longest_line_w;
        draw_set_font(fnt);
    };
    
    get_batches = function()
    {
        batches = [];
        var _current_batch = 
        {
            style: {},
            text: ""
        };
        for (var i = 0; i < array_length(lines); i++)
        {
            var _line_start = line_starts[i];
            var _line = lines[i];
            var _line_width = line_widths[i];
            var _line_length = string_length(_line);
            var _line_start_style = get_style_at_letter(_line_start);
            array_push(batches, [_line_width]);
            _current_batch.style = _line_start_style;
            var _batch_start_letter = _line_start;
            while ((_batch_start_letter - _line_start) < _line_length)
            {
                var _batch_end_letter = _line_start + _line_length;
                var j = _batch_start_letter + 1;
                while (j <= (_line_length + _line_start) && _batch_end_letter == (_line_start + _line_length))
                {
                    if (struct_exists(text_styles, j))
                    {
                        _batch_end_letter = j;
                    }
                    j++;
                }
                _current_batch.text = string_copy(_line, (_batch_start_letter - _line_start) + 1, _batch_end_letter - _line_start);
                _current_batch.text = string_trim(_current_batch.text, ["\r", "\n"]);
                var __style = _current_batch.style;
                if (is_array(__style))
                {
                    var _styles_array = __style;
                    __style = 
                    {
                        color: color,
                        font: font
                    };
                    for (j = 0; j < array_length(_styles_array); j++)
                    {
                        var _thisstyleset = _styles_array[j];
                        switch (_thisstyleset[1])
                        {
                            case "color":
                                __style.color = color_name_to_color(_thisstyleset[2]);
                                break;
                            case "font":
                                var _val = _thisstyleset[2];
                                switch (_val)
                                {
                                    case "0":
                                        __style.font = fnt_dialogue;
                                        break;
                                    case "1":
                                        __style.font = fnt_pixel;
                                        break;
                                    default:
                                        var _ind = asset_get_index(_val);
                                        if (font_exists(_ind))
                                        {
                                            __style.font = _ind;
                                        }
                                        break;
                                }
                                break;
                        }
                    }
                }
                array_push(batches, 
                {
                    style: __style,
                    text: _current_batch.text,
                    start_letter: _batch_start_letter
                });
                _current_batch = 
                {
                    style: {},
                    text: ""
                };
                _current_batch.style = struct_get(text_styles, _batch_end_letter);
                _batch_start_letter = _batch_end_letter;
            }
        }
    };
    
    get_style_at_letter = function(arg0)
    {
        var _style_letter = get_style_letter_at_letter(arg0);
        var _style = struct_get(text_styles, _style_letter);
        if (is_undefined(_style))
        {
            _style = style_default;
        }
        return _style;
    };
    
    get_style_letter_at_letter = function(arg0)
    {
        var _styles_names = struct_get_names(text_styles);
        var _highest_style_letter = -1;
        for (var i = 0; i < array_length(_styles_names); i++)
        {
            var _style_letter = real(_styles_names[i]);
            if (_style_letter <= arg0)
            {
                _highest_style_letter = max(_highest_style_letter, _style_letter);
            }
        }
        return _highest_style_letter;
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
                _args_array[array_length(_args_array)] = _this_arg;
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
}

function draw_textbox(arg0, arg1, arg2 = "", arg3, arg4 = infinity, arg5 = 0, arg6 = 1, arg7 = {}, arg8 = true)
{
    arg0 = round(arg0);
    arg1 = round(arg1);
    if (arg4 == infinity)
    {
        arg4 = string_length(arg2);
    }
    arg4 = min(arg4, string_length(arg2) + 5);
    var _prev_fnt = draw_get_font();
    draw_set_font(fnt_dialogue);
    var lines = [];
    var line_starts = [0];
    var line_widths = [];
    var max_line_w = arg3;
    var longest_line_w = 0;
    var _current_line_num = 0;
    var _current_line_str = "";
    var _current_line_width = 0;
    var _start_font = draw_get_font();
    var _font = _start_font;
    if (arg8)
    {
        for (var i = 1; i <= string_length(arg2); i++)
        {
            if (struct_exists(arg7, i - 1))
            {
                var _letter_styles = struct_get(arg7, i - 1);
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
            var _char = string_char_at(arg2, i);
            var _char_width = string_width(_char);
            var _word_width = 0;
            if (_char == " " && _current_line_width > (max_line_w * 0.45))
            {
                var nextspace = string_pos_ext(" ", arg2, i + 1);
                if (nextspace <= 0)
                {
                    nextspace = string_length(arg2);
                }
                var next_word = string_copy(arg2, i + 1, nextspace - (i + 1));
                _word_width = string_width(next_word);
            }
            if (i == string_length(arg2))
            {
                _current_line_str += _char;
                lines[_current_line_num] = _current_line_str;
                line_widths[_current_line_num] = _current_line_width;
            }
            else if ((_current_line_width + _char_width + _word_width) > max_line_w || _char == "\n")
            {
                lines[_current_line_num] = _current_line_str;
                line_widths[_current_line_num] = _current_line_width;
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
    }
    else
    {
        var _nextnewline = 1;
        var _end = false;
        while (!_end)
        {
            var _prev_nextnewline = _nextnewline;
            _nextnewline = string_pos_ext("\n", arg2, _nextnewline + 1);
            if (_nextnewline == 0)
            {
                _nextnewline = string_length(arg2) + 2;
                _end = true;
            }
            var _thisline = string_copy(arg2, _prev_nextnewline, _nextnewline - _prev_nextnewline - 1);
            array_push(lines, _thisline);
            array_push(line_starts, _prev_nextnewline);
            array_push(line_widths, string_width(_thisline));
        }
    }
    draw_set_font(_start_font);
    var col = draw_get_color();
    var fnt = _start_font;
    var style_defaults = 
    {
        color: col,
        font: fnt
    };
    var style = struct_copy(style_defaults);
    var letter_styles = [];
    draw_set_valign(fa_middle);
    var xscale = 1;
    var line_seperation = 12;
    for (var i = 0; i < array_length(lines); i++)
    {
        var _line = lines[i];
        var _line_start = line_starts[i];
        var _line_width = line_widths[i];
        var _lx;
        switch (arg5)
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
        switch (arg6)
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
        var _line_letter = arg4 - _line_start;
        if (arg4 >= _line_start)
        {
            var _ltx = floor(_lx);
            var _lty = floor(_ly);
            for (var j = 1; j <= _line_letter; j++)
            {
                var _overall_letter = (_line_start + j) - 1;
                if (struct_exists(arg7, _overall_letter))
                {
                    var _styles = struct_get(arg7, _overall_letter);
                    for (var k = 0; k < array_length(_styles); k++)
                    {
                        switch (_styles[k][1])
                        {
                            case "color":
                                switch (_styles[k][2])
                                {
                                    case "white":
                                        style.color = 16777215;
                                        break;
                                    case "black":
                                        style.color = 0;
                                        break;
                                    case "gray":
                                    case "grey":
                                        style.color = 12632256;
                                        break;
                                    case "red":
                                        style.color = 255;
                                        break;
                                    case "blue":
                                        style.color = 16711680;
                                        break;
                                    case "yellow":
                                        style.color = 65535;
                                        break;
                                    case "green":
                                        style.color = 32768;
                                        break;
                                    case "aqua":
                                        style.color = 16776960;
                                        break;
                                    case "lime":
                                        style.color = 65280;
                                        break;
                                    case "purple":
                                        style.color = 16711935;
                                        break;
                                    default:
                                        break;
                                }
                                break;
                            case "font":
                                switch (_styles[k][2])
                                {
                                    case "0":
                                        style.font = fnt_dialogue;
                                        break;
                                    case "1":
                                        style.font = fnt_pixel;
                                        break;
                                    default:
                                        var _ind = asset_get_index(_styles[k][2]);
                                        if (font_exists(_ind))
                                        {
                                            style.font = _ind;
                                        }
                                        break;
                                }
                                break;
                            case "reset":
                                style = struct_copy(style_defaults);
                                break;
                        }
                    }
                }
                while (array_length(letter_styles) < (_overall_letter + 1))
                {
                    array_push(letter_styles, struct_copy(style));
                }
                var _letter_style = letter_styles[_overall_letter];
                draw_set_color(_letter_style.color);
                draw_set_font(style.font);
                var _chr = string_char_at(_line, j);
                draw_text(_ltx, _lty, _chr);
                _ltx += floor(string_width(_chr));
            }
        }
    }
    draw_set_color(col);
    draw_set_font(fnt);
    draw_set_valign(fa_top);
    draw_set_font(_prev_fnt);
    return 
    {
        width: longest_line_w
    };
}

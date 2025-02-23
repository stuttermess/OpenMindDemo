function load_dialogue_script(arg0)
{
    var _script = [];
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
        array_push(_script, _str);
    }
    return _script;
}

function dialogue_doc2scripts(arg0)
{
    var _replacements = ["‘", "'", "’", "'", "…", "...", "“", "\\\"", "”", "\\\"", "\"", "\\\"", "—", "-"];
    var _script_with_str = "";
    var _script_without_str = "";
    var _dialogue_array_str = "[\n";
    var _str = arg0;
    var pos = 1;
    var line_end = string_pos_ext("\n", _str, pos);
    var line = string_copy(_str, pos, line_end - pos);
    var current_speaker = "";
    var dialogue_lines = 0;
    var specify_line_path = true;
    while (pos <= string_length(_str))
    {
        if (string_char_at(_str, pos + 1) == ":")
        {
            var _include_comment_line = specify_line_path;
            var _speaker = string_lower(string_char_at(_str, pos));
            if (_speaker != current_speaker)
            {
                _script_with_str += (_speaker + "\n");
                _script_without_str += (_speaker + "\n");
                current_speaker = _speaker;
                _include_comment_line = true;
            }
            var _this_line_end = line_end;
            _this_line_end = string_last_pos_ext("\n", _str, line_end) - 1;
            if (_this_line_end < pos)
            {
                _this_line_end = string_length(_str);
            }
            var linestart = 3;
            var _line_dialogue = string_copy(_str, pos + linestart, _this_line_end - pos - linestart);
            for (var i = 0; i < array_length(_replacements); i += 2)
            {
                _line_dialogue = string_replace_all(_line_dialogue, _replacements[i], _replacements[i + 1]);
            }
            _script_with_str += ("line \"" + _line_dialogue + "\"\n");
            _script_without_str += "line";
            if (specify_line_path)
            {
                specify_line_path = false;
                _script_without_str += (" localization_path." + string(dialogue_lines) + "\n");
            }
            else
            {
                _script_without_str += "\n";
            }
            if (_include_comment_line)
            {
                _script_without_str += ("//^^ " + _line_dialogue + "\n");
            }
            _dialogue_array_str += ("\t\"" + _line_dialogue + "\",\n");
            dialogue_lines++;
        }
        else
        {
            _script_with_str += line;
            _script_without_str += line;
            specify_line_path = true;
        }
        pos = line_end + 1;
        line_end = string_pos_ext("\n", _str, pos);
        if (line_end == 0)
        {
            line_end = string_length(_str);
        }
        line = string_copy(_str, pos, line_end - pos);
    }
    _dialogue_array_str = string_delete(_dialogue_array_str, string_last_pos(",", _dialogue_array_str), 1);
    _dialogue_array_str += "]";
    var _output = [_script_with_str, _script_without_str, _dialogue_array_str];
    return _output;
}

function directory_dialogue_doc2scripts(arg0)
{
    var out_directory = arg0 + "/_out/";
    if (!directory_exists(arg0))
    {
        exit;
    }
    var _directories = [""];
    for (var i = 0; i < array_length(_directories); i++)
    {
        var _thisdir = arg0 + "/" + _directories[i];
        var _thisoutdir = out_directory + _directories[i];
        var _file = file_find_first(_thisdir + "/*.txt", 0);
        while (_file != "")
        {
            var _buf = buffer_load(_thisdir + "/" + _file);
            var _str = buffer_read(_buf, buffer_text);
            buffer_delete(_buf);
            var _filename = string_replace(_file, ".txt", "");
            var _outpath = _thisoutdir + "/";
            var _paths = ["with_dialogue/*.mwsc", "without_dialogue/*.mwsc", "loc/*.json"];
            var _output = dialogue_doc2scripts(_str);
            for (var j = 0; j < array_length(_paths); j++)
            {
                var __outpath = _outpath + string_replace(_paths[j], "*", _filename);
                var __file = file_text_open_write(__outpath);
                file_text_write_string(__file, _output[j]);
                file_text_close(__file);
            }
            _file = file_find_next();
        }
        var _dir = file_find_first(_thisdir + "*", 16);
        while (_dir != "")
        {
            if (_dir != "_out")
            {
                array_push(_directories, _directories[i] + "/" + _dir);
            }
            _dir = file_find_next();
        }
    }
}

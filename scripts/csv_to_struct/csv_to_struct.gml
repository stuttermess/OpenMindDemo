function csv_to_struct(arg0)
{
    var _struct = {};
    var _file = file_text_open_read(arg0);
    var _ln = file_text_readln(_file);
    while (_ln != "" && !file_text_eof(_file))
    {
        var _columns = csv_line_parse(_ln);
        var _key = _columns[0];
        var _val = _columns[1];
        _val = string_replace_all(_val, "\\n", "\n");
        set_value_at_struct_path(_struct, _key, _val);
        _ln = file_text_readln(_file);
    }
    file_text_close(_file);
    return _struct;
}

function csv_line_parse(arg0)
{
    var _cells = [];
    var _char = 1;
    var _ln = "";
    while (_char <= string_length(arg0))
    {
        var _charat = string_char_at(arg0, _char);
        if (_charat == "\"")
        {
            _char++;
            var _last_quot_pos = string_pos_ext("\"", arg0, _char);
            while (string_char_at(arg0, _last_quot_pos + 1) == "\"" && _last_quot_pos != string_length(arg0))
            {
                _last_quot_pos = string_pos_ext("\"", arg0, _last_quot_pos + 2);
            }
            _ln = string_copy(arg0, _char, _last_quot_pos - _char);
            _ln = string_replace_all(_ln, "\"\"", "\"");
            _ln = string_replace_all(_ln, "\r\n", "");
            array_push(_cells, _ln);
            _char = _last_quot_pos + 1;
        }
        else
        {
            var _comma_pos = string_pos_ext(",", arg0, _char);
            if (_comma_pos == 0)
            {
                _comma_pos = string_length(arg0) + 1;
            }
            _ln = string_copy(arg0, _char, _comma_pos - _char);
            _ln = string_replace_all(_ln, "\"\"", "\"");
            _ln = string_replace_all(_ln, "\r\n", "");
            array_push(_cells, _ln);
            _char = _comma_pos + 1;
        }
    }
    return _cells;
}

function csv_to_array(arg0)
{
    var _array = [];
    var file_str = file_text_to_string(arg0);
    var _char = 1;
    while (_char <= string_length(file_str))
    {
        var first_newline = string_pos_ext("\n", file_str, _char);
        if (first_newline == 0)
        {
            first_newline = string_length(file_str);
        }
        var _quotes_in_string = 1;
        var _ln = string_copy(file_str, _char, first_newline - _char);
        if (string_pos("dialogue/0/lobby/dom/questions/q", _ln) != 0)
        {
            var lalalala = 0;
        }
        while ((_quotes_in_string % 2) == 1)
        {
            var _testln = _ln;
            _quotes_in_string = string_length(_testln) - string_length(string_replace_all(_testln, "\"", ""));
            if ((_quotes_in_string % 2) == 1)
            {
                first_newline = string_pos_ext("\n", file_str, first_newline + 1);
                if (first_newline == 0)
                {
                    first_newline = string_length(file_str);
                }
                _ln = string_copy(file_str, _char, first_newline - _char);
            }
        }
        var this_row = csv_line_parse(_ln);
        array_push(_array, this_row);
        _char = first_newline + 1;
    }
    return _array;
}

cutscene = -1;

parse_event_arguments = function(arg0, arg1 = infinity)
{
    var _args_array = [];
    var _str = arg0;
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

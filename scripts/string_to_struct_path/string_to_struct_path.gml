function string_to_struct_path(arg0, arg1 = "/", arg2 = ".", arg3 = infinity)
{
    var _args_array = [];
    var _types_array = [];
    while (string_length(arg0) > 0 && array_length(_args_array) < arg3)
    {
        var struct_sep_pos = string_pos(arg1, arg0) - 1;
        if (struct_sep_pos == -1)
        {
            struct_sep_pos = infinity;
        }
        var array_sep_pos = string_pos(arg2, arg0) - 1;
        if (array_sep_pos == -1)
        {
            array_sep_pos = infinity;
        }
        var word_end = min(struct_sep_pos, array_sep_pos);
        if (word_end <= 0 || word_end == infinity)
        {
            word_end = string_length(arg0);
        }
        var _this_arg = string_copy(arg0, 1, word_end);
        if (_this_arg != "")
        {
            array_push(_args_array, _this_arg);
            if (word_end == struct_sep_pos)
            {
                array_push(_types_array, 1);
            }
            else if (word_end == array_sep_pos)
            {
                array_push(_types_array, 2);
            }
            else
            {
                array_push(_types_array, 0);
            }
        }
        arg0 = string_delete(arg0, 1, string_length(_this_arg));
        var _seperators = [arg1, arg2];
        while (array_contains(_seperators, string_char_at(arg0, 1)))
        {
            arg0 = string_delete(arg0, 1, 1);
        }
    }
    return 
    {
        path: _args_array,
        types: _types_array
    };
}

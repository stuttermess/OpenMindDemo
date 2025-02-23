function set_story_flag(arg0, arg1)
{
    var _struct = master.story_flags;
    arg0 = string_replace_all(arg0, "/", ".");
    var _value_name = arg0;
    var periodpos = string_pos(".", arg0);
    if (periodpos != 1)
    {
        var _path = string_to_struct_path(arg0, ".").path;
        var struct_check = _struct;
        for (var i = 0; i < array_length(_path); i++)
        {
            var valname = _path[i];
            if (i < (array_length(_path) - 1) && !struct_exists(struct_check, valname))
            {
                struct_set(struct_check, valname, {});
            }
            var struct_check_before = struct_check;
            struct_check = struct_get(struct_check, valname);
            if (struct_check == undefined || !is_struct(struct_check))
            {
                struct_check = struct_check_before;
                _value_name = valname;
                i = array_length(_path);
            }
            else
            {
                _value_name = _path[i];
            }
        }
        _struct = struct_check;
    }
    var _type = -1;
    var setvalue = true;
    if (struct_exists(_struct, _value_name))
    {
        _type = typeof(struct_get(_struct, _value_name));
        if (_type == "struct" && _type != typeof(arg1))
        {
            setvalue = false;
        }
    }
    if (setvalue)
    {
        struct_set(_struct, _value_name, arg1);
    }
}

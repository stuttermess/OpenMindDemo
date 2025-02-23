function set_value_at_struct_path(arg0, arg1, arg2)
{
    if (!is_array(arg1))
    {
        arg1 = string_to_struct_path(arg1);
    }
    var _types = arg1.types;
    var _names = arg1.path;
    if (array_length(_types) != array_length(_names))
    {
        exit;
    }
    if (array_length(_names) == 1)
    {
        struct_set(arg0, _names[0], arg2);
        exit;
    }
    var _struct_or_array = arg0;
    for (var i = 0; i < array_length(_names); i++)
    {
        if (is_struct(_struct_or_array))
        {
            var _nextname = _names[i];
            var _nexttype = _types[i];
            var nextval = -1;
            var _exists = struct_exists(_struct_or_array, _nextname);
            if (_exists)
            {
                _struct_or_array = struct_get(_struct_or_array, _nextname);
            }
            else
            {
                switch (_nexttype)
                {
                    case 1:
                        var _newval = {};
                        struct_set(_struct_or_array, _nextname, _newval);
                        _struct_or_array = _newval;
                        break;
                    case 2:
                        var _newval = [];
                        struct_set(_struct_or_array, _nextname, _newval);
                        _struct_or_array = _newval;
                        break;
                }
            }
        }
        else if (is_array(_struct_or_array))
        {
            var _nextind = real(_names[i]);
            var _nexttype = _types[i];
            var _exists = _nextind < array_length(_struct_or_array);
            if (_exists)
            {
                _struct_or_array = _struct_or_array[_nextind];
            }
            else
            {
                var _newval;
                switch (_nexttype)
                {
                    case 1:
                        _newval = {};
                        break;
                    case 2:
                        _newval = [];
                        break;
                }
                if (_nexttype != 0)
                {
                    _struct_or_array[_nextind] = _newval;
                    _struct_or_array = _newval;
                }
            }
        }
        if ((i + 1) == array_length(_names) && i > 0)
        {
            var _nextname = _names[i];
            var _nexttype = _types[i - 1];
            switch (_nexttype)
            {
                case 1:
                    struct_set(_struct_or_array, _nextname, arg2);
                    break;
                case 2:
                    _struct_or_array[real(_nextname)] = arg2;
                    break;
            }
            exit;
        }
    }
}

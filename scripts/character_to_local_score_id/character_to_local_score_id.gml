function character_to_local_score_id(arg0)
{
    var _chars = ["", "sparkle", "shuffle"];
    var _type = typeof(arg0);
    switch (_type)
    {
        case "string":
            var _ind = array_get_index(_chars, arg0);
            if (_ind < 0)
            {
                _ind = 0;
            }
            return _ind;
            break;
        case "number":
        case "int32":
        case "int64":
            arg0 = max(0, arg0);
            if (array_length(_chars) > arg0 && arg0 > 0)
            {
                return _chars[arg0];
            }
            else
            {
                return "unknown";
            }
            break;
    }
}

function endless_preset_id_to_name(arg0)
{
    var _ids = ["custom", 0, "default", 1, "no_gimmicks", 2];
    var _ids_struct = {};
    var _return_id_or_name = !is_real(arg0);
    if (_return_id_or_name == 0)
    {
        arg0 = "_" + string(arg0);
    }
    for (var i = 0; i < array_length(_ids); i += 2)
    {
        if (_return_id_or_name == 0)
        {
            struct_set(_ids_struct, "_" + string(_ids[i + 1]), _ids[i]);
        }
        else
        {
            struct_set(_ids_struct, _ids[i], _ids[i + 1]);
        }
    }
    return struct_get(_ids_struct, arg0);
}

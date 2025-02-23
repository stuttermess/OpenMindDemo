function update_local_endless_score(arg0, arg1, arg2, arg3 = master.current_profile)
{
    var _doupdate = false;
    var _struct = struct_get(master.endless_scores, arg0);
    if (!is_undefined(_struct))
    {
        _struct = struct_get(_struct, arg1);
    }
    if (!is_undefined(_struct))
    {
        var _array = _struct;
        _doupdate = true;
        if (array_length(_array) == 3 && arg2 <= _array[2])
        {
            _doupdate = false;
        }
        if (_doupdate)
        {
            array_push(_array, arg2);
            array_sort(_array, false);
        }
        if (array_length(_array) >= 4)
        {
            _array = array_delete(_array, 3, array_length(_array) - 3);
        }
    }
    else
    {
        if (!struct_exists(master.endless_scores, arg0))
        {
            struct_set(master.endless_scores, arg0, {});
        }
        _struct = struct_get(master.endless_scores, arg0);
        struct_set(_struct, arg1, [arg2]);
        _doupdate = true;
    }
    if (_doupdate)
    {
        local_endless_scores_save(arg3);
    }
    return _doupdate;
}

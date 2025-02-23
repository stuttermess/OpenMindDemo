function play_cutscene_sound(arg0, arg1 = {})
{
    var _is_playing = false;
    with (obj_cutscene_sound_loop)
    {
        if (soundid == arg0)
        {
            _is_playing = true;
        }
    }
    if (!_is_playing)
    {
        var _inst = instance_create_depth(0, 0, 0, obj_cutscene_sound_loop);
        _inst.soundid = arg0;
        var _vars_names = struct_get_names(arg1);
        for (var i = 0; i < array_length(_vars_names); i++)
        {
            variable_instance_set(_inst, _vars_names[i], struct_get(arg1, _vars_names[i]));
        }
        _inst.play();
    }
}

function stop_cutscene_sound(arg0, arg1 = {})
{
    var _insts = [];
    with (obj_cutscene_sound_loop)
    {
        if (soundid == arg0)
        {
            array_push(_insts, self);
            if (ending)
            {
                out_time = 0;
            }
        }
    }
    for (var i = 0; i < array_length(_insts); i++)
    {
        var _inst = _insts[i];
        var _vars_names = struct_get_names(arg1);
        for (var j = 0; j < array_length(_vars_names); j++)
        {
            variable_instance_set(_inst, _vars_names[j], struct_get(arg1, _vars_names[j]));
        }
        _inst.stop();
    }
}

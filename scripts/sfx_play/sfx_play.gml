function sfx_play(arg0, arg1 = false, arg2 = 1, arg3 = 0, arg4 = 1, arg5 = false, arg6 = undefined, arg7 = true)
{
    if (is_string(arg0))
    {
        arg0 = asset_get_index(arg0);
    }
    for (var i = 1; i < argument_count; i++)
    {
        if (is_string(argument[i]))
        {
            argument[i] = real(argument[i]);
        }
    }
    if (instance_exists(obj_minigame_controller) && is_struct(obj_minigame_controller.current_process_mg))
    {
        if (obj_minigame_controller.current_process_mg.time <= 0 && obj_minigame_controller.sfx_add_to_mg_end)
        {
            return -1;
        }
    }
    if (instance_exists(obj_minigame_controller))
    {
        with (obj_minigame_controller)
        {
            if (current_process_mg != -1 && !minigame_started)
            {
                return -1;
            }
        }
    }
    if (instance_exists(obj_minigame_controller) && is_struct(obj_minigame_controller.char) && self == obj_minigame_controller.char.inbetween)
    {
        if (obj_minigame_controller.game_ended)
        {
            return -1;
        }
    }
    var emitter = master.emit_sfx;
    if (arg5)
    {
        emitter = master.emit_mus;
    }
    if (is_undefined(arg6))
    {
        var _x = audio_emitter_get_x(emitter);
        var _y = audio_emitter_get_y(emitter);
        var _z = audio_emitter_get_z(emitter);
        arg6 = 
        {
            x: _x,
            y: _y,
            z: _z
        };
    }
    var _id = audio_play_sound_ext(
    {
        emitter: emitter,
        sound: arg0,
        loop: arg1,
        priority: 100,
        gain: arg2,
        offset: arg3,
        pitch: arg4,
        position: arg6
    });
    if (instance_exists(obj_minigame_controller))
    {
        array_push(obj_minigame_controller.sfx_pause_array, _id);
        if (arg7 && obj_minigame_controller.current_process_mg != -1 && obj_minigame_controller.sfx_add_to_mg_end)
        {
            array_push(obj_minigame_controller.sfx_array, _id);
        }
    }
    return _id;
}

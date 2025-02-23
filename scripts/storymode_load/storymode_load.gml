function storymode_load(arg0 = master.story_file_num, arg1 = master.story_profile)
{
    var _filepath = arg1 + "/file" + string(arg0) + ".sav";
    try
    {
        var _str = file_text_to_string(_filepath);
        _str = base64_decode(_str);
        var _flags = json_parse(_str);
        master.story_flags = _flags;
        var _room_id = master.story_flags.room_id;
        if (is_string(_room_id))
        {
            var _lobby_script = asset_get_index(_room_id);
            if (_lobby_script == -1)
            {
                return false;
            }
            var _cont = instance_create_depth(0, 0, 0, obj_lobby_controller);
            _cont.lobby_id = _lobby_script;
            _cont.initialize_lobby();
            var _tr = start_transition(-1, transition_perlin);
            _tr.outro.reverse = true;
            _tr.outro._time = 1;
        }
        else if (master.story_flags.cuscene_name != "")
        {
            var _cs = asset_get_index(master.story_flags.cuscene_name);
            if (script_exists(_cs))
            {
                play_cutscene(_cs);
            }
        }
        else if (is_real(master.story_flags.room_id))
        {
            switch (master.story_flags.room_id)
            {
                default:
                    return false;
                    break;
            }
        }
        return true;
    }
    catch (error)
    {
        var _str = "Failed to load story save file.";
        _str += ("\n\n" + error.message);
        _str += ("\n\n" + error.longMessage);
        _str += ("\n\n" + error.script);
        show_message(_str);
        return false;
    }
}

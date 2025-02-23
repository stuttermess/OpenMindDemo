function storymode_save(arg0 = master.story_file_num, arg1 = master.story_profile)
{
    if (master.game_ending)
    {
        exit;
    }
    var _filepath = arg1 + "/file" + string(arg0) + ".sav";
    if (instance_exists(obj_lobby_controller))
    {
        if (obj_lobby_controller.lobby.saved_since_load || is_string(master.story_flags.room_id))
        {
            master.story_flags.room_id = script_get_name(obj_lobby_controller.lobby_id);
        }
    }
    master.story_flags.version = 0;
    var _str = json_stringify(master.story_flags);
    _str = string_replace_all(_str, "\"1.0\"", "\"1\"");
    _str = string_replace_all(_str, "\"0.0\"", "\"0\"");
    _str = base64_encode(_str);
    var _file = file_text_open_write(_filepath);
    file_text_write_string(_file, _str);
    file_text_close(_file);
    profile_save();
}

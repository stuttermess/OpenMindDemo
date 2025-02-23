function profile_create(arg0, arg1, arg2 = master.default_settings)
{
    with (master)
    {
        var _newprof = struct_copy(base_profile);
        _newprof.name = arg1;
        _newprof.settings = arg2;
        profile = _newprof;
        current_profile = arg0;
        profile_save();
    }
}

function profile_copy(arg0, arg1)
{
}

function profile_delete(arg0)
{
}

function profile_load(arg0)
{
    with (master)
    {
        if (directory_exists(arg0))
        {
            var _profile_load_info = json_parse(file_text_to_string(arg0 + "/info.json"));
            profile.name = _profile_load_info.name;
            if (profile.name == 0)
            {
                profile.name = steam_get_persona_name();
            }
            profile.storyfiles = _profile_load_info.storyfiles;
            var copystructs = ["settings", "stats", "unlocks", "played_characters"];
            for (var i = 0; i < array_length(copystructs); i++)
            {
                var _load_struct = struct_get(_profile_load_info, copystructs[i]);
                var _base_struct = struct_get(profile, copystructs[i]);
                if (is_undefined(_load_struct))
                {
                    struct_set(_profile_load_info, copystructs[i], struct_copy(_base_struct));
                }
                else
                {
                    var _names = struct_get_names(_load_struct);
                    for (var j = 0; j < array_length(_names); j++)
                    {
                        var _name = _names[j];
                        var _value = struct_get(_load_struct, _name);
                        struct_set(_base_struct, _name, _value);
                    }
                }
            }
            master.settings = profile.settings;
            master.stats = profile.stats;
        }
        else
        {
            exit;
        }
    }
}

function profile_save(arg0 = master.current_profile)
{
    if (version_controller.build_type == 3)
    {
        exit;
    }
    if (master.game_ending)
    {
        exit;
    }
    master.stats.playtime += (current_time - master.timestamp_for_playtime) / 1000;
    master.stats.playtime = round(master.stats.playtime);
    master.timestamp_for_playtime = current_time;
    master.profile.stats = master.stats;
    var _file = file_text_open_write(arg0 + "/info.json");
    file_text_write_string(_file, json_stringify(master.profile));
    file_text_close(_file);
}

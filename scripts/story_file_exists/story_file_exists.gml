function story_file_exists(arg0 = master.story_file_num, arg1 = master.story_profile)
{
    var _filepath = arg1 + "/file" + string(arg0) + ".sav";
    return file_exists(_filepath);
}

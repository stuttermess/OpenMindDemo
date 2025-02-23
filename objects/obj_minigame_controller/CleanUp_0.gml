dbg_section_delete(dbgcontrols);
if (!game_ended && is_struct(char))
{
    char._end_game();
}
surface_free(mg_surface);
surface_free(ibt_surface);
if (array_length(active_mgs) > 0)
{
    active_mgs[0]._cleanup();
}
if (save_play_stats)
{
    if (start_playing_timestamp != 0)
    {
        var timestr = date_datetime_string(start_playing_timestamp);
        timestr = string_replace_all(timestr, " ", "_");
        timestr = string_replace_all(timestr, ",", "_");
        timestr = string_replace_all(timestr, ".", "-");
        timestr = string_replace_all(timestr, ":", "-");
        timestr = string_replace_all(timestr, "/", "-");
        var filename = play_stats_folder + "/" + timestr + ".json";
        var json = json_stringify(play_stats, true);
        var _file = file_text_open_write(filename);
        file_text_write_string(_file, json);
        file_text_close(_file);
    }
}
audio_stop_all();

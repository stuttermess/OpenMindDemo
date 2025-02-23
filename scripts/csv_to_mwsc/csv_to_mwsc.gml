function csv_to_mwsc(arg0)
{
    var _csv = csv_to_array(arg0);
    var _savedir = filename_dir(arg0) + "/csv_output";
    var current_writing_script = [];
    var _current_writing_script_id = "";
    var last_speaker_id = "";
    var columns = 
    {
        SCRIPT_ID: -1,
        SPEAKER_ID: -1,
        EVENT_OR_DIALOGUE_LINE: -1
    };
    var set_speaker_next = false;
    for (var row = 0; row < array_length(_csv); row++)
    {
        var _row_array = _csv[row];
        if (row == 0)
        {
            for (var col = 0; col < array_length(_row_array); col++)
            {
                var _value = _csv[row][col];
                struct_set(columns, string_replace_all(_value, " ", "_"), col);
            }
        }
        else
        {
            var _row_script_id = _csv[row][columns.SCRIPT_ID];
            var _row_speaker_id = string_lower(_csv[row][columns.SPEAKER_ID]);
            var _row_line = _csv[row][columns.EVENT_OR_DIALOGUE_LINE];
            if (_row_script_id != "")
            {
                if (_row_script_id != _current_writing_script_id && _current_writing_script_id != "")
                {
                    var _script_path = _savedir + "/" + _current_writing_script_id + ".mwsc";
                    var _file = file_text_open_write(_script_path);
                    for (var i = 0; i < array_length(current_writing_script); i++)
                    {
                        file_text_write_string(_file, current_writing_script[i]);
                        file_text_writeln(_file);
                    }
                    file_text_close(_file);
                }
                _current_writing_script_id = _row_script_id;
                current_writing_script = [];
                last_speaker_id = "";
            }
            if (_row_speaker_id == "")
            {
                array_push(current_writing_script, _row_line);
                set_speaker_next = true;
            }
            else
            {
                if (_row_speaker_id != last_speaker_id || (set_speaker_next && _row_speaker_id != ""))
                {
                    array_push(current_writing_script, _row_speaker_id);
                    last_speaker_id = _row_speaker_id;
                    set_speaker_next = false;
                }
                var _dialogue_str = _row_line;
                _dialogue_str = string_replace_all(_dialogue_str, "\n", "\\n");
                _dialogue_str = string_replace_all(_dialogue_str, "\"", "\\\"");
                if (_dialogue_str != "")
                {
                    array_push(current_writing_script, "line \"" + _dialogue_str + "\"");
                }
            }
            if ((row + 1) == array_length(_csv))
            {
                var _script_path = _savedir + "/" + _current_writing_script_id + ".mwsc";
                var _file = file_text_open_write(_script_path);
                for (var i = 0; i < array_length(current_writing_script); i++)
                {
                    file_text_write_string(_file, current_writing_script[i]);
                    file_text_writeln(_file);
                }
                file_text_close(_file);
            }
        }
    }
}

function csv_dir_to_mwsc(arg0)
{
    if (!directory_exists(arg0))
    {
        exit;
    }
    var _file = file_find_first(arg0 + "/*.csv", 0);
    while (_file != "")
    {
        var _filepath = arg0 + "/" + _file;
        csv_to_mwsc(_filepath);
        _file = file_find_next();
    }
}

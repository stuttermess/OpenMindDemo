function play_cutscene(arg0)
{
    if (!script_exists(arg0))
    {
        show_debug_message("Cutscene with ID " + string(arg0) + " does not exist.");
        return -1;
    }
    return play_cutscene_struct(new arg0());
}

function play_cutscene_struct(arg0)
{
    var _cont = instance_create_depth(0, 0, 0, cutscene_controller);
    _cont.cutscene = arg0;
    _cont.cutscene.controller_object = _cont;
    _cont.cutscene.next_event();
    return _cont;
}

function play_dialogue_script(arg0)
{
    var _cs = dialogue_script_to_cutscene_struct(arg0);
    if (_cs == false)
    {
        return false;
    }
    else
    {
        play_cutscene_struct(_cs);
        return _cs.events[0];
    }
}

function dialogue_script_to_cutscene_struct(arg0)
{
    if (is_string(arg0))
    {
        if (file_exists(arg0))
        {
            arg0 = load_dialogue_script(arg0);
        }
        else
        {
            show_message("Script File \"" + arg0 + "\" does not exist.");
            return false;
        }
    }
    else if (!is_array(arg0))
    {
        show_message("The provided script is invalid.");
        return false;
    }
    var _cs = new cutscene_constructor();
    _cs.events[0] = new csev_dialogue_constructor();
    _cs.events[0]._script = arg0;
    return _cs;
}

function sequence_get_markers(arg0, arg1 = 0)
{
    var seq = arg0;
    if (!is_struct(seq))
    {
        seq = sequence_get(seq);
    }
    var markers = {};
    var messages = seq.messageEventKeyframes;
    for (var i = 0; i < array_length(messages); i++)
    {
        var _message = messages[i];
        var _frame = _message.frame + arg1;
        var _name = _message.channels[0].events[0];
        if (!struct_exists(markers, _name))
        {
            struct_set(markers, _name, 
            {
                frame: _frame,
                name: _name
            });
        }
    }
    var tracks = seq.tracks;
    for (var i = 0; i < array_length(tracks); i++)
    {
        var track = tracks[i];
        if (track.type == 7 && array_length(track.keyframes) > 0 && track.keyframes[0].channels[0].sequence != -1)
        {
            var this_track_markers = sequence_get_markers(track.keyframes[0].channels[0].sequence, arg1 + track.keyframes[0].frame);
            var _names = struct_get_names(this_track_markers);
            for (var j = 0; j < array_length(_names); j++)
            {
                var marker = struct_get(this_track_markers, _names[j]);
                var _name = marker.name;
                var _frame = marker.frame;
                if (!struct_exists(markers, _name))
                {
                    struct_set(markers, _name, marker);
                }
            }
        }
    }
    return markers;
}

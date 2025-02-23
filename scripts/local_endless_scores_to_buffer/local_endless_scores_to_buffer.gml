function local_endless_scores_to_buffer(arg0)
{
    var _buf = buffer_create(0, buffer_grow, 1);
    var _character_names = struct_get_names(arg0);
    var _version = 1;
    var _character_amount = array_length(_character_names);
    buffer_write(_buf, buffer_u8, _version);
    buffer_write(_buf, buffer_u8, _character_amount);
    for (var i = 0; i < _character_amount; i++)
    {
        var _name = _character_names[i];
        var _bufname = character_to_local_score_id(_name);
        buffer_write(_buf, buffer_u8, _bufname);
        var _presets = struct_get(arg0, _name);
        var _presets_names = struct_get_names(_presets);
        var _preset_amount = array_length(_presets_names);
        buffer_write(_buf, buffer_u16, _preset_amount);
        for (var j = 0; j < _preset_amount; j++)
        {
            var _preset_name = _presets_names[j];
            var _preset_scores = struct_get(_presets, _preset_name);
            var _preset_id = endless_preset_id_to_name(_preset_name);
            buffer_write(_buf, buffer_u16, _preset_id);
            var _preset_score_amount = array_length(_preset_scores);
            if (_preset_id == 0)
            {
                continue;
            }
            buffer_write(_buf, buffer_u8, _preset_score_amount);
            for (var k = 0; k < _preset_score_amount; k++)
            {
                buffer_write(_buf, buffer_u16, _preset_scores[k]);
            }
        }
    }
    return _buf;
}

function local_endless_scores_to_buffer_v0(arg0)
{
    var _buf = buffer_create(0, buffer_grow, 1);
    var _character_names = struct_get_names(arg0);
    var _version = 0;
    var _character_amount = array_length(_character_names);
    var _score_amount = 3;
    buffer_write(_buf, buffer_u8, 0);
    buffer_write(_buf, buffer_u8, _character_amount);
    buffer_write(_buf, buffer_u8, _score_amount);
    for (var i = 0; i < _character_amount; i++)
    {
        var _name = _character_names[i];
        var _bufname = character_to_local_score_id(_name);
        buffer_write(_buf, buffer_u8, _bufname);
        var _char_scores = [];
        var _load_char_base_char_scores = struct_get(arg0, _name);
        array_copy(_char_scores, 0, _load_char_base_char_scores, 0, array_length(_load_char_base_char_scores));
        array_sort(_char_scores, false);
        for (var j = 0; j < _score_amount; j++)
        {
            var __this_score = 0;
            if (array_length(_char_scores) > j)
            {
                __this_score = _char_scores[j];
            }
            buffer_write(_buf, buffer_u16, __this_score);
        }
    }
    return _buf;
}

function local_endless_scores_from_buffer(arg0)
{
    var _scores = {};
    if (!buffer_exists(arg0))
    {
        return _scores;
    }
    var _buf = arg0;
    var _bufsize = buffer_get_size(_buf);
    buffer_seek(_buf, buffer_seek_start, 0);
    var _version = buffer_read(_buf, buffer_u8);
    switch (_version)
    {
        case 0:
            _scores = local_endless_scores_from_buffer_v0(arg0);
            break;
        case 1:
        default:
            _scores = local_endless_scores_from_buffer_v1(arg0);
            break;
    }
    return _scores;
}

function local_endless_scores_from_buffer_v1(arg0)
{
    if (!buffer_exists(arg0))
    {
        return _scores;
    }
    var _buf = arg0;
    var _bufsize = buffer_get_size(_buf);
    buffer_seek(_buf, buffer_seek_start, 0);
    var _version = buffer_read(_buf, buffer_u8);
    var _character_amount = buffer_read(_buf, buffer_u8);
    var _characters = {};
    for (var charnum = 0; charnum < _character_amount; charnum++)
    {
        var _char_name = character_to_local_score_id(buffer_read(_buf, buffer_u8));
        var _preset_amount = buffer_read(_buf, buffer_u16);
        var _presets = {};
        for (var j = 0; j < _preset_amount; j++)
        {
            var _this_preset_num = real(buffer_read(_buf, buffer_u16));
            var _this_preset_name = endless_preset_id_to_name(_this_preset_num);
            var _scores_amount = buffer_read(_buf, buffer_u8);
            var _this_preset_scores = [];
            for (var k = 0; k < _scores_amount; k++)
            {
                _this_preset_scores[k] = buffer_read(_buf, buffer_u16);
            }
            if (_this_preset_num == 0)
            {
                continue;
            }
            struct_set(_presets, _this_preset_name, _this_preset_scores);
        }
        struct_set(_characters, _char_name, _presets);
    }
    return _characters;
}

function local_endless_scores_from_buffer_v0(arg0)
{
    var _scores = {};
    if (!buffer_exists(arg0))
    {
        return _scores;
    }
    var _buf = arg0;
    var _bufsize = buffer_get_size(_buf);
    buffer_seek(_buf, buffer_seek_start, 0);
    var _version = buffer_read(_buf, buffer_u8);
    var _character_amount = buffer_read(_buf, buffer_u8);
    var _score_amount = buffer_read(_buf, buffer_u8);
    for (var charnum = 0; charnum < _character_amount; charnum++)
    {
        var _name = character_to_local_score_id(buffer_read(_buf, buffer_u8));
        var _char_scores = [];
        for (var i = 0; i < _score_amount; i++)
        {
            _char_scores[i] = real(buffer_read(_buf, buffer_u16));
        }
        _char_scores = 
        {
            Default: _char_scores
        };
        struct_set(_scores, _name, _char_scores);
    }
    return _scores;
}

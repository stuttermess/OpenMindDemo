function value_from_keyframes(arg0, arg1)
{
    var _key_ind = -1;
    var _nextkey_ind = -1;
    for (var i = 0; i < array_length(arg0) && _key_ind == -1; i++)
    {
        var thiskeytime = arg0[i][0];
        var nextkeytime = infinity;
        if (i < (array_length(arg0) - 1))
        {
            nextkeytime = arg0[i + 1][0];
        }
        if (arg1 >= thiskeytime && arg1 < nextkeytime)
        {
            _key_ind = i;
            if (nextkeytime == infinity)
            {
                _nextkey_ind = i;
            }
            else
            {
                _nextkey_ind = i + 1;
            }
        }
    }
    if (_key_ind == -1)
    {
        _key_ind = 0;
    }
    var _key = arg0[_key_ind];
    var _nextkey = arg0[_nextkey_ind];
    var _t1 = _key[0];
    var _v1 = _key[1];
    var _t2 = _nextkey[0];
    var _v2 = _nextkey[1];
    var _lerp = _key[2];
    var _t = (arg1 - _t1) / (_t2 - _t1);
    switch (_lerp)
    {
        case -1:
            _t = floor(_t);
            break;
        case 0:
            break;
        default:
            if (script_exists(_lerp))
            {
                _t = _lerp(_t);
            }
            break;
    }
    var _v = lerp(_v1, _v2, _t);
    return _v;
}

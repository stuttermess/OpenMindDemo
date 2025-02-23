function csev_base_constructor() constructor
{
    user_skippable = true;
    key_skippable = true;
    user_skip_keys = [27];
    hold_to_skip = true;
    skip_hold_time = 60;
    skip_through = true;
    _skip_held_time = 0;
    _user_skip_key = 0;
    
    _tick_skip_key = function()
    {
        var _held = false;
        var _pressed = false;
        for (var i = 0; i < array_length(user_skip_keys) && !_held; i++)
        {
            _held = keyboard_check(user_skip_keys[i]);
            _pressed = keyboard_check_pressed(user_skip_keys[i]);
        }
        switch (_user_skip_key)
        {
            case 0:
                if (_pressed)
                {
                    _user_skip_key = 0.5;
                }
                break;
            case 0.5:
                _user_skip_key = 1;
                if (!_held)
                {
                    _user_skip_key = -1;
                }
                break;
            case 1:
                if (!_held)
                {
                    _user_skip_key = -1;
                }
                break;
            case -1:
                _user_skip_key = 0;
                break;
        }
    };
    
    is_skip_key_pressed = function()
    {
        _tick_skip_key();
        return _user_skip_key == 0.5;
    };
    
    is_skip_key_held = function()
    {
        _tick_skip_key();
        return _user_skip_key == 1;
    };
    
    get_skip_input = function()
    {
        if (!user_skippable)
        {
            return false;
        }
        if (user_paused)
        {
            return false;
        }
        if (hold_to_skip)
        {
            if (is_skip_key_held())
            {
                if (_skip_held_time >= skip_hold_time)
                {
                    _skip_held_time = -1;
                    _user_skip_key = 0;
                    _user_pause_key = 0;
                    return true;
                }
                _skip_held_time++;
            }
            else
            {
                _skip_held_time = 0;
            }
        }
        else
        {
            return is_skip_key_pressed();
        }
        return false;
    };
    
    pause_menu = new story_pause_menu_constructor();
    user_paused = false;
    user_pausable = true;
    user_pause_keys = [27];
    _user_pause_key = 0;
    
    _tick_pause_key = function()
    {
        var _held = false;
        var _pressed = false;
        for (var i = 0; i < array_length(user_pause_keys) && !_held; i++)
        {
            _held = keyboard_check(user_pause_keys[i]);
            _pressed = keyboard_check_pressed(user_pause_keys[i]);
        }
        switch (_user_pause_key)
        {
            case 0:
                if (_pressed)
                {
                    _user_pause_key = 0.5;
                }
                break;
            case 0.5:
                _user_pause_key = 1;
                if (!_held)
                {
                    _user_pause_key = -1;
                }
                break;
            case 1:
                if (!_held)
                {
                    _user_pause_key = -1;
                }
                break;
            case -1:
                _user_pause_key = 0;
                break;
        }
    };
    
    is_pause_key_pressed = function()
    {
        _tick_pause_key();
        _tick_skip_key();
        if (_skip_held_time >= 20)
        {
            return false;
            exit;
        }
        if (_user_pause_key == -1)
        {
            _user_skip_key = 0;
            _skip_held_time = 0;
        }
        return _user_pause_key == -1;
    };
    
    is_pause_key_held = function()
    {
        _tick_pause_key();
        return _user_pause_key == 1;
    };
    
    get_pause_input = function()
    {
        if (!user_pausable)
        {
            return false;
        }
        return is_pause_key_pressed();
    };
    
    _end = function()
    {
    };
}

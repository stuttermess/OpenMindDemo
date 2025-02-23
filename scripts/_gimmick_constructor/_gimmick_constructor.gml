function gimmick_constructor() constructor
{
    _init = function()
    {
    };
    
    _tick_before = function()
    {
    };
    
    _tick_after = function()
    {
    };
    
    _draw_before = function()
    {
    };
    
    _draw_before_prompt = function()
    {
    };
    
    _draw_after = function()
    {
    };
    
    _tick_before_inbetween = function()
    {
    };
    
    _tick_after_inbetween = function()
    {
    };
    
    _draw_before_inbetween = function()
    {
    };
    
    _draw_after_inbetween = function()
    {
    };
    
    _on_minigame_init = function()
    {
    };
    
    _on_minigame_start = function()
    {
    };
    
    _on_minigame_end = function()
    {
    };
    
    _on_minigame_over = function()
    {
    };
    
    blacklisted_by_minigame = false;
    blacklistable = true;
    __deleted = false;
    
    _finish = function()
    {
        __deleted = true;
    };
    
    check_currently_blacklisted = function()
    {
        return get_blacklist_weight > 0;
    };
    
    get_blacklist_weight = function()
    {
        var _blacklist_weight = 0;
        var _self_string = instanceof(self);
        if (!instance_exists(obj_minigame_controller))
        {
            return 0;
        }
        with (obj_minigame_controller)
        {
            var is_blacklisted = false;
            if (array_length(active_mgs) >= 1)
            {
                var _blacklist = active_mgs[0].gimmick_blacklist;
                is_blacklisted = array_contains(_blacklist, _self_string);
            }
            if (is_blacklisted)
            {
                var _mg = active_mgs[0];
                var _time = 0;
                with (obj_minigame_controller)
                {
                    if (inbetween_timer < minigame_intro_length)
                    {
                        if (inbetween_type != 3)
                        {
                            _time = (minigame_intro_length - inbetween_timer) / minigame_intro_length;
                        }
                    }
                    else if ((inbetween_length - inbetween_timer) <= minigame_outro_length)
                    {
                        if (_mg.success_state != 0)
                        {
                            _time = 1 - (inbetween_length - (inbetween_timer / minigame_outro_length));
                        }
                    }
                }
                _time = clamp(_time, 0, 1);
                _blacklist_weight = _time;
            }
        }
        return _blacklist_weight;
    };
}

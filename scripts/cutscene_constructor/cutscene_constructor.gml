function cutscene_constructor() constructor
{
    events = [];
    controller_object = -1;
    current_event_id = -1;
    current_event = -1;
    keep_sequence = -1;
    keep_sequence_layer = -1;
    queued_sequence_event = -1;
    
    check_next_event_is_sequence = function()
    {
        if (current_event_id < (array_length(events) - 1))
        {
            var _next = events[current_event_id + 1];
            if (_next._event_type == 0)
            {
                return true;
            }
        }
        return false;
    };
    
    prequeue_next_sequence = function()
    {
        if (check_next_event_is_sequence())
        {
            queued_sequence_event = events[current_event_id + 1];
            queued_sequence_event._init();
            queued_sequence_event._cutscene_controller = self;
            return true;
        }
        return false;
    };
    
    add_event = function(arg0)
    {
    };
    
    next_event = function()
    {
        if (is_struct(queued_sequence_event))
        {
            if (current_event_id >= 0)
            {
                end_current_event();
            }
            current_event_id++;
            if (current_event_id >= array_length(events))
            {
                _on_finish();
                instance_destroy(controller_object);
            }
            else
            {
                current_event = queued_sequence_event;
                queued_sequence_event = -1;
            }
        }
        else
        {
            if (current_event_id >= 0)
            {
                end_current_event();
            }
            current_event_id++;
            if (current_event_id >= array_length(events))
            {
                _on_finish();
                instance_destroy(controller_object);
            }
            else
            {
                start_current_event();
            }
        }
    };
    
    end_current_event = function()
    {
        current_event._end();
    };
    
    start_current_event = function()
    {
        if (is_struct(events[current_event_id]))
        {
            current_event = events[current_event_id];
        }
        else if (script_exists(events[current_event_id]))
        {
            current_event = new events[current_event_id]();
        }
        current_event._cutscene_controller = self;
        current_event._init();
    };
    
    _tick = function()
    {
        if (current_event_id < 0)
        {
        }
        else if (current_event_id >= array_length(events))
        {
        }
        else
        {
            var _ev = current_event;
            _ev._tick();
        }
    };
    
    _draw = function()
    {
        if (current_event_id < 0)
        {
        }
        else if (current_event_id >= array_length(events))
        {
        }
        else
        {
            var _ev = current_event;
            if (variable_struct_exists(_ev, "_draw"))
            {
                _ev._draw();
            }
        }
    };
    
    _on_finish = function()
    {
    };
    
    _on_exit = function()
    {
    };
    
    set_pause_on_quit_function = function(arg0)
    {
        for (var i = 0; i < array_length(events); i++)
        {
            events[i].pause_menu.on_quit = arg0;
        }
    };
}

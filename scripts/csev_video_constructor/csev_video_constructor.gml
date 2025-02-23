function csev_video_constructor() constructor
{
    _event_type = 3;
    _cutscene_controller = -1;
    video_path = "";
    status = video_get_status();
    end_ms = infinity;
    
    _init = function()
    {
        video_open(video_path);
    };
    
    _tick = function()
    {
        status = video_get_status();
        if ((status == 2 && video_get_position() < 0) || (video_get_position() >= video_get_duration() || video_get_position() > end_ms))
        {
            _end_video();
        }
        if (keyboard_check_pressed(vk_escape))
        {
            _end_video();
        }
    };
    
    _draw = function()
    {
        switch (status)
        {
            case 2:
                var _video = video_draw();
                var scale = 270 / surface_get_height(_video[1]);
                draw_surface_ext(_video[1], 0, 0, scale, scale, 0, c_white, 1);
                break;
        }
    };
    
    _end_video = function()
    {
        video_close();
        next_event();
    };
    
    next_event = function()
    {
        _cutscene_controller.next_event();
    };
}

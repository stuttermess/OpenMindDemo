function transition_spotlight() : transition_constructor() constructor
{
    _tick = function()
    {
    };
    
    _draw = function()
    {
        var rad = sqrt(75825) + 15;
        draw_set_color(c_black);
        draw_circle(240, 135, rad * _time, false);
        draw_set_color(c_white);
    };
}

function transition_perlin() : transition_constructor() constructor
{
    _tick = function()
    {
    };
    
    color = 0;
    seed = random_range(10, 20);
    back_color = 16777215;
    back_alpha = 0;
    
    draw_back = function()
    {
        if (back_color > 0)
        {
            var _col = draw_get_color();
            var _alp = draw_get_alpha();
            draw_set_alpha(back_alpha);
            draw_set_color(back_color);
            draw_rectangle(-1, -1, 481, 271, false);
            draw_set_alpha(_alp);
            draw_set_color(_col);
        }
    };
    
    _draw = function()
    {
        draw_back();
        draw_transition_perlin(_time, seed, undefined, undefined, color);
    };
}

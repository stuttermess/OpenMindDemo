function scrollbar_constructor() constructor
{
    x = 0;
    y = 0;
    scroll = 0;
    min_scroll = 0;
    max_scroll = 1;
    scroll_wheel_strength = 0.5;
    inverse = false;
    container_x = 0;
    container_y = 0;
    container_width = 0;
    container_height = 0;
    container_sprite = -1;
    show_container = true;
    bar_x = 0;
    bar_y = 0;
    bar_width = 0;
    bar_height = 0;
    bar_sprite = -1;
    show_bar = true;
    visual_offset_x = 0;
    visual_offset_y = 0;
    cursor_offset_x = 0;
    cursor_offset_y = 0;
    scrollbar_offset = 0;
    allow_input = true;
    hovering = false;
    drag = false;
    drag_y = 0;
    drag_scroll_start = 0;
    sbc = [0, 0, 0, 0];
    
    draw_container = function(arg0)
    {
        if (sprite_exists(container_sprite))
        {
            var _c = container_sprite;
            var _c_xscale = container_width / sprite_get_width(_c);
            var _c_yscale = container_height / sprite_get_height(_c);
            var _c_x = x + container_x;
            var _c_y = y + container_y;
            draw_sprite_ext(_c, 0, _c_x, _c_y, _c_xscale, _c_yscale, 0, c_white, 1);
        }
        else
        {
            draw_rectangle(x + container_x + 1, y + container_y + 1, (x + container_x + container_width) - 1, (y + container_y + container_height) - 1, true);
        }
    };
    
    draw_bar = function(arg0)
    {
        if (sprite_exists(bar_sprite))
        {
            bar_width = sprite_get_width(bar_sprite);
            bar_height = sprite_get_height(bar_sprite);
            var offx = sprite_get_xoffset(bar_sprite);
            var offy = sprite_get_yoffset(bar_sprite);
            var _x = (mean(sbc[0], sbc[2]) - offx) + (bar_width / 2);
            var _y = (mean(sbc[1], sbc[3]) - offy) + (bar_height / 2) + scrollbar_offset;
            draw_sprite(bar_sprite, 0, _x, _y);
        }
        else
        {
            draw_rectangle(sbc[0], sbc[1], sbc[2], sbc[3], false);
        }
    };
    
    tick = function()
    {
        cursor_x = mouse_x + cursor_offset_x;
        cursor_y = mouse_y + cursor_offset_y;
        var _prev_scroll = scroll;
        var scrolldir = (mouse_wheel_down() - mouse_wheel_up()) * scroll_wheel_strength;
        if (inverse)
        {
            scrolldir *= -1;
        }
        scroll += scrolldir;
        scroll = clamp(scroll, min_scroll, max_scroll);
        _set_scroll_pos(scroll, false);
        hovering = false;
        if (!allow_input)
        {
            exit;
        }
        if (drag)
        {
            hovering = true;
            var scroll_dist = cursor_y - drag_y;
            if (inverse)
            {
                scroll_dist *= -1;
            }
            var _newscrollbary = drag_y_start + scroll_dist;
            scroll = ((_newscrollbary - container_y - (bar_height / 2)) / (-(bar_height / 2) + (container_height - (bar_height / 2)))) * max_scroll;
            scroll = clamp(scroll, 0, max_scroll);
            _set_scroll_pos(scroll);
            drag = mouse_check_button(mb_left);
        }
        else if (point_in_rectangle(cursor_x, cursor_y, sbc[0], sbc[1], sbc[2], sbc[3]) && !(scroll <= min_scroll && scroll >= max_scroll))
        {
            hovering = true;
            if (mouse_check_button_pressed(mb_left))
            {
                drag = true;
                drag_y = cursor_y;
                drag_y_start = bar_y;
                drag_scroll_start = scroll;
                if (inverse)
                {
                    var savescroll = scroll;
                    _set_scroll_pos(max_scroll - scroll, false);
                    drag_y_start = bar_y;
                    _set_scroll_pos(savescroll, false);
                }
            }
        }
    };
    
    draw = function()
    {
        if (show_container)
        {
            draw_container();
        }
        if (show_bar)
        {
            draw_bar();
        }
    };
    
    set_scroll = function(arg0)
    {
        _set_scroll_pos(arg0, false);
    };
    
    on_scroll_update = function()
    {
    };
    
    _set_scroll_pos = function(arg0, arg1 = true)
    {
        if (inverse)
        {
            arg0 = max_scroll - arg0;
        }
        var sb_y = container_y + lerp(bar_height / 2, container_height - (bar_height / 2), arg0 / max_scroll);
        bar_y = sb_y;
        sbc[0] = x + container_x + 2;
        sbc[1] = ((y + sb_y) - (bar_height / 2)) + 1 + 2;
        sbc[2] = (x + container_x + container_width) - 2;
        sbc[3] = (y + sb_y + (bar_height / 2)) - 2;
        if (arg1)
        {
            on_scroll_update();
        }
    };
}

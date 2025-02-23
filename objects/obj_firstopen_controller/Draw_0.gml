var crhover = false;
if (options_open)
{
    options_menu._draw();
    crhover = options_menu.cursor_hover != -1;
}
else
{
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(240, 94.5, string_to_wrapped(msg, 250, "\n"));
    for (var i = 0; i < array_length(btns); i++)
    {
        var _btn = btns[i];
        var _x = _btn.x;
        var _y = _btn.y;
        draw_text(_x, _y + 2, _btn.text);
        var _w = string_width(_btn.text);
        var _h = string_height(_btn.text);
        var _hw = (_w / 2) * 1.2;
        var _hh = _h / 2;
        var _p = 3;
        _btn.coords = [_x - _hw - _p, _y - _hh - _p, _x + _hw + _p, _y + _hh + _p];
        var crd = _btn.coords;
        draw_rectangle(crd[0], crd[1], crd[2], crd[3], true);
        if (point_in_rectangle(mouse_x, mouse_y, crd[0], crd[1], crd[2], crd[3]))
        {
            crhover = true;
            if (get_input_click())
            {
                _btn.onclick();
            }
        }
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
var iind = 0;
if (crhover)
{
    iind = 1;
    if (mouse_check_button(mb_left))
    {
        iind = 2;
    }
}
draw_sprite(spr_cursor, iind, mouse_x, mouse_y);

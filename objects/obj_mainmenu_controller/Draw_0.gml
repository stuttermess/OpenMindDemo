draw_clear(c_black);
draw_mainmenu_bg(current_time / 1000, mmbg_args);
if (master.debug_vars.main_menu_bg_only)
{
    exit;
}
draw_all_menus();
if (instance_exists(obj_charselect_menu))
{
    exit;
}
else
{
    mmbg_args.things_blend_amount = 1;
}
var crsprite = 0;
var cx = mouse_x;
var cy = mouse_y;
if (is_struct(active_menu))
{
    with (active_menu)
    {
        if (cursor_hover != -1)
        {
            crsprite = 1;
            if (mouse_check_button(mb_left))
            {
                crsprite = 2;
            }
        }
    }
}
draw_sprite(spr_cursor, crsprite, cx, cy);
var _opening_length = 380;
var _hold_length = 174;
if (opening_timer < 1)
{
    if (master.do_mainmenu_flash)
    {
        opening_timer *= _opening_length;
        var _al = 1;
        if (opening_timer <= _hold_length)
        {
            _al = 1;
        }
        else
        {
            _al = 1 - ((opening_timer - _hold_length) / (_opening_length - _hold_length));
        }
        draw_set_alpha(_al);
        draw_rectangle(-1, -1, 481, 271, false);
        draw_set_alpha(1);
        opening_timer += 1;
        opening_timer /= _opening_length;
    }
    else
    {
        opening_timer = 1;
    }
}

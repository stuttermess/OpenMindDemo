var crx = cursor_x;
var cry = cursor_y;
talkmenu_prog = clamp(talkmenu_prog, 0, 1);
var talkmenu_display;
if (talkmenu == 0)
{
    talkmenu_display = lerp_easeOut(1 - talkmenu_prog);
}
else
{
    talkmenu_display = lerp_easeOutBack(talkmenu_prog);
}
var starthover = talkmenu_button_hover;
if (!talkmenu_force_open)
{
    talkmenu_button_hover = 0;
}
if (talkmenu_display > 0)
{
    blendmode_set_multiply();
    draw_sprite_ext(spr_lbui_multiplyspacebarbg, 0, 0, 0, 1, 1, 0, c_white, talkmenu_display);
    blendmode_reset();
    blendmode_set_colordodge();
    draw_sprite_ext(spr_lbui_COLORDODGEcircles, 0, 0, 100 * clamp(1 - talkmenu_display, 0, 1), 1, 1, 0, c_white, 0.7);
    blendmode_reset();
    var btns_xdiff = -160 * (talkmenu_display - 1);
    if (!talkmenu_force_open && talkmenu_prog == 1 && point_in_circle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), 68 - btns_xdiff, 213, 70))
    {
        talkmenu_button_hover = 1;
    }
    if (!talkmenu_force_open && talkmenu_prog == 1 && point_in_circle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), 412 + btns_xdiff, 213, 70))
    {
        talkmenu_button_hover = 2;
    }
    var smallsbtn_spr = spr_lbui_smalls1;
    if (talkmenu_button_hover == 1)
    {
        smallsbtn_spr = spr_lbui_smalls2;
    }
    var skipbtn_spr = spr_lbui_skip1;
    if (talkmenu_button_hover == 2)
    {
        skipbtn_spr = spr_lbui_skip2;
    }
    var smallsbtn_spr_textx = 72;
    if (talkmenu_button_hover == 1)
    {
        smallsbtn_spr_textx = 84;
    }
    var skipbtn_spr_textx = 413;
    if (talkmenu_button_hover == 2)
    {
        skipbtn_spr_textx = 400;
    }
    smallsbtn_spr_textx -= btns_xdiff;
    var smallsbtn_spr_texty = 260;
    skipbtn_spr_textx += btns_xdiff;
    var skipbtn_spr_texty = 260;
    draw_sprite(smallsbtn_spr, talkmenu_button_frame, -btns_xdiff, 0);
    draw_set_valign(fa_bottom);
    draw_set_halign(fa_center);
    draw_text_outline(smallsbtn_spr_textx, smallsbtn_spr_texty, "Chat with Smalls");
    draw_sprite(skipbtn_spr, talkmenu_button_frame, btns_xdiff, 0);
    draw_text_outline(skipbtn_spr_textx, skipbtn_spr_texty, "Skip Lobby");
    draw_set_valign(fa_bottom);
    draw_set_halign(fa_left);
    if (starthover != talkmenu_button_hover)
    {
        talkmenu_button_frame = 0;
    }
}
var chi_x = 47;
var spcb_y = 0;
var log_x = 480;
var choicehover = false;
if (instance_exists(cutscene_controller))
{
    with (cutscene_controller)
    {
        if (cutscene != -1)
        {
            if (cutscene.current_event != -1)
            {
                switch (cutscene.current_event._event_type)
                {
                    case 1:
                        with (cutscene.current_event)
                        {
                            chi_x = lerp(chi_x, -chi_x - 35, intro_ease(intro_anim));
                            spcb_y = lerp(spcb_y, spcb_y + 40, intro_ease(intro_anim));
                            if (option_hover != undefined)
                            {
                                choicehover = true;
                            }
                        }
                        break;
                    case 0:
                        chi_x = -chi_x - 35;
                        spcb_y = spcb_y + 40;
                        log_x += 100;
                        break;
                }
            }
        }
    }
}
draw_sprite(lb0_spr_groundfloor, 0, chi_x, 43);
draw_sprite(spr_lbui_spacebar, ui_space_frame, 0, spcb_y);
draw_sprite(spr_logffwd, 0, log_x, 0);
if (logmenu || logmenu_prog < 1)
{
    logmenu_obj._draw();
}
if (lobby.active_popup != -1)
{
    lobby.active_popup.draw();
}
pausemenu_prog = clamp(pausemenu_prog, 0, 1);
var pausemenu_display;
if (pausemenu == 0)
{
    pausemenu_display = lerp_easeOut(1 - pausemenu_prog);
}
else
{
    pausemenu_display = lerp_easeOutBack(pausemenu_prog);
}
var pausecrhover = -1;
var pausescreen = false;
if (pausemenu_display > 0 || instance_exists(cutscene_controller))
{
    pausescreen = true;
    if (pausemenu_display > 0)
    {
        pausemenu_obj.draw();
    }
    var _pmobj = pausemenu_obj;
    if (instance_exists(cutscene_controller) && cutscene_controller.cutscene.current_event._event_type == 1)
    {
        _pmobj = cutscene_controller.cutscene.current_event.pause_menu;
    }
    pausecrhover = _pmobj.cursor_hover;
    if (_pmobj.options_open)
    {
        pausecrhover = _pmobj.options_menu.cursor_hover;
    }
}
var cr_hover = sprite_hover != 0 || (talkmenu_button_hover != 0 && !talkmenu_force_open) || choicehover || (pausescreen && pausecrhover != -1) || logmenu_obj.hovering;
if (lobby_id != -1)
{
    if (active)
    {
        var subim = 0;
        if (cr_hover)
        {
            subim = 1;
            if (mouse_check_button(mb_left))
            {
                subim = 2;
            }
        }
        draw_sprite(spr_cursor, subim, crx, cry);
    }
}

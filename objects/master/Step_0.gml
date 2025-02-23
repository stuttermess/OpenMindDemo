steam_update();
if (!dev_mode)
{
    exit;
}
if (keyboard_check(vk_control))
{
    if (keyboard_check_pressed(ord("D")))
    {
        show_debug_overlay(!is_debug_overlay_open(), false, window_scale * 0.5);
        if (is_debug_overlay_open())
        {
            window_set_cursor(cr_default);
        }
        else
        {
            window_set_cursor(cr_none);
        }
    }
    if (keyboard_check_pressed(ord("R")))
    {
        _restart_game();
    }
}
if (keyboard_check(vk_shift) && keyboard_check_pressed(ord("1")))
{
    audio_stop_all();
    instance_destroy(cutscene_controller);
    instance_destroy(obj_mainmenu_controller);
    video_close();
    instance_create_depth(0, 0, 0, obj_debug_menu);
}

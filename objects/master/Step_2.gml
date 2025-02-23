if (mouselock != mouselock_before)
{
    mouselock_before = mouselock;
}
if (game_focused)
{
    if (mouselock)
    {
        var wx = window_get_x();
        var wy = window_get_y();
        var do_lock = true;
        switch (settings.mouselock)
        {
            case 0:
                break;
            case 1:
                do_lock = instance_exists(obj_minigame_controller) && (obj_minigame_controller.game_active && !obj_minigame_controller.paused);
                break;
            case 2:
                do_lock = false;
                break;
        }
        if (do_lock)
        {
            display_mouse_lock(wx, wy, window_get_width(), window_get_height());
        }
    }
    else
    {
        display_mouse_unlock();
    }
}
if (is_debug_overlay_open())
{
    debug_vars.storyflag_display = get_story_flag(debug_vars.storyflag_name);
}

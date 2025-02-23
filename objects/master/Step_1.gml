if (!instance_exists(version_controller))
{
    instance_create_depth(0, 0, 0, version_controller);
}
game_focused = window_has_focus();
if (steam_initialised())
{
    game_focused = game_focused && !steam_is_overlay_activated();
}
mouselock_before = mouselock;
switch (click)
{
    case 0:
        if (mouse_check_button_pressed(mb_left))
        {
            click = 0.4;
            click_x = device_mouse_x_to_gui(0);
            click_y = device_mouse_y_to_gui(0);
        }
        break;
    case 0.4:
        if (point_distance(click_x, click_y, device_mouse_x_to_gui(0), device_mouse_y_to_gui(0)) > 5)
        {
            click = 0;
        }
        else if (!mouse_check_button(mb_left))
        {
            click = 1;
        }
        break;
    case 1:
        click = 0;
        break;
}
if (is_mouse_over_debug_overlay())
{
    click = 0;
}
focus_volume = lerp(focus_volume, game_focused || !settings.mute_on_lose_focus, 0.2);
audio_listener_position(240, 135, 0);
audio_listener_orientation(240, 135, 1, 0, -1, 0);
audio_emitter_position(emit_mus, 240, 135, 0);
audio_emitter_position(emit_sfx, 240, 135, 0);
audio_emitter_gain(emit_mus, (settings.vol_music / 100) * (settings.vol_master / 50) * 1.2 * focus_volume);
audio_emitter_gain(emit_sfx, (settings.vol_sfx / 100) * (settings.vol_master / 50) * 1.55 * focus_volume);
if (allow_fullscreen_switch && (keyboard_check_pressed(vk_f4) || keyboard_check_pressed(vk_f11) || (keyboard_check(vk_alt) && keyboard_check_pressed(vk_enter))))
{
    settings.fullscreen = !settings.fullscreen;
}
if (prev_fullscreen != settings.fullscreen)
{
    prev_fullscreen = settings.fullscreen;
    window_set_fullscreen(settings.fullscreen);
    if (!settings.fullscreen)
    {
        set_screen_size(settings_window_scale);
        window_center();
    }
}
if (mouselock_bool)
{
    settings.mouselock = 0;
}
else
{
    settings.mouselock = 2;
}
if (!settings.fullscreen)
{
    var res_dir = keyboard_check_pressed(187) - keyboard_check_pressed(189);
    if (abs(res_dir))
    {
        if (keyboard_check(187) && keyboard_check(189))
        {
            set_screen_size(-1);
        }
        else
        {
            var _max = get_max_screen_size();
            var newsize = clamp(window_scale + res_dir, 1, _max);
            set_screen_size(newsize);
        }
    }
}
var _testscale = settings_window_scale;
if (_testscale <= 0)
{
    _testscale = get_default_screen_size();
}
if (_testscale != window_scale)
{
    if (settings.fullscreen)
    {
        window_scale = settings_window_scale;
    }
    else
    {
        set_screen_size(settings_window_scale);
    }
}

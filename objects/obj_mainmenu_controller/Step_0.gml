var prev_curbeat = current_beat;
current_beat = music_repeat_beat + sound_get_beat(music, 99, 1214);
if (prev_curbeat > current_beat)
{
    music_repeats++;
    music_repeat_beat = floor(prev_curbeat);
}
if (menu_transition_time_until > 0)
{
    menu_transition_time_until--;
    if (menu_transition_time_until <= 0)
    {
        menu_transition_time = 0;
        menu_transition_time_until = -1;
    }
    transition_happening = true;
}
if (menu_transition_time < 1)
{
    transition_happening = true;
    menu_transition_time += menu_transition_speed;
    menu_transition_time = clamp(menu_transition_time, 0, 1);
    var _start_real = is_struct(menu_transition_start) || (instance_exists(menu_transition_start) && menu_transition_start != -1);
    var _end_real = is_struct(menu_transition_end) || (instance_exists(menu_transition_end) && menu_transition_end != -1);
    var campos = [[cam_x, cam_y], [cam_x, cam_y]];
    if (_start_real)
    {
        menu_transition_start.menu_in = lerp(1, 0, menu_transition_lerp_func(menu_transition_time));
        campos[0] = [menu_transition_start.cam_x, menu_transition_start.cam_y];
    }
    if (_end_real)
    {
        menu_transition_end.menu_in = lerp(0, 1, menu_transition_lerp_func(menu_transition_time));
        campos[1] = [menu_transition_end.cam_x, menu_transition_end.cam_y];
    }
    cam_x = lerp(campos[0][0], campos[1][0], menu_transition_lerp_func(menu_transition_time));
    cam_y = lerp(campos[0][1], campos[1][1], menu_transition_lerp_func(menu_transition_time));
    if (menu_transition_time >= 0.9 && active_menu == -1 && _end_real)
    {
        active_menu = menu_transition_end;
    }
    if (menu_transition_time >= 1)
    {
        transition_happening = false;
        if (_start_real)
        {
            menu_transition_start.menu_in = 0;
        }
        if (_end_real)
        {
            menu_transition_end.menu_in = 1;
            active_menu = menu_transition_end;
        }
    }
}
mmbg_args.x = -cam_x / 10;
mmbg_args.y = -cam_y / 10;
tick_all_menus();

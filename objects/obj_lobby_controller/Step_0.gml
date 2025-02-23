var transition_happening = instance_exists(transition_controller);
active = 1 && !quitting;
if (!active)
{
    exit;
}
if (is_debug_overlay_open())
{
    master.mouselock = false;
    exit;
}
if (logmenu)
{
    logmenu_obj._tick();
}
if (!transition_happening && !talkmenu && !instance_exists(cutscene_controller) && lobby.active_popup == -1 && !logmenu)
{
    if (keyboard_check_pressed(vk_escape))
    {
        if (!pausemenu)
        {
            pausemenu_prog = 1 - pausemenu_prog;
            pausemenu = true;
            pausemenu_obj.open();
        }
    }
}
var destcutoff = 25000;
if (pausemenu)
{
    destcutoff = 500;
    pausemenu_obj.tick();
}
if (talkmenu && !talkmenu_force_open)
{
    destcutoff = 5000;
}
pause_effect.cutoff += (destcutoff - pause_effect.cutoff) * 0.1;
master.mouselock = false;
if (!transition_happening && !pausemenu && (keyboard_check_pressed(vk_tab) || (logmenu && keyboard_check_pressed(vk_escape))))
{
    if (lobby.active_popup == -1 && !pausemenu && !talkmenu && !logmenu)
    {
        var allow = true;
        if (instance_exists(cutscene_controller))
        {
            switch (cutscene_controller.cutscene.current_event._event_type)
            {
                case 1:
                    if (!cutscene_controller.cutscene.current_event.allow_player_input || cutscene_controller.cutscene.current_event.pause_menu.active)
                    {
                        allow = false;
                    }
                    else
                    {
                        cutscene_controller.cutscene.current_event.paused = !logmenu;
                    }
                    break;
                default:
                    allow = false;
                    break;
            }
        }
        if (allow)
        {
            logmenu = true;
            logmenu_obj.open();
        }
    }
}
while (array_length(dialogue_log) > 100)
{
    array_delete(dialogue_log, 0, 1);
}
if (instance_exists(cutscene_controller) || lobby.active_popup != -1)
{
    if (!talkmenu_force_open && talkmenu)
    {
        talkmenu_prog = 1 - talkmenu_prog;
        talkmenu = false;
    }
}
else if (pausemenu)
{
}
else
{
    master.mouselock = true;
    if (logmenu)
    {
        master.mouselock = false;
    }
    else
    {
        if (talkmenu_force_open)
        {
        }
        else
        {
            switch (spacebar_mook_or_megalo_mode)
            {
                case 1:
                    var prev_talkmenu = talkmenu;
                    if (talkmenu)
                    {
                        talkmenu = keyboard_check(vk_space);
                    }
                    else
                    {
                        talkmenu = keyboard_check_pressed(vk_space) && lobby.interact_anim == 1;
                    }
                    if (instance_exists(cutscene_controller) || instance_exists(transition_controller))
                    {
                        talkmenu = false;
                    }
                    if (prev_talkmenu != talkmenu)
                    {
                        talkmenu_prog = 1 - talkmenu_prog;
                        if (prev_talkmenu)
                        {
                            sfx_play(snd_lobby_space_close);
                        }
                        else
                        {
                            sfx_play(snd_lobby_space_open);
                        }
                    }
                    break;
                case 2:
                    break;
            }
        }
        if (keyboard_check(vk_space))
        {
            ui_space_frame = 1;
        }
        else if (!keyboard_check(vk_space))
        {
            switch (floor(ui_space_frame))
            {
                case 1:
                    if (spacebar_mook_or_megalo_mode == 0)
                    {
                        talkmenu = !talkmenu;
                        talkmenu_prog = 1 - talkmenu_prog;
                        if (talkmenu)
                        {
                            sfx_play(snd_lobby_space_open);
                        }
                        else
                        {
                            sfx_play(snd_lobby_space_close);
                        }
                    }
                    ui_space_frame = 2;
                    break;
                case 2:
                    ui_space_frame += 0.2;
                    break;
                case 3:
                    ui_space_frame = 0;
                    break;
            }
        }
    }
}
if (talkmenu_force_open)
{
    ui_space_frame = 1;
    talkmenu = true;
}
if (logmenu_prog < 1)
{
    logmenu_prog += 1;
}
if (talkmenu_prog < 1)
{
    talkmenu_prog += 0.1;
}
if (pausemenu_prog < 1)
{
    pausemenu_prog += 1;
}
if (talkmenu_button_hover != 0)
{
    talkmenu_button_frame += 0.08333333333333333;
    talkmenu_button_frame %= 2;
}
if (!instance_exists(cutscene_controller))
{
    dialoguepause = false;
}
var dolobbytick = !talkmenu && !pausemenu && !logmenu && !dialoguepause;
if (talkmenu_force_open && !dolobbytick)
{
    dolobbytick = true;
}
if (dolobbytick)
{
    lobby._tick();
}
var crx = cursor_x;
var cry = cursor_y;
var talkmenu_out = talkmenu || (!talkmenu && talkmenu_prog < 0.5);
var hovered = false;
var clicked = false;
if (dolobbytick)
{
    with (lobby)
    {
        if (active_popup == -1)
        {
            var can_control = !instance_exists(cutscene_controller);
            var can_interact = can_control && !talkmenu_out && !transition_happening && interact_anim == 1;
            var can_move = can_control && !talkmenu_out && !transition_happening;
            var can_nudge = can_control;
            var xaxis = real(keyboard_check(vk_right) || keyboard_check(ord("D"))) - real(keyboard_check(vk_left) || keyboard_check(ord("A")));
            var yaxis = real(keyboard_check(vk_down) || keyboard_check(ord("S"))) - real(keyboard_check(vk_up) || keyboard_check(ord("W")));
            if (interact_anim < 1)
            {
                interact_anim += (1 / interact_anim_time);
                if (interact_anim >= 1)
                {
                    interact_anim = 1;
                    interactable_script();
                }
            }
            var _xv = xaxis;
            var _yv = yaxis;
            if (_xv == 0 && (crx < 25 || crx > 455))
            {
                _xv = sign(crx - 240);
            }
            if (_yv == 0 && (cry < 25 || cry > 245))
            {
                _yv = sign(cry - 135);
            }
            if (!can_move)
            {
                _xv = 0;
                _yv = 0;
            }
            xscrolling += ((_xv - xscrolling) * 0.15);
            yscrolling += ((_yv - yscrolling) * 0.15);
            if (interact_anim < 1)
            {
                xscrolling = 0;
                yscrolling = 0;
            }
            cam_x += (xscrolling * xscroll_speed);
            cam_y += (yscrolling * yscroll_speed);
            var wiggle_x = 10;
            var wiggle_y = 6;
            var xmin = wiggle_x * 1;
            var xmax = width - (wiggle_x * 1) - 480;
            var ymin = wiggle_y * 1;
            var ymax = height - (wiggle_y * 1) - 270;
            var nudge_cx = ((crx - 240) / 480) * (wiggle_x * 2);
            var nudge_cy = ((cry - 135) / 270) * (wiggle_y * 2);
            cam_x = clamp(cam_x, max(xmin, cam_x_min), min(xmax, cam_x_max));
            cam_y = clamp(cam_y, max(ymin, cam_y_min), min(ymax, cam_y_max));
            if (can_nudge)
            {
                nudge_x += ((nudge_cx - nudge_x) * 0.1);
                nudge_y += ((nudge_cy - nudge_y) * 0.1);
            }
            var camx = cam_x + nudge_x;
            var camy = cam_y + nudge_y;
            var lb_origin_x = origin_x;
            var lb_origin_y = origin_y;
            var i = array_length(sprites) - 1;
            while (i >= 0 && !hovered)
            {
                var _sprite = sprites[i];
                with (_sprite)
                {
                    var sprspd = sprite_get_speed(sprite_index);
                    switch (sprite_get_speed_type(sprite_index))
                    {
                        case 0:
                            image_index += ((sprspd / 60) * image_speed);
                            break;
                        case 1:
                            image_index += (sprspd * image_speed);
                            break;
                    }
                    image_index %= sprite_get_number(sprite_index);
                }
                i--;
            }
            hovered = false;
            camx = round(cam_x + nudge_x);
            camy = round(cam_y + nudge_y);
            var _crx = mouse_x + camx;
            var _cry = mouse_y + camy;
            for (i = 0; i < array_length(interact_zones) && !hovered && can_interact; i++)
            {
                var zone_name = interact_zones[i].name;
                var zones = interact_zones[i].zones;
                var _hoverable = true;
                if (struct_exists(hoverable_funcs, zone_name))
                {
                    var _hoverable_func = struct_get(hoverable_funcs, zone_name);
                    if (is_method(_hoverable_func) || script_exists(_hoverable_func))
                    {
                        _hoverable = _hoverable_func();
                    }
                }
                if (_hoverable)
                {
                    for (j = 0; j < array_length(zones) && !hovered; j++)
                    {
                        var zc = zones[j];
                        hovered = point_in_quad(_crx, _cry, zc[0][0], zc[0][1], zc[1][0], zc[1][1], zc[2][0], zc[2][1], zc[3][0], zc[3][1]);
                        if (hovered && get_input_click())
                        {
                            if (struct_exists(interact_funcs, zone_name))
                            {
                                var _interact_func = struct_get(interact_funcs, zone_name);
                                interactable_script = _interact_func;
                                interact_anim = 0;
                                sfx_play(snd_lobby_clickable_click);
                                interact_anim_x = _crx;
                                interact_anim_y = _cry;
                            }
                            else
                            {
                                show_message_async("No interact function set for \"" + zone_name + "\"");
                            }
                        }
                    }
                }
            }
        }
    }
}
if (get_input_click())
{
    if (lobby.interact_anim == 1)
    {
        if (!talkmenu_force_open)
        {
            switch (talkmenu_button_hover)
            {
                case 1:
                    lobby.on_smalls_click();
                    break;
                case 2:
                    lobby.on_pandora_click();
                    break;
            }
        }
    }
}
sprite_hover = hovered;

click = get_input_click() && can_click;
var chardir = 0;
chardir += (keyboard_check_pressed(ord("W")) - keyboard_check_pressed(ord("S")));
chardir += (keyboard_check_pressed(vk_up) - keyboard_check_pressed(vk_down));
chardir += ((mouse_wheel_up() - mouse_wheel_down()) * real(screen_transition >= 0.15));
chardir = sign(chardir) * real(can_click);
cur_hover = false;
set_pagebtns_pos();
if (keyboard_check_pressed(vk_escape))
{
    if (!instance_exists(transition_controller) && !obj_mainmenu_controller.transition_happening)
    {
        if (showing_steam_leaderboard)
        {
            close_steam_leaderboard();
        }
        else if (settings_menu_open)
        {
            settings_menu.btnback.on_click();
        }
        else
        {
            back_to_main_menu();
        }
    }
}

back_to_main_menu = function()
{
    if (obj_mainmenu_controller.start_menu_transition(obj_mainmenu_controller.menu_main))
    {
        can_click = false;
        save();
        with (obj_mainmenu_controller.menu_main)
        {
            highlight_img_transition = 1;
            highlight_image_ind = array_length(highlight_images) - 1;
        }
        sfx_play(snd_menu_back);
    }
};

var menu_open = showing_steam_leaderboard || settings_menu_open;
for (var i = 0; i < 2; i++)
{
    var crds = pagebtn[i];
    var x1 = pagebtns_x + crds[0];
    var y1 = pagebtns_y + crds[1];
    var x2 = pagebtns_x + crds[2];
    var y2 = pagebtns_y + crds[3];
    var x3 = pagebtns_x + crds[4];
    var y3 = pagebtns_y + crds[5];
    if (point_in_triangle(mouse_x, mouse_y, x1, y1, x2, y2, x3, y3) && !menu_open)
    {
        cur_hover = true;
        if (click)
        {
            chardir = -sign(i - 0.5);
            click = false;
        }
    }
}
if (chardir != 0)
{
    switch_selected_character(character_num + chardir);
    do_transition_anim(chardir);
}
if (been_in && screen_transition < 1)
{
    screen_transition += (1 / screen_transition_time);
    screen_transition = clamp(screen_transition, 0, 1);
}
if (menu_in > 0)
{
    been_in = true;
}
if (been_in && menu_in == 0)
{
    instance_destroy();
}
prev_character._tick();
character._tick();
if (menu_in == 1)
{
    letterbox_color = merge_color(letterbox_color, character.letterbox_color, 0.15 * (15 / screen_transition_time));
    obj_mainmenu_controller.mmbg_args.things_blend_amount = lerp(0, 1, screen_transition);
}
else
{
    letterbox_color = merge_color(letterbox_color, start_letterbox_color, 1 - menu_in);
}
if (showing_steam_leaderboard)
{
    steam_leaderboard._tick();
}
if (game_mode_anim < 1)
{
    game_mode_anim += (1/15);
}
if (game_mode_fade_anim < 1)
{
    game_mode_fade_anim += (1/15);
}

with (master)
{
    endless_scores = local_endless_scores_load(current_profile);
}
been_in = false;
menu_in = 0;
cam_x = 720;
cam_y = 0;
menu_in_draw = 0;
menu_in_anim_length = 10;
depth = -1;
character_num = 1;
character = new charselect_character_constructor();
prev_character = character;
characters = [charselect_tutorial, charselect_shuffle, charselect_sparkle];
character_settings_save = array_create(array_length(characters), 0);
can_save_settings = false;
game_mode = 1;
prev_game_mode = 0;
game_mode_anim = 1;
game_mode_fade_anim = 1;
prev_mode_was_prev_char = false;
start_letterbox_color = 11929488;
letterbox_color = start_letterbox_color;
letterbox_sf = surface_create(480, 270);
bg_sf = surface_create(480, 270);

border_y_to_x = function(arg0, arg1, arg2 = true)
{
    var _val = (arg0 / -2) + arg1;
    if (arg2)
    {
        _val += (cam_x - obj_mainmenu_controller.cam_x);
    }
    return _val;
};

draw_border_line = function(arg0, arg1, arg2)
{
    var _yy1 = arg1;
    var _yy2 = arg2;
    var _x1 = border_y_to_x(_yy1, arg0);
    var _x2 = border_y_to_x(_yy2, arg0);
    draw_set_color(c_black);
    draw_line_width(_x1, _yy1, _x2, _yy2, 3);
    draw_set_color(c_white);
};

transition_direction = 1;
screen_transition = 0;

do_transition_anim = function(arg0)
{
    sfx_play(snd_css_pageturn, undefined, undefined, undefined, random_range(0.9, 1.1));
    transition_direction = arg0;
    screen_transition = 0;
};

var pixels_per_frame = 18;
char_box_seperation = 70;
screen_transition_time = 25;
bg_sf_size = [470, 270];
bg_origin = [100, 0];

save = function()
{
    global.css_save = 
    {
        charnum: character_num,
        mode: game_mode,
        saved_settings: character_settings_save,
        selected_settings: 
        {
            settings: character.settings,
            preset: character.settings_preset
        }
    };
};

load = function()
{
    if (variable_global_exists("css_save"))
    {
        character_num = global.css_save.charnum;
        game_mode = global.css_save.mode;
        character_settings_save = global.css_save.saved_settings;
        init();
        character.settings = global.css_save.selected_settings.settings;
        character.settings_preset = global.css_save.selected_settings.preset;
        var _me = self;
        with (obj_mainmenu_controller)
        {
            if (active_menu != -1 && menu_transition_time == 1)
            {
                start_menu_transition(_me, 0, 1);
            }
        }
        return true;
    }
    return false;
};

init = function()
{
    switch_selected_character(character_num);
    screen_transition = 1;
    game_mode_fade_anim = 1;
};

switch_selected_character = function(arg0)
{
    var prev_character_num = character_num;
    var charcount = array_length(characters);
    if (arg0 < 0)
    {
        arg0 += charcount;
    }
    if (arg0 >= charcount)
    {
        arg0 -= charcount;
    }
    character_num = arg0;
    if (surface_exists(prev_character.background_sf))
    {
        surface_free(prev_character.background_sf);
    }
    prev_character = character;
    if (can_save_settings)
    {
        character_settings_save[prev_character_num] = 
        {
            preset: prev_character.settings_preset,
            settings: prev_character.settings
        };
    }
    character = new characters[character_num]();
    character.background_sf = surface_create(470, 270);
    if (character_settings_save[character_num] != 0)
    {
        var _savedsettings = character_settings_save[character_num];
        character.settings_preset = _savedsettings.preset;
        character.settings = _savedsettings.settings;
    }
    update_selected_character_game_mode();
    obj_mainmenu_controller.mmbg_args.things_sprite = character.mmbgthings_spr;
    obj_mainmenu_controller.mmbg_args.things_image_index = character.mmbgthings_ind;
    obj_mainmenu_controller.mmbg_args.blend_things_sprite = prev_character.mmbgthings_spr;
    obj_mainmenu_controller.mmbg_args.blend_things_image_index = prev_character.mmbgthings_ind;
    obj_mainmenu_controller.mmbg_args.things_blend_amount = 0;
    if (prev_character.settings.mode != character.settings.mode)
    {
        prev_game_mode = prev_character.settings.mode;
        game_mode_anim = 0;
    }
    game_mode_fade_anim = 0;
    prev_mode_was_prev_char = true;
    if (showing_steam_leaderboard)
    {
        steam_leaderboard.local_leaderboard_preset = character.settings_preset;
        steam_leaderboard.leaderboard_display_name = character.get_leaderboard_display_name();
    }
};

update_selected_character_game_mode = function()
{
    if (array_contains(character.allowed_modes, game_mode))
    {
        character.settings.mode = game_mode;
    }
    if (!array_contains(character.allowed_modes, character.settings.mode))
    {
        character.settings.mode = character.allowed_modes[0];
    }
};

switch_game_mode = function()
{
    if (array_length(character.allowed_modes) > 1)
    {
        var _prev = game_mode;
        game_mode = abs(game_mode - 1);
        prev_game_mode = _prev;
        game_mode_anim = 0;
        update_selected_character_game_mode();
        prev_mode_was_prev_char = false;
    }
};

showing_steam_leaderboard = false;
steam_leaderboard = -1;

open_steam_leaderboard = function()
{
    can_click = false;
    showing_steam_leaderboard = true;
    var steam_leaderboard_id = character.get_steam_leaderboard_name();
    var local_leaderboard_id = character.local_leaderboard_id;
    var local_leaderboard_preset = character.settings_preset;
    steam_leaderboard = new leaderboard_menu_constructor(steam_leaderboard_id, local_leaderboard_id, local_leaderboard_preset);
    steam_leaderboard.x = 480 - steam_leaderboard.width - 3;
    steam_leaderboard.request_list();
    steam_leaderboard.close_func = close_steam_leaderboard;
    steam_leaderboard.leaderboard_display_name = character.get_leaderboard_display_name();
};

close_steam_leaderboard = function()
{
    can_click = true;
    showing_steam_leaderboard = false;
    steam_leaderboard.free();
};

settings_menu = new options_menu_constructor(false);

open_settings_menu = function()
{
    can_click = false;
    settings_menu_open = true;
};

close_settings_menu = function()
{
    settings_menu_open = false;
    can_click = true;
};

settings_menu.on_exit = function()
{
    close_settings_menu();
};

settings_menu.width -= 30;
settings_menu.draw_time_screen_0 = false;
settings_menu.x = 480 - settings_menu.width - 3 - 3;
settings_menu_open = false;
if (!load())
{
    init();
}
can_save_settings = true;

set_pagebtns_pos = function()
{
    pagebtns_x = (411 + cam_x) - obj_mainmenu_controller.cam_x;
    pagebtns_y = 61;
};

set_pagebtns_pos();
pagebtn = [[89, 51, 52, 27, 85, 10], [31, 69, 68, 92, 34, 110]];
for (var i = 0; i < array_length(pagebtn); i++)
{
    for (var j = 0; j < array_length(pagebtn[i]); j += 2)
    {
        pagebtn[i][j] -= 60;
        pagebtn[i][j + 1] -= 60;
    }
}
cur_hover = false;
click = false;
can_click = true;
text = 
{
    title: strloc("menus/character_select/title"),
    mode_endless: strloc("menus/character_select/mode_endless"),
    mode_standard: strloc("menus/character_select/mode_standard")
};

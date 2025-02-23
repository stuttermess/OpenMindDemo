dev_mode = true;
instance_create_depth(0, 0, 0, version_controller);
dev_mode = dev_mode && version_controller.build_type == 1;
version = version_controller.get_version_string();
display_set_gui_size(480, 270);
window_enable_borderless_fullscreen(true);

get_max_screen_size = function()
{
    max_screen_size = max(round(min(display_get_width() / 480, display_get_height() / 270)), 1);
    return max_screen_size;
};

get_default_screen_size = function()
{
    default_screen_size = ceil(get_max_screen_size() * 0.75);
    if (default_screen_size > 1 && (480 * default_screen_size) == display_get_width())
    {
        default_screen_size -= 1;
    }
    return default_screen_size;
};

settings_window_scale = -1;
window_scale = -1;

set_screen_size = function(arg0 = -1)
{
    var _is_default = arg0 == -1;
    arg0 = round(arg0);
    var max_size = get_max_screen_size();
    if (arg0 <= 0)
    {
        arg0 = get_default_screen_size();
    }
    var centered = variable_instance_exists(id, "window_scale");
    arg0 = clamp(arg0, 1, max_size - 1);
    var window_x, scale_change, window_y;
    if (centered)
    {
        scale_change = arg0 - window_scale;
        window_x = window_get_x();
        window_y = window_get_y();
    }
    window_scale = arg0;
    settings_window_scale = arg0;
    if (_is_default)
    {
        settings_window_scale = -1;
    }
    window_set_size(480 * arg0, 270 * arg0);
    if (centered)
    {
        window_set_position(window_x - (240 * scale_change), window_y - (135 * scale_change));
    }
    if (is_debug_overlay_open())
    {
        show_debug_overlay(true, false, window_scale * 0.5);
    }
};

surface_resize(application_surface, 480, 270);
var lang_folder = working_directory + "loc/en/";
var json = file_text_to_string(lang_folder + "lang.json");
lang = json_parse(json);
draw_set_font(fnt_pixel);
gpu_set_texrepeat(true);
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_color();
vertex_format_add_texcoord();
obj_vertex_format = vertex_format_end();
click = 0;
click_x = 0;
click_y = 0;
mouselock_bool = false;
mouselock = false;
mouselock_before = false;
game_focused = true;
do_mainmenu_flash = false;
window_set_cursor(cr_none);
game_ending = false;
restarting = false;

_restart_game = function()
{
    restarting = true;
    game_restart();
};

default_story_flags = 
{
    version: 0,
    room_id: 0,
    cuscene_name: "cs_0_1",
    _0: {},
    tutorial: 
    {
        minigames: 
        {
            basics: 0
        },
        lobby: 
        {
            basics: 0,
            leave_reminder: 0
        }
    }
};
story_flags = struct_copy(default_story_flags);
story_file_num = 0;
story_profile = "profile0";
default_settings = 
{
    vol_sfx: 50,
    vol_music: 50,
    vol_master: 50,
    local_scores_from_all_profiles: false,
    window_scale: -1,
    fullscreen: false,
    start_fullscreen: false,
    mouselock: 0,
    key_ghosting_compensation: false,
    mute_on_lose_focus: true,
    pause_on_lose_focus: true
};
default_profile_stats = 
{
    seen_opening: 0,
    playtime: 0
};
settings = struct_copy(default_settings);
current_profile = "profile0";
base_profile = 
{
    name: "",
    storyfiles: [],
    unlocks: 
    {
        mind_select_menu: false,
        mind_select: 
        {
            sparkle: false,
            shuffle: false
        }
    },
    played_characters: 
    {
        tutorial: false,
        sparkle: false
    },
    settings: default_settings,
    stats: default_profile_stats
};
profile = struct_copy(base_profile);
stats = profile.stats;
var info_path = "info.json";

initial_load = function()
{
    var info_path = "info.json";
    if (file_exists(info_path))
    {
        var _baseinfo = json_parse(file_text_to_string(info_path));
        current_profile = _baseinfo.current_profile;
        profile_load(current_profile);
    }
    else
    {
        var _name = "";
        if (steam_initialised() && 0)
        {
            _name = 0;
        }
        else
        {
            _name = "Profile 1";
        }
        var _new_profile_path = current_profile;
        current_profile = _new_profile_path;
        var _infofile = file_text_open_write("info.json");
        file_text_write_string(_infofile, json_stringify(
        {
            current_profile: current_profile,
            game_version: 0
        }));
        file_text_close(_infofile);
        if (file_exists(_new_profile_path + "/" + info_path))
        {
            profile_load(current_profile);
        }
        else
        {
            profile_create(_new_profile_path, _name, settings);
        }
    }
    after_profile_load();
};

timestamp_for_playtime = current_time;

after_profile_load = function()
{
    mouselock_bool = settings.mouselock == 0;
    settings_window_scale = settings.window_scale;
    set_screen_size(settings_window_scale);
};

initial_load();
allow_fullscreen_switch = true;
prev_fullscreen = false;
focus_volume = 1;
if (settings.vol_music < 1)
{
    settings.vol_music *= 100;
}
if (settings.vol_sfx < 1)
{
    settings.vol_sfx *= 100;
}
emit_mus = audio_emitter_create();
audio_emitter_gain(emit_mus, settings.vol_music);
emit_sfx = audio_emitter_create();
audio_emitter_gain(emit_sfx, settings.vol_sfx);
endless_scores = local_endless_scores_load(current_profile);
profile_save();
input_allowed_keys = ds_list_create();
input_key_names = ds_map_create();
var _keys_str = "QWERTYUIOPASDFGHJKLZXCVBNM0123456789";
for (var i = 1; i <= string_length(_keys_str); i++)
{
    var _char = string_char_at(_keys_str, i);
    var _ord = ord(_char);
    ds_list_add(input_allowed_keys, _ord);
    ds_map_add(input_key_names, _ord, _char);
}
var _vks = [32, 38, 37, 40, 39];
var vk_names = ["space", "up", "left", "down", "right"];
for (var i = 0; i < array_length(_vks); i++)
{
    var _ord = _vks[i];
    ds_list_add(input_allowed_keys, _ord);
    ds_map_add(input_key_names, _ord, vk_names[i]);
}
default_input_keys_check = ds_list_create();
ds_list_add(default_input_keys_check, "space", "up", "left", "down", "right", "any");
input_keys_check = ds_list_create();
ds_list_copy(input_keys_check, default_input_keys_check);
RFX_init(0.01, sprite_get_texture(spr_DitherPattern, 0), 128);
randomize();
switch (version_controller.build_type)
{
    case 3:
        instance_create_depth(0, 0, 0, eventdemo_controller);
        instance_create_depth(0, 0, 0, obj_mainmenu_controller);
        break;
    default:
        play_cutscene(cs_bootintro);
        break;
}
window_center();
pal_swap_init_system(shd_pal_swapper);
global.fnt_quickscore = font_add_sprite(spr_fnt_quickscore, 48, false, -2);
global.fnt_endlessresults = font_add_sprite(spr_fnt_endlessresults, 48, false, 0);
leaderboard_request = -1;
leaderboard_request_struct = -1;
leaderboard_tab = "";
leaderboards = {};
leaderboard_upload_id = -1;
steam_avatars = {};
ditherOn = false;
dither_dark = 0;
dither_light = 16777215;
debug_vars = 
{
    main_menu_bg_only: false,
    disable_mmbg_figments: false,
    storyflag_name: "",
    storyflag_value: "",
    storyflag_display: "0"
};
dbg_view("General", false);
dbg_section("Options");
dbg_slider(ref_create(settings, "vol_music"), 0, 100, "Music");
dbg_slider(ref_create(settings, "vol_sfx"), 0, 100, "SFX");
dbg_section("Controls");
dbg_button("Restart Game", _restart_game);
dbg_button("Toggle MMBG Only", function()
{
    debug_vars.main_menu_bg_only = !debug_vars.main_menu_bg_only;
});
dbg_button("Toggle MMBG Figments", function()
{
    debug_vars.disable_mmbg_figments = !debug_vars.disable_mmbg_figments;
});
dbg_section("Story");
dbg_text("Set Story Flag");
dbg_text_input(ref_create(debug_vars, "storyflag_name"), "flag name");
dbg_watch(ref_create(debug_vars, "storyflag_display"), "current flag value");
dbg_text_input(ref_create(debug_vars, "storyflag_value"), "new flag value");
dbg_button("Set", function()
{
    set_story_flag(debug_vars.storyflag_name, debug_vars.storyflag_value);
});
dbg_section("1bit Shader");
dbg_checkbox(ref_create(self, "ditherOn"), "Active");
dbg_color(ref_create(self, "dither_dark"), "Dark Color");
dbg_color(ref_create(self, "dither_light"), "Light Color");
show_debug_overlay(false);

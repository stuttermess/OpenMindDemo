lobby_id = lobby_groundfloor;
lobby = {};
depth = 100;

sprite_constructor = function() constructor
{
    x = 0;
    y = 0;
    depth = 0;
    sprite_index = -1;
    image_index = 0;
    image_speed = 1;
    zone_coord_type = 0;
    interact_zone = [];
    
    interact_func = function()
    {
    };
};

active = false;
sprite_hover = false;
ui_space_frame = 0;
logmenu = false;
logmenu_obj = new dialogue_log_constructor();
logmenu_prog = 1;
logmenu_intro = true;
dialogue_log = [];
logmenu_obj.list = dialogue_log;

logmenu_obj._on_close = function()
{
    logmenu = false;
    if (instance_exists(cutscene_controller))
    {
        if (cutscene_controller.cutscene.current_event._event_type == 1)
        {
            if (cutscene_controller.cutscene.current_event.allow_player_input)
            {
                cutscene_controller.cutscene.current_event.paused = false;
            }
        }
    }
};

talkmenu_force_open = false;
talkmenu = false;
talkmenu_prog = 1;
talkmenu_button_hover = 0;
talkmenu_button_frame = 0;
spacebar_mook_or_megalo_mode = 1;
dialoguepause = false;
pausemenu = false;
pausemenu_prog = 1;
pausemenu_button_hover = -1;
pausemenu_obj = new story_pause_menu_constructor();
pausemenu_obj.quit_mode = 1;

pausemenu_obj.on_resume_click = function()
{
    pausemenu = false;
    pausemenu_prog = 1 - pausemenu_prog;
};

pausemenu_obj.on_quit_click = function()
{
    quit_to_menu();
};

cursor_x = 0;
cursor_y = 0;
music_bus = audio_bus_create();
audio_emitter_bus(master.emit_mus, music_bus);
pause_effect = audio_effect_create(AudioEffectType.LPF2);
pause_effect.cutoff = 50000;
music_bus.effects[0] = pause_effect;
music = audio_play_sound_on(master.emit_mus, mus_lobby0, true, 10);

initialize_lobby = function(arg0 = lobby_id)
{
    lobby_id = arg0;
    lobby = new lobby_id();
    lobby._init();
};

quitting = false;

quit_to_menu = function()
{
    if (!quitting)
    {
        audio_sound_gain(music, 0, 1000);
        audio_sound_end_on_fade(music);
        start_transition_perlin(function()
        {
            audio_stop_sound(obj_lobby_controller.music);
            instance_destroy(obj_lobby_controller);
            instance_destroy(cutscene_controller);
            var _mm = instance_create_depth(0, 0, 0, obj_mainmenu_controller);
            audio_sound_gain(_mm.music, 0, 0);
            audio_sound_gain(_mm.music, 1, 1000);
            audio_sound_set_track_position(_mm.music, audio_sound_get_track_position(_mm.music) + random_range(4, 20));
        });
    }
};

if (instance_number(object_index) > 1)
{
    instance_destroy();
}

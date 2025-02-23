function play_mainmenu_music_from_cutscene()
{
    global.main_menu_music = audio_play_sound_on(master.emit_mus, mus_mainmenu, true, 100, 1, 0);
    if (instance_exists(cutscene_controller))
    {
        with (cutscene_controller.cutscene.current_event)
        {
            if (_event_type == 0)
            {
                array_push(pause_sounds, global.main_menu_music);
            }
        }
    }
}

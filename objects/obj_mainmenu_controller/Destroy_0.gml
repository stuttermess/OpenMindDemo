if (audio_is_playing(music))
{
    global.mainmenu_muspos_save = audio_sound_get_track_position(music);
    audio_stop_sound(music);
}

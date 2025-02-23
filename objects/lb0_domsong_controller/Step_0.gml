if (!instance_exists(obj_lobby_controller))
{
    audio_stop_sound(song);
    instance_destroy();
}
if (dialogue_controller == -1)
{
    exit;
}
var paused = false;
var _dialogue_paused = dialogue_controller.pause_menu.active || obj_lobby_controller.logmenu;
if (audio_is_paused(song))
{
    if (_dialogue_paused)
    {
        paused = true;
    }
    else
    {
        audio_resume_sound(song);
    }
}
else if (_dialogue_paused)
{
    audio_pause_sound(song);
    paused = true;
}
if (paused)
{
    exit;
}
var songlength = audio_sound_length(mus_dom_song);
t++;
if ((t % round((songlength / event_length) * 60)) == 0)
{
    dialogue_controller.next_event();
}
var _dt = delta_time / 1000000;
if (_dt >= 0.06 && (t / 60) < songlength)
{
    if (!audio_is_playing(song))
    {
        song = sfx_play(mus_dom_song, false, 1, t / 60, 1, true);
    }
    else
    {
        audio_sound_set_track_position(song, t / 60);
    }
}

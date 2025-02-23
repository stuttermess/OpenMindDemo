var _seq = cutscene_controller.cutscene.current_event.sequence;
var _seqpaused = layer_sequence_is_paused(_seq);
if (_seqpaused != paused)
{
    paused = _seqpaused;
    if (paused)
    {
        audio_pause_sound(sound);
    }
    else
    {
        audio_resume_sound(sound);
    }
}
if (!active)
{
    exit;
}
active = false;
if (!been_active)
{
    been_active = true;
    init();
}
var _seqpos = layer_sequence_get_headpos(_seq) / 60;
var _muspos = audio_sound_get_track_position(sound);
if (abs(_seqpos - _muspos) > 0.1)
{
    audio_sound_set_track_position(sound, _seqpos);
}
if (prev_alpha != image_alpha)
{
    prev_alpha = image_alpha;
    audio_sound_gain(sound, image_alpha, 0);
}

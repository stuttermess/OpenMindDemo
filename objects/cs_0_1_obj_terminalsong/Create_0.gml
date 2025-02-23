song = -1;
t = -1;
cutscene = instance_find(cutscene_controller, 0);

stop = function()
{
    audio_sound_gain(song, 0, 3000);
    audio_sound_end_on_fade(song);
    t = 180;
};

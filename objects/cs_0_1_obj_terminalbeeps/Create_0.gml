sound = -1;
t = -1;
cutscene = instance_find(cutscene_controller, 0);

stop = function()
{
    audio_sound_gain(sound, 0, 1000);
    audio_sound_end_on_fade(sound);
    t = 60;
};

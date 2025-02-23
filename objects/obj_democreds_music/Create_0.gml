sound = -1;
active = false;
paused = false;
been_active = false;
prev_alpha = 1;

init = function()
{
    sound = sfx_play(mus_endlessresults, false, image_alpha, 0, 1, true);
};

intro_script = -1;
intro = -1;
outro_script = -1;
outro = -1;
active = -1;

on_intro_end = function()
{
};

on_outro_end = function()
{
};

timer = 0;
pause_frames = 15;
pause_timer = 0;
finished = false;

start = function()
{
    if (intro_script != -1)
    {
        intro = new intro_script();
    }
    if (outro_script != -1)
    {
        outro = new outro_script();
    }
    if (intro_script == -1)
    {
        active = outro;
        if (active.reverse)
        {
            active._time = 1;
        }
        on_intro_end();
    }
    else
    {
        active = intro;
    }
    pause_timer = 0;
};

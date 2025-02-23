if (finished)
{
    instance_destroy();
    exit;
}
if (pause_timer == 0)
{
    if (active != -1)
    {
        active._time = timer / active.length;
        if (active.reverse)
        {
            active._time = 1 - active._time;
        }
        active._tick();
        timer++;
        if (timer > active.length)
        {
            if (active == intro)
            {
                pause_timer = pause_frames;
            }
            else
            {
                finished = true;
            }
        }
    }
    else
    {
        finished = true;
    }
}
else
{
    pause_timer--;
    if (pause_timer <= 0)
    {
        on_intro_end();
        timer = 0;
        pause_timer = 0;
        if (outro == -1)
        {
            finished = true;
        }
        else
        {
            active = outro;
            active._time = (timer - 1) / active.length;
            if (active.reverse)
            {
                active._time = 1 - active._time;
            }
        }
    }
}
if (finished)
{
    on_outro_end();
    instance_destroy();
}

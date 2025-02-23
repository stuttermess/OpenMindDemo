if (!active)
{
    exit;
}
if (cutscene_controller.cutscene.current_event.user_paused)
{
    exit;
}
if (t >= 105)
{
    mwsc.tick();
}
ditherfade = value_from_keyframes(fadein_keyframes, t);
t++;

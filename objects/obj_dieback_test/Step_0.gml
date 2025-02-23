exit;
instance.tick();
if (keyboard_check_pressed(ord("O")))
{
    visible = !visible;
    if (!visible)
    {
        instance.cleanup();
    }
}

if (lobby_id != -1)
{
    cursor_x = clamp(mouse_x, 0, 480);
    cursor_y = clamp(mouse_y, 0, 270);
    var crx = cursor_x;
    var cry = cursor_y;
    with (lobby)
    {
        _draw();
    }
}

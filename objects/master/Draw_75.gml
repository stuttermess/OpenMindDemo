if (steam_initialised() && steam_is_screenshot_requested())
{
    screen_save("screenshot.png");
    steam_send_screenshot("screenshot.png", window_get_width(), window_get_height());
}

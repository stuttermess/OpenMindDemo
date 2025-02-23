function open_url(arg0)
{
    if (steam_initialised())
    {
        steam_activate_overlay_browser(arg0);
    }
    else
    {
        url_open_ext(arg0 + "/", "_blank");
    }
}

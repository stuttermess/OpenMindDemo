function cam2d_create()
{
    cam2dw = get_screen_width();
    cam2dh = get_screen_height();
    view_visible[99] = true;
    view_camera[99] = camera_create_view(0, 0, cam2dw, cam2dh);
    return view_camera[99];
}

function cam2d_drawstart()
{
    camera_apply(view_camera[99]);
}

function cam2d_drawend()
{
    if (camera_get_active() != view_camera[0])
    {
        view_visible[99] = false;
        view_enabled = false;
    }
}

function cam2d_get_view()
{
    return view_camera[99];
}

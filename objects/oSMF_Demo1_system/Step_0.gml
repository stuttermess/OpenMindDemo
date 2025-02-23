var timeStep = (delta_time * 60) / 1000000;
camUpdateTimer += timeStep;
if (camUpdateTimer >= 1 || fps < 70)
{
    var mousedx = window_mouse_get_x() - (window_get_width() / 2);
    var mousedy = window_mouse_get_y() - (window_get_height() / 2);
    window_mouse_set(window_get_width() / 2, window_get_height() / 2);
    camUpdateTimer = 0;
    camYaw += (mousedx * 0.1);
    camPitch = clamp(camPitch - (mousedy * 0.1), -80, -2);
}
var d = 40;
var camX = -d * dcos(camYaw) * dcos(camPitch);
var camY = -d * dsin(camYaw) * dcos(camPitch);
var camZ = -d * dsin(camPitch);
camera_set_view_mat(view_camera[0], matrix_build_lookat(camX, camY, camZ, 0, 0, 7, 0, 0, 1));
mainInst.step(timeStep);

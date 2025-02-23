event_inherited();
gpu_set_tex_mip_enable(1);
game_set_speed(9999, gamespeed_fps);
view_enabled = true;
view_visible[0] = true;
view_set_camera(0, camera_create());
camera_set_proj_mat(view_camera[0], matrix_build_projection_perspective_fov(-60, -window_get_width() / window_get_height(), 1, 32000));
window_mouse_set(window_get_width() / 2, window_get_height() / 2);
camUpdateTimer = 0;
camPitch = 0;
camYaw = 0;
global.modDragon = smf_model_load_async("SMF/Dragon.smf");
mainInst = new smf_instance(global.modDragon);
mainInst.play("Flying", 0.02, 1, true);
mainInst.fast_sampling(true);

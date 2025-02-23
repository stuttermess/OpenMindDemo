if (sf == -1 || !surface_exists(sf))
{
    sf = surface_create(480, 270);
}
surface_set_target(sf);
draw_sprite(sqcs_0_2_8_spr_bg, 0, x, y);
draw_sprite(sqcs_0_2_8_spr_wave, 0, x, y);
surface_reset_target();
shader_set_wavy_texture(surface_get_texture(sf), t / 60, 0.25, 10, 6, 0.25, 10, 6);
draw_surface(sf, 0, 0);
shader_reset();
if (!cutscene_controller.cutscene.current_event.user_paused)
{
    t++;
}

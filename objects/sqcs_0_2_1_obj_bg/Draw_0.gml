var _xoff = -240;
var _yoff = -135;
if (sf == -1 || !surface_exists(sf))
{
    sf = surface_create(528, 297);
}
surface_set_target(sf);
draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, 0, c_white, 1);
surface_reset_target();
shader_set_wavy_texture(surface_get_texture(sf), t / 60, 0.25, 10, 6, 0.25, 10, 6);
draw_surface(sf, 240 - (surface_get_width(sf) / 2), 135 - (surface_get_height(sf) / 2));
shader_reset();
if (!cutscene_controller.cutscene.current_event.user_paused)
{
    t++;
}

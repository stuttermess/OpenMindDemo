shader_set_wavy_texture(sprite_get_texture(sprite_index, image_index), current_time / 1000, 0, 0, 0, 3.5, 40, 8);
draw_self();
shader_reset();

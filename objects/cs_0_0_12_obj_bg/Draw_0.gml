shader_set_wavy_texture(sprite_get_texture(sprite_index, image_index), time / 60, 1, 500, 8, 0, 0, 0);
x += 240;
y += 135;
draw_self();
x -= 240;
y -= 135;
shader_reset();
intensity += 0.015;
time++;

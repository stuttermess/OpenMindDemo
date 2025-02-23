shader_set_wavy(sprite_index, t, 0.1, 900, 1, 0, 0, 0);
draw_self();
shader_reset();
if (in_sequence)
{
    t = sequence_instance.headPosition;
}

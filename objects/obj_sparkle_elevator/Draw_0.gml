draw_clear(c_black);
shader_set_wavy(spr_sparkle_elevator_bg, current_time / 1000, 1, 1130, 3, 0, 0, 0);
draw_sprite(spr_sparkle_elevator_bg, 0, 240, 135);
shader_reset();
blendmode_set_addglow();
draw_sprite(spr_sparkle_elevator_bg, 1, 240, 135);
blendmode_reset();
if (!surface_exists(heads_sf))
{
    heads_sf = surface_create(480, 270);
}
surface_set_target(heads_sf);
draw_clear_alpha(c_black, 0);
shader_set_wavy_spriteframe(spr_sparkle_elevator_bg, 2, (current_time / 1000) + 600, 1.3, 500, 5, 0, 0, 0);
draw_sprite(spr_sparkle_elevator_bg, 2, 240, 135);
shader_reset();
surface_reset_target();
blendmode_set_add();
draw_surface(heads_sf, 0, 0);
blendmode_reset();
smf_instance_step(elevator, 1);
smf_instance_step(ear, 1);
smf_instance_step(doorOpen, 1);
start3d(1, xfrom, yfrom, zfrom, xto, yto, zto, fov, false);
z = -sin(animtimer / 32) / 10;
draw3dobject(240, 133.65, z, 0, 0, 0, 5, 5, 5, doorOpen, sh_smf_animate_flatshaded);
draw3dobject(240, 135, z * 2, 0, 0, 0, 5, 5, 5, speaker, sh_smf_animate_flatshaded);
draw3dobject(240, 135, z, 0, 0, 0, 5, 5, 5, elevator, sh_smf_animate_flatshaded);
draw3dobject(240, 135, z, 0, 0, 0, 5, 5, 5, door, sh_smf_animate_flatshaded);
draw3dobject(240, 135, z, 0, 0, 0, 5, 5, 5, bunny, sh_smf_animate_flatshaded);
draw3dobject(240, 139.2, z, 0, 0, 180, 5, 5, 5, ear, sh_smf_animate_flatshaded);
draw3dobject(240, 135, z, 0, 0, 0, 5, 5, 5, ear, sh_smf_animate_flatshaded);
end3d();

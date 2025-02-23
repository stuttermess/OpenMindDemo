if (!visible_before)
{
    sound = audio_play_sound_on(master.emit_mus, cs_0_1_snd_spaceout, true, 100);
    audio_sound_gain(sound, 1, 4000);
    audio_sound_gain(snd_crowd_loop, 0, 4000);
    start();
}
_visible = true;
invis_time = 0;
visible_before = true;
effect_muffle1.cutoff = lerp(muffle1_cutoff_high, muffle1_cutoff_low, clamp(t / muffle_time, 0, 1));
effect_muffle2.cutoff = lerp(muffle2_cutoff_high, muffle2_cutoff_low, clamp(t / muffle_time, 0, 1));
if (t == 0)
{
    with (cutscene_controller.cutscene.current_event)
    {
        tb_wavy = 1;
        tb_wavy_incspd = 0.016666666666666666;
    }
}
if (!cutscene_controller.cutscene.current_event.user_paused)
{
    t_inc = lerp(t_inc, 1, 0.05);
    t += t_inc;
}
var al = clamp(t / 4800, 0, 1);
var si = clamp(t / 960, 0, 1);
shader_set_wavy_spriteframe(sprite_index, image_index, t / 120, 1, 10, 10 * si, 0.7, 8, 7 * si);
image_alpha = 1;
image_index = 0;
draw_self();
image_alpha = al;
image_index = 1;
x -= 60;
draw_self();
x += 60;
shader_reset();
drawn_this_frame = true;

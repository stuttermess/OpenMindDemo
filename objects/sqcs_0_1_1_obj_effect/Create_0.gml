t = 0;
t_inc = 0;
start = false;
_visible = false;
invis_time = 0;
visible_before = false;
image_speed = 0;
sound = -1;
drawn_this_frame = false;
muffle_time = 480;
effect_muffle1 = audio_effect_create(AudioEffectType.LPF2);
muffle1_cutoff_high = 50000;
muffle1_cutoff_low = 500;
effect_muffle1.cutoff = muffle1_cutoff_high;
effect_muffle1.q = 1;
effect_muffle2 = audio_effect_create(AudioEffectType.HPF2);
muffle2_cutoff_high = 500;
muffle2_cutoff_low = 50000;
effect_muffle2.cutoff = muffle2_cutoff_high;
effect_muffle2.q = 1;
sfx_bus = audio_bus_create();

start = function()
{
    audio_emitter_bus(master.emit_sfx, sfx_bus);
    sfx_bus.effects[0] = effect_muffle1;
};

stop = function()
{
    sfx_bus.effects[0] = undefined;
    sfx_bus.effects[1] = undefined;
    audio_emitter_bus(master.emit_sfx, audio_bus_main);
};

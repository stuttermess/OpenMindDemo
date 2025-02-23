function charselect_tutorial() : charselect_character_constructor() constructor
{
    letterbox_color = 0;
    char_sprite = spr_charselect_tutorial;
    allowed_modes = [0];
    mmbgthings_spr = spr_mmbg_8stuff;
    mmbgthings_ind = 0;
    bg_scroll = 0;
    character_script = gamechar_tutorial;
    
    draw_background = function()
    {
        var _blend = gpu_get_blendenable();
        gpu_set_blendenable(true);
        bg_scroll = time;
        var bg_y = 0;
        var current_beat = 0;
        var tut_text_in = 1;
        var bg_alpha = 1;
        var xoff = 0;
        var yoff = 0;
        draw_clear(c_white);
        draw_sprite_tiled(ibtT_spr_bgthing2, 0, round(bg_scroll / 3) + xoff, round((bg_scroll / 3) + bg_y + yoff));
        draw_sprite_tiled(ibtT_spr_bgthing1, 0, bg_scroll + xoff, -bg_scroll + bg_y + yoff);
        draw_set_alpha(1 - bg_alpha);
        draw_rectangle(-1, -1, 481, 481, false);
        draw_set_alpha(1);
        draw_sprite_ext(ibtT_spr_title_tutorial, current_beat * 2, -55 + xoff, yoff + lerp(-100, 0, lerp_easeOutBack(tut_text_in)), 1, 1, 0, c_white, 0.7);
        gpu_set_blendenable(_blend);
    };
    
    name_sprite = spr_charselect_tutorial_name;
    name = "Tutorial";
    minigame_count = 5;
    array_delete(options_str, 1, 2);
    array_delete(options_str_original, 1, 2);
    array_delete(options_onclick, 1, 2);
    end_cutscene = new cs_0_2();
    end_cutscene.events = [end_cutscene.events[0]];
    var _cs = end_cutscene;
    
    _cs._on_finish = function()
    {
        audio_stop_all();
        var _tr = start_transition_perlin(on_game_exit);
        _tr.timer = _tr.active.length;
    };
    
    get_enter_transition = function()
    {
        var _tr = start_transition(transition_perlin);
        _tr.intro.color = 16777215;
        return _tr;
    };
    
    on_game_end = function()
    {
        audio_stop_all();
        instance_destroy(obj_minigame_controller);
        play_cutscene_struct(end_cutscene);
    };
}

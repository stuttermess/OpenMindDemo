function ibt_shuffle() : inbetween_constructor() constructor
{
    chosen_char = "generic";
    chosen_ibt = new inbetween_constructor();
    
    set_char_from_mg = function(arg0)
    {
        var _struct = character.minigame_chars;
        chosen_char = struct_get(_struct, arg0);
        return chosen_char;
    };
    
    set_ibt_from_char = function()
    {
        var _chosen_char_struct = struct_get(character.chars, chosen_char);
        chosen_ibt = _chosen_char_struct.inbetween;
        draws_minigame_surface = chosen_ibt.draws_minigame_surface;
        minigame_intro_length = chosen_ibt.minigame_intro_length;
        minigame_outro_length = chosen_ibt.minigame_outro_length;
        chosen_ibt.success_state = success_state;
        chosen_ibt._lives = _lives;
        chosen_ibt._round = _round;
    };
    
    __init = function()
    {
        chosen_char = "generic";
        set_ibt_from_char();
        var _names = struct_get_names(character.chars);
        for (var i = 0; i < array_length(_names); i++)
        {
            var _ibt = struct_get(character.chars, _names[i]).inbetween;
            _ibt.character = character;
            _ibt.__init();
        }
    };
    
    __on_return = function()
    {
        set_char_from_mg(instanceof(obj_minigame_controller.active_mgs[0]));
        set_ibt_from_char();
        set_ibt_vars();
        chosen_ibt.__on_return();
    };
    
    __tick = function()
    {
        set_ibt_vars();
        chosen_ibt.__tick();
        if (array_length(obj_minigame_controller.active_mgs) > 0)
        {
            var mg_instof = instanceof(obj_minigame_controller.active_mgs[0]);
            var _mg_char = struct_get(character.minigame_chars, mg_instof);
            var _chosen_char_struct = struct_get(character.chars, _mg_char);
            character.timer_script = _chosen_char_struct.timer;
        }
    };
    
    __draw = function()
    {
        set_ibt_vars();
        return chosen_ibt.__draw();
    };
    
    set_ibt_vars = function()
    {
        chosen_ibt.inbetween_timer = inbetween_timer;
        chosen_ibt.current_beat = current_beat;
        chosen_ibt.next_control_style = next_control_style;
    };
    
    _draw_control_prompt = function()
    {
        return chosen_ibt._draw_control_prompt();
    };
    
    get_inbetween_length = function(arg0)
    {
        return chosen_ibt.get_inbetween_length(arg0);
    };
    
    get_intro_jingle = function()
    {
        return chosen_ibt.get_intro_jingle();
    };
    
    get_win_jingle = function()
    {
        return chosen_ibt.get_win_jingle();
    };
    
    get_prep_jingle = function()
    {
        return chosen_ibt.get_prep_jingle();
    };
    
    get_lose_jingle = function()
    {
        return chosen_ibt.get_lose_jingle();
    };
    
    get_speedup_jingle = function()
    {
        return chosen_ibt.get_speedup_jingle();
    };
    
    get_boss_jingle = function()
    {
        return chosen_ibt.get_boss_jingle();
    };
}

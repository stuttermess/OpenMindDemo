mwsc = new mwsc_instance();
mwsc.type = 0;
mwsc.allow_ffwd = false;
mwsc.textbox.width = 115;
mwsc.textbox.halign = 1;
mwsc.textbox.valign = 1;
mwsc.add_custom_parse_func("dark", function(arg0)
{
    array_push(mwsc.events, ["dark"]);
});
mwsc.add_custom_script_event_func("dark", function(arg0)
{
    _end();
});
t = 0;
fadein_keyframes = [[0, 0, lerp], [30, 0, lerp], [90, 1, lerp]];
ditherfade = 0;
mwsc.load_script_file("scripts/sequence/0/3_monologue.mwsc");
mwsc.base_text_speed = 0.4;
mwsc.perform_current_event();
dark = false;
active = false;
ended = false;

_end = function()
{
    mwsc.allow_player_input = false;
    with (cutscene_controller.cutscene.current_event)
    {
        layer_sequence_headpos(sequence, loop_end_frame + 3);
        clear_loop();
    }
    audio_stop_all();
    _pressed = false;
    ended = true;
};

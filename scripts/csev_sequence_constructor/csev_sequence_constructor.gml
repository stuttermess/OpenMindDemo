function csev_sequence_constructor() : csev_base_constructor() constructor
{
    _event_type = 0;
    _cutscene_controller = -1;
    start_frame = 0;
    end_frame = infinity;
    sequence_id = -1;
    sequence = -1;
    sequence_layer = -1;
    sequence_layer_depth = 10;
    loop_start_frame = -1;
    loop_end_frame = -1;
    paused = false;
    markers = {};
    destroy_on_end = true;
    inserted_in_dialogue = -1;
    tb_auto = false;
    tb_display = 0;
    tb_show = false;
    tb_letter = 0;
    tb_speed = 0.5;
    inline_events = {};
    text_styles = {};
    _events = [];
    _script = [];
    current_event = -1;
    event_is_dialogue = false;
    next_event_on_frame = -1;
    pause_on_frame = -1;
    no_text_continue_until_frame = -1;
    tb_wavy = 0;
    tb_wavy_intensity = 0;
    tb_wavy_speed = 1;
    tb_wavy_frequency = 80;
    tb_wavy_size = 5;
    tb_wavy_incspd = 0;
    speaker_icon = -1;
    music_tracks = [];
    sfx_tracks = [];
    tb_str = "";
    tb_pause_until_line = -1;
    sq_loop_start = -1;
    sq_loop_end = -1;
    tb_animate = false;
    tb_auto = false;
    tb_auto_time = 120;
    skip = false;
    skippable = true;
    skip_frame = -1;
    skippable_after_skip_frame = true;
    skip_through = false;
    use_as_dialogue_background = false;
    pause_sounds = [];
    mwsc = new mwsc_instance();
    mwsc.parent = self;
    mwsc.type = 2;
    mwsc.allow_ffwd = false;
    mwsc.add_custom_parse_func("clear", function(arg0)
    {
        array_push(mwsc.events, ["clear"]);
    });
    mwsc.add_custom_script_event_func("clear", function(arg0)
    {
        mwsc.current_letter = 0;
        mwsc.text = "";
        mwsc.inline_events = {};
        mwsc.text_styles = {};
    });
    mwsc.add_custom_parse_func("text_auto", function(arg0)
    {
        arg0 = arg0.args;
        array_push(mwsc.events, ["text_auto", real(arg0[1])]);
    });
    mwsc.add_custom_script_event_func("text_auto", function(arg0)
    {
        var _ev = arg0.args;
        tb_auto = real(_ev[1]);
    });
    mwsc.add_custom_parse_func("wait", function(arg0)
    {
        arg0 = arg0.args;
        if (arg0[1] == "for")
        {
            switch (arg0[2])
            {
                case "frame":
                    array_push(mwsc.events, ["wait", real(arg0[3])]);
                    break;
                case "marker":
                    var _marker_name = arg0[3];
                    var _marker = struct_get(markers, _marker_name);
                    if (!is_undefined(_marker))
                    {
                        var _marker_frame = _marker.frame;
                        array_push(mwsc.events, ["wait", _marker_frame]);
                    }
                    break;
            }
        }
    });
    mwsc.add_custom_script_event_func("wait", function(arg0)
    {
        var _ev = arg0.args;
        next_event_on_frame = _ev[1];
        mwsc.script_event.do_next_event = false;
    });
    mwsc.add_custom_parse_func("pause", function(arg0)
    {
        arg0 = arg0.args;
        if (array_length(arg0) > 1 && arg0[1] == "at")
        {
            switch (arg0[2])
            {
                case "frame":
                    array_push(mwsc.events, ["pause", real(arg0[3])]);
                    break;
                case "marker":
                    var _marker_name = arg0[3];
                    var _marker = struct_get(markers, _marker_name);
                    if (!is_undefined(_marker))
                    {
                        var _marker_frame = _marker.frame;
                        array_push(mwsc.events, ["pause", _marker_frame]);
                    }
                    break;
            }
        }
        else
        {
            array_push(mwsc.events, ["pause", -1]);
        }
    });
    mwsc.add_custom_script_event_func("pause", function(arg0)
    {
        var _ev = arg0.args;
        pause_on_frame = _ev[1];
        if (pause_on_frame == -1)
        {
            _pause();
        }
    });
    mwsc.add_custom_parse_func("resume", function(arg0)
    {
        array_push(mwsc.events, ["resume"]);
    });
    mwsc.add_custom_script_event_func("resume", function(arg0)
    {
        _resume();
        pause_on_frame = -1;
    });
    mwsc.add_custom_parse_func("jump", function(arg0)
    {
        arg0 = arg0.args;
        if (array_length(arg0) >= 4)
        {
            if (arg0[1] == "to")
            {
                switch (arg0[2])
                {
                    case "frame":
                        array_push(mwsc.events, ["jump", real(arg0[3])]);
                        break;
                    case "marker":
                        var _marker_name = arg0[3];
                        var _marker = struct_get(markers, _marker_name);
                        if (!is_undefined(_marker))
                        {
                            var _marker_frame = _marker.frame;
                            array_push(mwsc.events, ["jump", _marker_frame]);
                        }
                        break;
                }
            }
        }
        else
        {
            array_push(mwsc.events, ["skip_event"]);
        }
    });
    mwsc.add_custom_script_event_func("jump", function(arg0)
    {
        var _ev = arg0.args;
        layer_sequence_headpos(sequence, _ev[1]);
    });
    mwsc.add_custom_parse_func("loop", function(arg0)
    {
        arg0 = arg0.args;
        switch (array_length(arg0))
        {
            case 4:
                var evname = "set_loop_" + string(arg0[1]);
                switch (arg0[2])
                {
                    case "frame":
                        array_push(mwsc.events, [evname, real(arg0[3])]);
                        break;
                    case "marker":
                        var _marker_name = arg0[3];
                        var _marker = struct_get(markers, _marker_name);
                        if (!is_undefined(_marker))
                        {
                            var _marker_frame = _marker.frame;
                            array_push(mwsc.events, [evname, _marker_frame]);
                        }
                        break;
                }
                break;
            case 2:
                if (arg0[1] == "clear")
                {
                    array_push(mwsc.events, ["clear_loop"]);
                }
                break;
        }
    });
    mwsc.add_custom_script_event_func("set_loop_start", function(arg0)
    {
        var _ev = arg0.args;
        loop_start_frame = _ev[1];
    });
    mwsc.add_custom_script_event_func("set_loop_end", function(arg0)
    {
        var _ev = arg0.args;
        loop_end_frame = _ev[1];
    });
    mwsc.add_custom_script_event_func("clear_loop", function(arg0)
    {
        var _ev = arg0.args;
        clear_loop();
    });
    mwsc.add_custom_parse_func("no_text_continue_until", function(arg0)
    {
        arg0 = arg0.args;
        if (array_length(arg0) >= 3)
        {
            switch (arg0[1])
            {
                case "frame":
                    array_push(mwsc.events, ["no_text_continue_until", real(arg0[2])]);
                    break;
                case "marker":
                    var _marker_name = arg0[2];
                    var _marker = struct_get(markers, _marker_name);
                    if (!is_undefined(_marker))
                    {
                        var _marker_frame = _marker.frame;
                        array_push(mwsc.events, ["no_text_continue_until", _marker_frame]);
                    }
                    break;
            }
        }
    });
    mwsc.add_custom_script_event_func("no_text_continue_until", function(arg0)
    {
        var _ev = arg0.args;
        no_text_continue_until_frame = _ev[1];
    });
    mwsc.add_custom_parse_func("text_wavy", function(arg0)
    {
        arg0 = arg0.args;
        if (array_length(arg0) >= 3)
        {
            var _amt = real(arg0[1]);
            var _time = real(arg0[2]);
            array_push(mwsc.events, ["text_wavy", _amt, _time]);
        }
    });
    mwsc.add_custom_script_event_func("text_wavy", function(arg0)
    {
        var _ev = arg0.args;
        var _amt = _ev[1];
        var _time = _ev[2];
        tb_wavy = _amt;
        tb_wavy_incspd = 1 / _time;
    });
    mwsc.add_custom_parse_func("speaker_icon", function(arg0)
    {
        arg0 = arg0.args;
        var _charname = arg0[1];
        switch (_charname)
        {
            case "none":
                array_push(mwsc.events, ["speaker_icon", -1]);
                break;
            default:
                var _spr = asset_get_index("spr_sqspeakerhead_" + _charname);
                if (_spr == -1)
                {
                    array_push(mwsc.events, ["skip_event"]);
                }
                else
                {
                    array_push(mwsc.events, ["speaker_icon", _spr]);
                }
                break;
        }
    });
    mwsc.add_custom_script_event_func("speaker_icon", function(arg0)
    {
        var _ev = arg0.args;
        speaker_icon = _ev[1];
    });
    mwsc.add_custom_parse_func("speaker_voice", function(arg0)
    {
        arg0 = arg0.args;
        array_push(mwsc.events, ["speaker_voice", arg0[1]]);
    });
    mwsc.add_custom_script_event_func("speaker_voice", function(arg0)
    {
        var _ev = arg0.args;
        var _voice = _ev[1];
        var _script = charvoice_none;
        var _testscript = asset_get_index("charvoice_" + _voice);
        if (_testscript != -1 && script_exists(_testscript))
        {
            _script = _testscript;
        }
        else
        {
            switch (_voice)
            {
                case "none":
                case "clear":
                    _script = charvoice_none;
                    break;
                case "default":
                case "normal":
                    _script = charvoice_default;
                    break;
                case "pandora":
                    _script = charvoice_pandora;
                    break;
                case "smalls":
                    _script = charvoice_smalls;
                    break;
                case "announcer":
                    _script = charvoice_announcer;
                    break;
                case "abbie":
                    _script = charvoice_abbie;
                    break;
            }
        }
        if (script_exists(_script))
        {
            mwsc.text_voice = new _script();
        }
    });
    
    _script_to_events = function()
    {
        _get_markers();
        mwsc.script = _script;
        mwsc.script_to_events();
    };
    
    _init = function()
    {
        volumes_set = false;
        volumes_prev_track_length = -1;
        _play();
        mwsc.perform_current_event();
        
        pause_menu.on_resume_click = function()
        {
            _user_set_pause(false);
        };
    };
    
    past_first_frame = false;
    
    _tick = function()
    {
        _set_volumes();
        var _dt = delta_time / 1000000;
        if (_dt >= 0.08)
        {
            layer_sequence_headpos(sequence, layer_sequence_get_headpos(sequence));
        }
        var seq_frame = layer_sequence_get_headpos(sequence);
        past_first_frame = past_first_frame || seq_frame > 0;
        if (!user_paused)
        {
            mwsc.allow_text_continue = mwsc.text != "" && !tb_auto && seq_frame >= no_text_continue_until_frame;
            mwsc.allow_player_input = !tb_auto;
            mwsc.tick();
            mwsc.allow_text_continue = mwsc.text != "" && !tb_auto && seq_frame >= no_text_continue_until_frame;
            if (seq_frame >= no_text_continue_until_frame && no_text_continue_until_frame >= 0)
            {
                no_text_continue_until_frame = -1;
            }
            if (loop_start_frame != -1 && loop_end_frame != -1)
            {
                if (seq_frame >= loop_end_frame || layer_sequence_is_finished(sequence))
                {
                    var diff = seq_frame - loop_end_frame;
                    seq_frame = loop_start_frame + 1 + diff;
                    layer_sequence_headpos(sequence, seq_frame);
                }
            }
            if (seq_frame >= next_event_on_frame && next_event_on_frame >= 0)
            {
                next_event_on_frame = -1;
                mwsc.next_event();
            }
            if (seq_frame >= pause_on_frame && pause_on_frame >= 0)
            {
                _pause();
                pause_on_frame = -1;
            }
            if (seq_frame >= no_text_continue_until_frame && no_text_continue_until_frame >= 0)
            {
                no_text_continue_until_frame = -1;
            }
            if (tb_wavy_intensity != tb_wavy)
            {
                if (abs(tb_wavy - tb_wavy_intensity) < tb_wavy_incspd)
                {
                    tb_wavy_intensity = tb_wavy;
                }
                else
                {
                    tb_wavy_intensity += (sign(tb_wavy - tb_wavy_intensity) * tb_wavy_incspd);
                }
            }
        }
        if (get_skip_input())
        {
            skip = true;
        }
        else if (get_pause_input())
        {
            if (!user_paused)
            {
                if (!(layer_sequence_is_finished(sequence) || layer_sequence_get_headpos(sequence) >= end_frame))
                {
                    _user_set_pause(!user_paused);
                }
            }
        }
        if (!user_paused && _cutscene_controller != -1)
        {
            if (sequence != -1 && ((layer_sequence_is_finished(sequence) || (skip && skippable) || layer_sequence_get_headpos(sequence) >= end_frame) && loop_end_frame == -1))
            {
                var _isdiag = false;
                var _nextev = true;
                var _destroy_sequence = true;
                if (use_as_dialogue_background)
                {
                    with (_cutscene_controller)
                    {
                        if ((current_event_id + 1) < (array_length(events) - 1))
                        {
                            var newev = events[current_event_id + 1];
                            if (newev._event_type == 1)
                            {
                                _isdiag = true;
                            }
                        }
                    }
                }
                var _skipped = false;
                if (_isdiag)
                {
                    _cutscene_controller.keep_sequence = sequence;
                    _cutscene_controller.keep_sequence_layer = sequence_layer;
                    layer_sequence_headpos(sequence, min(end_frame, layer_sequence_get_length(sequence)) - 1);
                    layer_sequence_pause(sequence);
                }
                else if (skip)
                {
                    _skipped = true;
                    if (layer_sequence_get_headpos(sequence) < skip_frame)
                    {
                        layer_sequence_headpos(sequence, skip_frame);
                        _nextev = false;
                    }
                    else if (destroy_on_end)
                    {
                        layer_sequence_destroy(sequence);
                    }
                    skippable = skippable_after_skip_frame;
                    skip = false;
                }
                else if (destroy_on_end)
                {
                    layer_sequence_destroy(sequence);
                }
                if (_nextev)
                {
                    if (is_struct(inserted_in_dialogue))
                    {
                        _end();
                        _cutscene_controller.current_event = inserted_in_dialogue;
                        _cutscene_controller.events[_cutscene_controller.current_event_id] = inserted_in_dialogue;
                        inserted_in_dialogue.returning_from_inserted_sequence = true;
                        inserted_in_dialogue.next_event();
                    }
                    else if (_skipped)
                    {
                        with (_cutscene_controller)
                        {
                            var _match = true;
                            var _evnum = current_event_id + 1;
                            while (_evnum < array_length(events) && _match)
                            {
                                var _ev = events[_evnum];
                                _match = _ev.skip_through;
                                if (!_match)
                                {
                                    _evnum -= 1;
                                }
                                _evnum++;
                            }
                            if (_evnum >= array_length(events))
                            {
                                _on_finish();
                                instance_destroy(controller_object);
                            }
                            else
                            {
                                end_current_event();
                                current_event_id = _evnum;
                                start_current_event();
                            }
                        }
                    }
                    else
                    {
                        _cutscene_controller.next_event();
                    }
                }
            }
        }
    };
    
    text = 
    {
        paused_text: strloc("system/cutscene/paused_text"),
        skip_button: strloc("system/cutscene/skip_button"),
        skipping_text: strloc("system/cutscene/skipping_text")
    };
    
    _first_frame_draw = function()
    {
    };
    
    mwsc.textbox.width = 350;
    
    _draw = function()
    {
        if (!past_first_frame)
        {
            _first_frame_draw();
        }
        if (string_length(mwsc.text) > 0)
        {
            var tbx = 240;
            var tby = 251;
            if (tb_wavy > 0)
            {
                var _tbsf = surface_create(480, 270);
                surface_set_target(_tbsf);
                draw_clear_alpha(c_black, 0);
                _draw_textbox(tbx, tby);
                surface_reset_target();
                shader_set_wavy_texture(surface_get_texture(_tbsf), current_time / 1000, tb_wavy_speed, tb_wavy_frequency, tb_wavy_size * tb_wavy_intensity, 0, 0, 0);
                draw_surface(_tbsf, 0, 0);
                shader_reset();
                surface_free(_tbsf);
            }
            else
            {
                _draw_textbox(tbx, tby);
            }
        }
        if (_skip_held_time > 20)
        {
            var _skipstr = text.skipping_text;
            var _prog = (_skip_held_time - 20) / (skip_hold_time - 20);
            _skipstr = string_copy(_skipstr, 1, (string_length(_skipstr) - 3) + ceil(_prog * 3));
            draw_text_outline(5, 5, _skipstr);
        }
        if (user_paused)
        {
            var crframe = 0;
            pause_menu.tick();
            pause_menu.draw();
            if (pause_menu.cursor_hover != -1)
            {
                crframe = 1;
                if (mouse_check_button(mb_left))
                {
                    crframe = 2;
                }
            }
            if (!pause_menu.options_open)
            {
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                if (skippable && user_skippable)
                {
                    var _str = text.skip_button;
                    var _wid = string_width(_str) + 6;
                    var _hei = (string_height(_str) + 6) - 2;
                    var _sc = [5, 5, 5 + _wid, 5 + _hei];
                    draw_rectangle(_sc[0], _sc[1], _sc[2], _sc[3], true);
                    draw_text(mean(_sc[0], _sc[2]), mean(_sc[1], _sc[3]) + 1, _str);
                    if (point_in_rectangle(mouse_x, mouse_y, _sc[0], _sc[1], _sc[2], _sc[3]))
                    {
                        crframe = 1;
                        if (mouse_check_button(mb_left))
                        {
                            crframe = 2;
                        }
                        if (get_input_click() && !instance_exists(transition_controller))
                        {
                            skip = true;
                            _user_set_pause(false);
                        }
                    }
                }
                draw_set_halign(fa_left);
                draw_set_valign(fa_top);
            }
            draw_sprite(spr_cursor, crframe, mouse_x, mouse_y);
        }
    };
    
    _draw_textbox = function(arg0, arg1, arg2)
    {
        var _str = mwsc.text;
        var _letter = mwsc.current_letter;
        var _headspace;
        if (speaker_icon != -1)
        {
            _headspace = sprite_get_width(speaker_icon) + 2;
            arg0 += (_headspace / 2);
        }
        mwsc.draw(arg0, arg1);
        var _text_width = mwsc.textbox.longest_line_w;
        if (!tb_auto && _letter >= string_length(_str) && no_text_continue_until_frame == -1)
        {
            draw_sprite(spr_cutscene_textbox_arrow, 0, 477, 267);
        }
        if (speaker_icon != -1)
        {
            draw_sprite(speaker_icon, 0, round(arg0 - (_text_width / 2) - (_headspace * 0.75)), arg1);
        }
    };
    
    get_active_tracks = function()
    {
        var _tracks = [];
        var _elem = sequence;
        var _seq_instance = layer_sequence_get_instance(_elem);
        if (_seq_instance == -1)
        {
            exit;
        }
        array_copy(_tracks, array_length(_tracks), _seq_instance.activeTracks, 0, array_length(_seq_instance.activeTracks));
        for (var i = 0; i < array_length(_tracks); i++)
        {
            var _track = _tracks[i];
            switch (_track.track.type)
            {
                case 7:
                    array_copy(_tracks, array_length(_tracks), _track.activeTracks, 0, array_length(_track.activeTracks));
                    break;
            }
        }
        return _tracks;
    };
    
    _set_volumes = function()
    {
        var _elem = sequence;
        var _seq_instance = layer_sequence_get_instance(_elem);
        if (_seq_instance == -1)
        {
            exit;
        }
        var _tracks = get_active_tracks();
        if (array_length(_tracks) != volumes_prev_track_length)
        {
            volumes_prev_track_length = array_length(_tracks);
            volumes_set = false;
        }
        for (var i = 0; i < array_length(_tracks); i++)
        {
            volumes_set = true;
            var _track = _tracks[i];
            switch (_track.track.type)
            {
                case 2:
                    var _name = _track.track.name;
                    var is_music = string_lower(string_copy(_name, 1, 5)) == "music";
                    var newtrack = false;
                    var _arr = sfx_tracks;
                    var __gain = audio_emitter_get_gain(master.emit_sfx);
                    if (is_music)
                    {
                        _arr = music_tracks;
                        __gain = audio_emitter_get_gain(master.emit_mus);
                    }
                    var _ind = array_get_index(_arr, _track);
                    if (_ind == -1)
                    {
                        array_push(_arr, _track, _track.gain);
                        newtrack = true;
                        _ind = array_length(_arr) - 2;
                    }
                    var _destgain = _arr[_ind + 1] * __gain;
                    var set = _arr[_ind].gain != _destgain;
                    _arr[_ind].gain = _destgain;
                    if (set)
                    {
                        show_debug_message("Track \"" + _name + "\" gain set to " + string_format(_arr[_ind].gain, 1, 5));
                    }
                    break;
                case 7:
                    array_copy(_tracks, array_length(_tracks), _track.activeTracks, 0, array_length(_track.activeTracks));
                    break;
            }
        }
    };
    
    _play = function()
    {
        if (sequence == -1)
        {
            sequence_layer = layer_create(sequence_layer_depth);
            sequence = layer_sequence_create(sequence_layer, 240, 135, sequence_id);
            if (start_frame > 0)
            {
                layer_sequence_headpos(sequence, start_frame);
            }
            music_tracks = [];
            sfx_tracks = [];
        }
        else
        {
            _resume();
        }
    };
    
    _user_set_pause = function(arg0)
    {
        if (arg0)
        {
            pause_menu.open();
            if (!paused)
            {
                layer_sequence_pause(sequence);
            }
            user_paused = true;
            for (var i = 0; i < array_length(pause_sounds); i++)
            {
                audio_pause_sound(pause_sounds[i]);
            }
        }
        else
        {
            _user_pause_key = 0;
            _user_skip_key = 0;
            _skip_held_time = 0;
            if (!paused)
            {
                layer_sequence_play(sequence);
            }
            user_paused = false;
            for (var i = 0; i < array_length(pause_sounds); i++)
            {
                audio_resume_sound(pause_sounds[i]);
            }
        }
    };
    
    _pause = function()
    {
        layer_sequence_pause(sequence);
        paused = true;
    };
    
    _resume = function()
    {
        if (tb_pause_until_line == -1)
        {
            layer_sequence_play(sequence);
        }
        paused = false;
    };
    
    _get_markers = function()
    {
        var _markers = sequence_get_markers(sequence_id);
        if (array_length(struct_get_names(_markers)) > 0)
        {
            markers = _markers;
        }
    };
    
    clear_loop = function()
    {
        loop_start_frame = -1;
        loop_end_frame = -1;
    };
    
    localize_text_tracks = function()
    {
        var _struct = sequence_get(sequence_id);
        for (var i = 0; i < array_length(_struct.tracks); i++)
        {
            var _track = _struct.tracks[i];
            var _name = _track.name;
            var _type = _track.type;
            if (_type == 17 && string_pos("strloc_", _name) == 1)
            {
                var _keyname = string_replace(_name, "strloc_", "");
                for (var j = 0; j < array_length(_track.keyframes); j++)
                {
                    var _keyframe = _track.keyframes[j];
                    _keyframe.channels[0].text = strloc(_keyname);
                }
            }
        }
    };
}

function sequence_show_textbox()
{
    if (cutscene_controller.cutscene != -1)
    {
        if (cutscene_controller.cutscene.current_event != -1)
        {
            var _ev = cutscene_controller.cutscene.current_event;
            if (_ev._event_type == 0)
            {
                _ev.tb_show = true;
            }
        }
    }
}

function sequence_hide_textbox()
{
    if (cutscene_controller.cutscene != -1)
    {
        if (cutscene_controller.cutscene.current_event != -1)
        {
            var _ev = cutscene_controller.cutscene.current_event;
            if (_ev._event_type == 0)
            {
                _ev.tb_show = false;
            }
        }
    }
}

function sequence_parse_textbox_events(arg0)
{
    arg0 = sequence_get(arg0);
    if (is_struct(arg0))
    {
        var file = file_text_open_write("sequence_output.json");
        file_text_write_string(file, json_stringify(arg0, true));
        file_text_close(file);
    }
}

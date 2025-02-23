function lobby_groundfloor() : lobby_constructor() constructor
{
    use_countdown_timer = true;
    countdown_max_time = 8;
    countdown_max_time_display = 582;
    lobby_end_interrupt_script_path = "0/lobby/end_interrupted";
    next_round_cutscene = cs_0_3;
    background_sprite = lb0_spr_bg;
    width = 928;
    height = 518;
    bg_x = width / 2;
    bg_y = height / 2;
    
    on_load_in = function()
    {
        set_story_flag("tutorial.minigames.basics", 1);
        if (get_story_flag("_0.lobby_intro", false))
        {
            var _popup = new lobby_popup_constructor();
            var _page = new lobby_popup_page_constructor();
            _page.text = strloc("dialogue/0/lobby/tutorial/submenu_reminder.0");
            _page.height = -1;
            _popup.add_page(_page);
            lobby_show_popup(_popup);
        }
        else
        {
            var _script = load_dialogue_script("scripts/0/lobby/enter.mwsc");
            var _cs = dialogue_script_to_cutscene_struct(_script);
            
            _cs._on_finish = function()
            {
                var _script = strloc("dialogue/0/lobby/tutorial/basics");
                var _popup = new lobby_popup_constructor();
                var _pages = [{}, 
                {
                    highlight_area: [240, 300, 240, 300]
                }, 
                {
                    func: function()
                    {
                        with (obj_lobby_controller)
                        {
                            talkmenu_force_open = true;
                            talkmenu = talkmenu_force_open;
                            talkmenu_prog = 0;
                        }
                    },
                    
                    y: 200,
                    use_highlight: true,
                    highlight_area: [0, 122, 480, 264]
                }, 
                {
                    func: function()
                    {
                        with (obj_lobby_controller)
                        {
                            talkmenu_button_hover = 1;
                        }
                    },
                    
                    x: 302,
                    y: 193,
                    use_highlight: true,
                    highlight_area: [0, 122, 197, 264]
                }, 
                {
                    func: function()
                    {
                        with (obj_lobby_controller)
                        {
                            talkmenu_button_hover = 2;
                        }
                    },
                    
                    x: 178,
                    y: 193,
                    use_highlight: true,
                    highlight_area: [283, 122, 480, 264]
                }, 
                {
                    func: function()
                    {
                        with (obj_lobby_controller)
                        {
                            talkmenu_button_hover = 0;
                            talkmenu_force_open = false;
                            talkmenu = talkmenu_force_open;
                            talkmenu_prog = 0;
                        }
                    },
                    
                    use_highlight: true,
                    highlight_area: [330, 300, 477, 417]
                }];
                for (var i = 0; i < array_length(_pages); i++)
                {
                    var newpage = new lobby_popup_page_constructor();
                    newpage.text = _script[i];
                    var pagevars = _pages[i];
                    struct_set(pagevars, "height", -1);
                    var pagevars_names = struct_get_names(pagevars);
                    for (var j = 0; j < array_length(pagevars_names); j++)
                    {
                        var _val_name = pagevars_names[j];
                        var _val = struct_get(pagevars, _val_name);
                        struct_set(newpage, _val_name, _val);
                    }
                    _popup.add_page(newpage);
                }
                lobby_show_popup(_popup);
            };
            
            play_cutscene_struct(_cs);
        }
    };
    
    on_smalls_click = function()
    {
        play_dialogue_script(load_dialogue_script("scripts/0/lobby/smalls/_button.mwsc"));
    };
    
    on_pandora_click = function()
    {
        play_dialogue_script(load_dialogue_script("scripts/0/lobby/leave_convo.mwsc"));
    };
    
    template_room = rm_lb0;
    shadows = [];
    
    parse_sprite = function(arg0)
    {
        var sprname = sprite_get_name(arg0.sprite_index);
        var shdsprite = asset_get_index(sprname + "shadow");
        if (shdsprite != -1)
        {
            array_push(shadows, [shdsprite, arg0]);
        }
    };
    
    cam_y_max = 176;
    
    _draw_background = function()
    {
        var camx = round(cam_x + nudge_x);
        var camy = round(cam_y + nudge_y);
        draw_clear(c_aqua);
        var _layer_depth = [1, 1.08, 1.08, 1.08];
        var _dep;
        for (var i = 3; i >= 0; i--)
        {
            _dep = _layer_depth[i];
            var _yy = 0;
            draw_sprite(lb0_spr_bg, i, bg_x - (camx / _dep), (bg_y - camy) + _yy);
        }
        var sf = surface_create(width, height);
        surface_set_target(sf);
        draw_clear(c_white);
        draw_sprite(lb0_spr_bigshadow, 0, -6, 228);
        for (var i = 0; i < array_length(shadows); i++)
        {
            var shdsprite = shadows[i][0];
            var sprsprite = shadows[i][1];
            draw_sprite_ext(shdsprite, sprsprite.image_index, (sprsprite.x - bg_x) + (width / 2), (sprsprite.y - bg_y) + (height / 2), sprsprite.image_xscale, sprsprite.image_yscale, sprsprite.image_angle, c_white, 1);
        }
        surface_reset_target();
        blendmode_set_multiply();
        draw_surface(sf, bg_x - (camx / _dep) - (width / 2), bg_y - camy - (height / 2));
        blendmode_reset();
        surface_free(sf);
    };
    
    get_interact_zone_clickable = function(arg0)
    {
        var _template = "_0.*.done";
        _template = string_replace(_template, "*", arg0);
        return get_story_flag(_template, 0) < 1;
    };
    
    struct_set(interact_funcs, "ceiling", function()
    {
        if (get_interact_zone_clickable("ceiling"))
        {
            play_dialogue_script("scripts/0/lobby/ceiling.mwsc");
        }
    });
    struct_set(hoverable_funcs, "ceiling", function()
    {
        return get_interact_zone_clickable("ceiling");
    });
    struct_set(interact_funcs, "screen", function()
    {
        if (get_interact_zone_clickable("screen"))
        {
            play_dialogue_script("scripts/0/lobby/screen.mwsc");
        }
    });
    struct_set(hoverable_funcs, "screen", function()
    {
        return get_interact_zone_clickable("screen");
    });
    struct_set(interact_funcs, "windows", function()
    {
        if (get_interact_zone_clickable("windows"))
        {
            play_dialogue_script("scripts/0/lobby/windows.mwsc");
        }
    });
    struct_set(hoverable_funcs, "windows", function()
    {
        return get_interact_zone_clickable("windows");
    });
    struct_set(interact_funcs, "dom", function()
    {
        play_dialogue_script("scripts/0/lobby/dom/click.mwsc");
    });
    struct_set(interact_funcs, "iris", function()
    {
        if (get_interact_zone_clickable("iris"))
        {
            play_dialogue_script("scripts/0/lobby/iris/click.mwsc");
        }
    });
    struct_set(hoverable_funcs, "iris", function()
    {
        return get_interact_zone_clickable("iris");
    });
    struct_set(interact_funcs, "slate_kat", function()
    {
        if (get_interact_zone_clickable("slate_kat"))
        {
            play_dialogue_script("scripts/0/lobby/slate_kat/click.mwsc");
        }
    });
    struct_set(hoverable_funcs, "slate_kat", function()
    {
        return get_interact_zone_clickable("slate_kat");
    });
    struct_set(interact_funcs, "roxy", function()
    {
        if (get_interact_zone_clickable("roxy"))
        {
            play_dialogue_script("scripts/0/lobby/roxy/click.mwsc");
        }
    });
    struct_set(hoverable_funcs, "roxy", function()
    {
        return get_interact_zone_clickable("roxy");
    });
    struct_set(interact_funcs, "alex", function()
    {
        if (get_interact_zone_clickable("alex"))
        {
            play_dialogue_script("scripts/0/lobby/alex/click.mwsc");
        }
    });
    struct_set(interact_funcs, "abbie", function()
    {
        if (get_interact_zone_clickable("abbie"))
        {
            play_dialogue_script("scripts/0/lobby/abbie/click.mwsc");
        }
    });
    struct_set(hoverable_funcs, "abbie", function()
    {
        return get_interact_zone_clickable("abbie");
    });
}

function lb0_diagops_smalls()
{
    var _options = [];
    var _folder = "0/lobby/smalls/";
    _options = [["blabla", 1, _folder + "blabla"], ["blabla", 1, _folder + "blabla"], ["blabla", 1, _folder + "blabla"]];
    return _options;
}

function lb0_scr_dom_music(arg0 = 0, arg1 = 4)
{
    arg0 = real(arg0);
    arg1 = real(arg1);
    if (arg0)
    {
        lobby_bgm_gain(0, 0);
        var _inst = instance_create_depth(0, 0, 0, lb0_domsong_controller);
        _inst.song = sfx_play(mus_dom_song, false, 1, 0, 1, true);
        _inst.dialogue_controller = cutscene_controller.cutscene.current_event;
        _inst.event_length = arg1;
        allow_player_input = false;
    }
    else
    {
        lobby_bgm_gain(1);
        audio_stop_sound(mus_dom_song);
        allow_player_input = true;
        instance_destroy(lb0_domsong_controller);
    }
}

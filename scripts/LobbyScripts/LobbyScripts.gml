function lobby_constructor()
{
    width = 490;
    height = 275;
    template_room = -1;
    background_sprite = -1;
    bg_x = 240;
    bg_y = 135;
    origin_x = 0;
    origin_y = 0;
    interactable_script = -1;
    interact_anim = 1;
    interact_anim_time = 30;
    interact_anim_x = 0;
    interact_anim_y = 0;
    use_countdown_timer = false;
    countdown_max_time = 20;
    countdown_max_time_display = 120;
    timer_interrupt = true;
    lobby_end_interrupt_script_path = "0/lobby/end_interrupted";
    next_round_cutscene = cs_0_3;
    
    on_countdown_end = function()
    {
        var _script_path = lobby_end_interrupt_script_path;
        if (instance_exists(cutscene_controller))
        {
            with (cutscene_controller.cutscene.current_event)
            {
                array_insert(mwsc.events, mwsc.current_event + 1, ["goto_script", _script_path]);
            }
        }
        else
        {
            play_dialogue_script("scripts/" + _script_path + ".mwsc");
        }
    };
    
    start_next_round = function()
    {
        instance_destroy(obj_lobby_controller);
        instance_destroy(cutscene_controller);
        play_cutscene(next_round_cutscene);
        set_story_flag("room_id", 0);
        set_story_flag("cuscene_name", script_get_name(next_round_cutscene));
        storymode_save();
    };
    
    init = function()
    {
    };
    
    parse_sprite = function(arg0)
    {
    };
    
    sprites = [];
    interact_zones = [];
    interact_funcs = {};
    hoverable_funcs = {};
    saved_since_load = false;
    countdown_time = 0;
    xscroll_speed = 3;
    xscrolling = 0;
    yscroll_speed = 3;
    yscrolling = 0;
    cam_x_min = -infinity;
    cam_x_max = infinity;
    cam_y_min = -infinity;
    cam_y_max = infinity;
    cam_x = 0;
    cam_y = 0;
    nudge_x = 0;
    nudge_y = 0;
    loaded_in = false;
    active_popup = -1;
    
    on_load_in = function()
    {
    };
    
    on_smalls_click = function()
    {
    };
    
    on_pandora_click = function()
    {
        obj_lobby_controller.start_next_round();
    };
    
    tick = function()
    {
    };
    
    _draw_background = function()
    {
        var camx = round(cam_x + nudge_x);
        var camy = round(cam_y + nudge_y);
        if (sprite_exists(background_sprite))
        {
            draw_sprite(background_sprite, 1, bg_x - camx, bg_y - camy);
        }
    };
    
    _init = function()
    {
        loaded_in = false;
        countdown_time = countdown_max_time;
        var _flag_time = get_story_flag("lobby_time", -1);
        if (_flag_time != -1)
        {
            countdown_time = _flag_time;
        }
        if (room_exists(template_room))
        {
            layer_set_target_room(template_room);
            var layers = layer_get_all();
            var layer_num = array_length(layers) - 1;
            while (layer_num >= 0)
            {
                var _layer_id = layers[layer_num];
                var _layer_elements = layer_get_all_elements(_layer_id);
                var _layer_name = layer_get_name(_layer_id);
                var is_interact_zone = string_pos("interact_", _layer_name) == 1;
                var zone_coords, zone_name;
                if (is_interact_zone)
                {
                    zone_name = string_replace(_layer_name, "interact_", "");
                    zone_coords = [];
                }
                if (layer_get_visible(_layer_id) || is_interact_zone)
                {
                    var element_num = array_length(_layer_elements) - 1;
                    while (element_num >= 0)
                    {
                        var _element = _layer_elements[element_num];
                        var _element_type = layer_get_element_type(_element);
                        switch (_element_type)
                        {
                            case 4:
                                var sp_sprite = layer_sprite_get_sprite(_element);
                                var sp_x = layer_sprite_get_x(_element);
                                var sp_y = layer_sprite_get_y(_element);
                                var sp_xscale = layer_sprite_get_xscale(_element);
                                var sp_yscale = layer_sprite_get_yscale(_element);
                                var sp_angle = layer_sprite_get_angle(_element);
                                if (is_interact_zone)
                                {
                                    var zc = [];
                                    var ang = sp_angle;
                                    sp_sprite = spr_lb_interactzone;
                                    var _ox = sprite_get_xoffset(sp_sprite);
                                    var _oy = sprite_get_yoffset(sp_sprite);
                                    var _wid = sprite_get_width(sp_sprite);
                                    var _hgt = sprite_get_height(sp_sprite);
                                    var _sL = _ox * sp_xscale;
                                    var _sU = _oy * sp_yscale;
                                    var _sR = (_wid - _ox) * sp_xscale;
                                    var _sD = (_hgt - _oy) * sp_yscale;
                                    switch (sp_sprite)
                                    {
                                        case spr_lb_interactzone:
                                        default:
                                            zc[0] = [0, 0];
                                            zc[0][0] = sp_x + lengthdir_x(_sR, ang + 0) + lengthdir_x(_sU, ang - 90);
                                            zc[0][1] = sp_y + lengthdir_y(_sR, ang + 0) + lengthdir_y(_sU, ang - 90);
                                            zc[1] = [0, 0];
                                            zc[1][0] = sp_x + lengthdir_x(_sL, ang + 180) + lengthdir_x(_sU, ang - 90);
                                            zc[1][1] = sp_y + lengthdir_y(_sL, ang + 180) + lengthdir_y(_sU, ang - 90);
                                            zc[2] = [0, 0];
                                            zc[2][0] = sp_x + lengthdir_x(_sL, ang + 180) + lengthdir_x(_sD, ang + 90);
                                            zc[2][1] = sp_y + lengthdir_y(_sL, ang + 180) + lengthdir_y(_sD, ang + 90);
                                            zc[3] = [0, 0];
                                            zc[3][0] = sp_x + lengthdir_x(_sR, ang + 0) + lengthdir_x(_sD, ang + 90);
                                            zc[3][1] = sp_y + lengthdir_y(_sR, ang + 0) + lengthdir_y(_sD, ang + 90);
                                            break;
                                    }
                                    array_push(zone_coords, zc);
                                }
                                else
                                {
                                    switch (sp_sprite)
                                    {
                                        case spr_lb_cammarker:
                                            cam_x = sp_x - 240;
                                            cam_y = sp_y - 135;
                                            break;
                                        default:
                                            var sp_index = layer_sprite_get_index(_element);
                                            var sp_speed = layer_sprite_get_speed(_element);
                                            var sp_color = layer_sprite_get_blend(_element);
                                            var sp_alpha = layer_sprite_get_alpha(_element);
                                            var sprite = 
                                            {
                                                sprite_index: sp_sprite,
                                                image_index: sp_index,
                                                image_speed: sp_speed,
                                                x: sp_x,
                                                y: sp_y,
                                                image_xscale: sp_xscale,
                                                image_yscale: sp_yscale,
                                                image_angle: sp_angle,
                                                image_blend: sp_color,
                                                image_alpha: sp_alpha,
                                                zone_coord_type: 0,
                                                interact_zone: []
                                            };
                                            parse_sprite(sprite);
                                            array_push(sprites, sprite);
                                            break;
                                    }
                                }
                                break;
                        }
                        element_num--;
                    }
                }
                if (is_interact_zone)
                {
                    var _zones = 
                    {
                        name: zone_name,
                        zones: zone_coords
                    };
                    array_push(interact_zones, _zones);
                }
                layer_num--;
            }
            layer_reset_target_room();
        }
        init();
    };
    
    _tick = function()
    {
        if (!loaded_in && !instance_exists(transition_controller))
        {
            loaded_in = true;
            on_load_in();
        }
        if (!instance_exists(transition_controller) && !instance_exists(cutscene_controller))
        {
            if (countdown_time <= 0)
            {
                on_countdown_end();
            }
        }
        tick();
        if (active_popup != -1)
        {
            active_popup.tick();
        }
    };
    
    _draw = function()
    {
        var camx = round(cam_x + nudge_x);
        var camy = round(cam_y + nudge_y);
        _draw_background();
        var lb_origin_x = origin_x;
        var lb_origin_y = origin_y;
        var crx = obj_lobby_controller.cursor_x;
        var cry = obj_lobby_controller.cursor_y;
        var xoff = round(lb_origin_x - camx);
        var yoff = round(lb_origin_y - camy);
        for (var i = 0; i < array_length(sprites); i++)
        {
            var _sprite = sprites[i];
            if (sprite_exists(_sprite.sprite_index))
            {
                with (_sprite)
                {
                    draw_sprite_ext(sprite_index, image_index, x + xoff, y + yoff, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
                }
            }
        }
        if (interact_anim < 1)
        {
            var sizemax = 9;
            var sizemin = sizemax * 0.34615384615384615;
            var _rad = value_from_keyframes([[0, sizemax, lerp], [0.16, sizemin, lerp_easeOut], [0.8, sizemax, -1]], interact_anim);
            var _al = value_from_keyframes([[0, 1, lerp], [0.6, 1, lerp_easeOut], [1, 0, -1]], interact_anim);
            draw_set_alpha(_al);
            draw_circle(interact_anim_x + xoff, interact_anim_y + yoff, _rad, true);
            draw_set_alpha(1);
        }
    };
}

function lobby_show_popup(arg0)
{
    obj_lobby_controller.lobby.active_popup = arg0;
    arg0.start();
}

function lobby_popup_constructor() constructor
{
    pages = [];
    current_page = -1;
    prev_page = -1;
    current_page_num = 0;
    onscreen_pages = [];
    
    after_done = function()
    {
    };
    
    lerp_anim_time = 1;
    lerm_anim_length = 15;
    lerp_anim_func = lerp_easeInOut;
    
    tick = function()
    {
        if (lerp_anim_time < 1)
        {
            lerp_anim_time += (1 / lerm_anim_length);
            lerp_anim_time = clamp(lerp_anim_time, 0, 1);
            if (lerp_anim_time == 1)
            {
            }
        }
        var continue_btn = get_input_click() || keyboard_check_pressed(vk_space);
        if (continue_btn)
        {
            if (lerp_anim_time < 1)
            {
                lerp_anim_time = 1;
            }
            else
            {
                master.click = 0;
                current_page_num++;
                if (current_page_num >= array_length(pages))
                {
                    begin_end();
                }
                else
                {
                    var _curpage = pages[current_page_num - 1];
                    var _nextpage = pages[current_page_num];
                    prev_page = _curpage;
                    current_page = _nextpage;
                    if (_curpage.lerp_to_next_page)
                    {
                        lerp_anim_time = 0;
                    }
                    current_page.func();
                }
            }
        }
    };
    
    draw = function()
    {
        var blended_page = current_page;
        if (is_struct(prev_page))
        {
            blended_page = new lobby_popup_page_constructor();
            var _t = lerp_anim_func(lerp_anim_time);
            if (_t == 0)
            {
                blended_page = prev_page;
            }
            else if (_t == 1)
            {
                blended_page = current_page;
            }
            else
            {
                var base_struct = -1;
                if (_t < 0.5)
                {
                    base_struct = prev_page;
                }
                else
                {
                    base_struct = current_page;
                }
                blended_page.text = current_page.text;
                blended_page.text_prev = prev_page.text;
                blended_page.text_lerp = _t;
                blended_page.use_highlight = prev_page.use_highlight || current_page.use_highlight;
                if (prev_page.lerp_to_next_page)
                {
                    var _vars = ["x", "y", "width", "height"];
                    for (var i = 0; i < array_length(_vars); i++)
                    {
                        var _var_name = _vars[i];
                        struct_set(blended_page, _var_name, lerp(struct_get(prev_page, _var_name), struct_get(current_page, _var_name), _t));
                    }
                }
                if (prev_page.lerp_highlight)
                {
                    for (var i = 0; i < 4; i++)
                    {
                        blended_page.highlight_area[i] = lerp(prev_page.highlight_area[i], current_page.highlight_area[i], _t);
                    }
                }
            }
        }
        onscreen_pages = [blended_page];
        var highlight_areas = [];
        for (var i = 0; i < array_length(onscreen_pages); i++)
        {
            var _page = onscreen_pages[i];
            if (_page.use_highlight)
            {
                array_push(highlight_areas, _page.highlight_area);
            }
        }
        blendmode_set_multiply();
        draw_sprite(spr_MULTIPLYpopupfilter, 0, 0, 0);
        for (var i = 0; i < array_length(highlight_areas); i++)
        {
            var _a = highlight_areas[i];
            draw_roundrect(_a[0], _a[1], _a[2], _a[3], false);
        }
        blendmode_reset();
        for (var i = 0; i < array_length(onscreen_pages); i++)
        {
            var _page = onscreen_pages[i];
            _page.draw();
        }
    };
    
    add_page = function(arg0)
    {
        if (arg0.height < 0)
        {
            var _str = string_to_wrapped(arg0.text, arg0.width * 0.9, "\n");
            arg0.height = (string_height(_str) + 40) / 0.9;
        }
        array_push(pages, arg0);
    };
    
    start = function()
    {
        current_page = pages[current_page_num];
        onscreen_pages = [current_page];
    };
    
    begin_end = function()
    {
        _end();
    };
    
    _end = function()
    {
        onscreen_pages = [];
        obj_lobby_controller.lobby.active_popup = -1;
    };
}

function lobby_popup_page_constructor() constructor
{
    sprite = -1;
    x = 0;
    y = 0;
    width = 200;
    height = 100;
    clear_pages_after = true;
    text = "";
    text_prev = "";
    text_lerp = 1;
    title = "";
    
    func = function()
    {
    };
    
    lerp_to_next_page = true;
    use_highlight = false;
    highlight_area = [0, 0, 0, 0];
    lerp_highlight = true;
    buttons = [];
    margin_x = 8;
    margin_top = 12;
    margin_bottom = 8;
    
    draw = function()
    {
        var text_top = y - (height / 2);
        var text_bottom = y + (height / 2);
        var text_space = 80;
        var _sprite_scale;
        if (sprite_exists(sprite))
        {
            _sprite_scale = (width - (margin_x * 2)) / sprite_get_width(sprite);
            var _sprite_height = sprite_get_height(sprite) * _sprite_scale;
            height = _sprite_height + text_space + (margin_top + margin_bottom);
            text_top += _sprite_height;
        }
        draw_popupbox(x, y, width, height);
        if (sprite_exists(sprite))
        {
            var _sprite_x = (x - (width / 2)) + margin_x + ((-sprite_get_xoffset(sprite) + sprite_get_width(sprite)) * _sprite_scale);
            var _sprite_y = (y - (height / 2)) + margin_top + ((-sprite_get_yoffset(sprite) + sprite_get_height(sprite)) * _sprite_scale);
            gpu_set_texfilter(true);
            draw_sprite_ext(sprite, 0, _sprite_x, _sprite_y, _sprite_scale, _sprite_scale, 0, c_white, 1);
            gpu_set_texfilter(false);
        }
        var text_x = x;
        var text_y = mean(text_top, text_bottom);
        var _str = text;
        if (text_lerp < 0.5)
        {
            _str = text_prev;
        }
        draw_textbox(text_x, text_y, _str, width * 0.9, infinity, 1, 1);
    };
    
    auto_size = function()
    {
    };
    
    center_pos = function()
    {
        x = 240;
        y = 135;
    };
    
    center_pos();
}

function log_dialogue_line(arg0, arg1, arg2)
{
    var _speaker_name = "mystery";
    var _speaker_side = -1;
    var _speaker_expression = 
    {
        pose: 0,
        face: 0
    };
    var _speaker_icon = spr_none;
    if (is_struct(arg2))
    {
        _speaker_name = arg2.name;
        _speaker_icon = arg2.icon;
        _speaker_side = arg2.side;
        _speaker_expression.pose = arg2.pose;
        _speaker_expression.face = arg2.face;
    }
    array_push(arg0, 
    {
        text: arg1,
        speaker_name: _speaker_name,
        speaker_icon: _speaker_icon,
        speaker_expression: _speaker_expression,
        speaker_side: _speaker_side
    });
    if (array_length(arg0) > 50)
    {
        array_delete(arg0, 0, 1);
    }
}

function lobby_tick_wait_for_after_dialogue()
{
}

function lobby_tick_time(arg0 = 1)
{
    arg0 = real(arg0);
    with (obj_lobby_controller.lobby)
    {
        countdown_time -= arg0;
        if (countdown_time <= 0)
        {
            if (timer_interrupt)
            {
                on_countdown_end();
            }
            else
            {
                timer_interrupt = true;
            }
            set_story_flag("lobby_time", -1);
        }
        else
        {
            set_story_flag("lobby_time", countdown_time);
        }
    }
}

function lobby_timer_set_interrupt(arg0)
{
    arg0 = bool(real(arg0));
    with (obj_lobby_controller.lobby)
    {
        timer_interrupt = arg0;
    }
}

function lobby_bgm_gain(arg0, arg1 = 1000)
{
    with (obj_lobby_controller)
    {
        audio_sound_gain(music, arg0, arg1);
    }
}

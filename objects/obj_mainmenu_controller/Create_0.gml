menu_transition_start = -1;
menu_transition_end = -1;
menu_transition_time = 1;
menu_transition_speed = 0;
menu_transition_lerp_func = lerp;
menu_transition_time_until = -1;
transition_happening = false;
story_enabled = true;
options_enabled = true;

start_menu_transition = function(arg0, arg1 = 0, arg2 = 30, arg3 = lerp_easeInOut)
{
    if (menu_transition_time < 1)
    {
        return false;
    }
    menu_transition_start = active_menu;
    menu_transition_end = arg0;
    menu_transition_time_until = arg1;
    if (arg1 == 0)
    {
        menu_transition_time = 0;
    }
    menu_transition_speed = 1 / arg2;
    menu_transition_lerp_func = arg3;
    active_menu = -1;
    return true;
};

cam_x = 0;
cam_y = -270;
var playmus = false;
var musoffs = 6.099329999999999;
var musgain = 1;
if (variable_global_exists("main_menu_music"))
{
    if (global.main_menu_music == -1 || (global.main_menu_music != -1 && !audio_is_playing(global.main_menu_music)))
    {
        playmus = true;
    }
    else
    {
        music = global.main_menu_music;
        if (audio_sound_get_track_position(music) < (musoffs - 0.5))
        {
            audio_sound_set_track_position(music, musoffs);
        }
        global.main_menu_music = -1;
    }
}
else
{
    playmus = true;
}
if (variable_global_exists("mainmenu_muspos_save"))
{
    if (global.mainmenu_muspos_save > 0)
    {
        musoffs = max(musoffs, global.mainmenu_muspos_save);
        global.mainmenu_muspos_save = 0;
    }
}
if (variable_global_exists("main_menu_music_gain"))
{
    musgain = global.main_menu_music_gain;
    global.main_menu_music_gain = 1;
}
if (playmus)
{
    music = audio_play_sound_on(master.emit_mus, mus_mainmenu, true, 100, musgain, musoffs);
    if (musgain < 1)
    {
        audio_sound_gain(music, 1, 1000);
    }
    global.main_menu_music = music;
}
current_beat = -10;
music_repeats = 0;
music_repeat_beat = 0;
opening_timer = 1;
menu_title = new menu_constructor();
with (menu_title)
{
    t = 0;
    menu_in = 1;
    cam_x = 0;
    cam_y = -270;
    logo_x = 0;
    logo_y = 0;
    logo_pos = [240, 0];
    
    reset = function()
    {
        space_hold = false;
        anim_time = 0;
        anim = 0;
    };
    
    reset();
    text = 
    {
        press_space: strloc("menus/main/press_space")
    };
    
    on_press = function()
    {
        if (obj_mainmenu_controller.start_menu_transition(obj_mainmenu_controller.menu_main))
        {
            reset();
        }
    };
}
with (menu_title)
{
    tick_before = function()
    {
        if (obj_mainmenu_controller.opening_timer > 0.95 && obj_mainmenu_controller.active_menu == self)
        {
            switch (anim)
            {
                case 0:
                    if (space_hold)
                    {
                        anim_time += (1/30);
                        if (!keyboard_check(vk_space))
                        {
                            space_hold = false;
                            anim_time = 0;
                            anim = 1;
                            sfx_play(snd_title_press_space);
                        }
                    }
                    else
                    {
                        if (t > 1 && keyboard_check_pressed(vk_space))
                        {
                            space_hold = true;
                        }
                        t++;
                    }
                    break;
                case 1:
                    anim_time++;
                    if (anim_time >= 30)
                    {
                        on_press();
                    }
                    break;
            }
        }
        var _lerp = menu_in;
        logo_x = (cam_x - obj_mainmenu_controller.cam_x) + logo_pos[0];
        logo_y = (cam_y - obj_mainmenu_controller.cam_y) + logo_pos[1];
    };
}
with (menu_title)
{
    draw_before = function()
    {
        var bg_scale = 1;
        var fnt = draw_get_font();
        var _ver_string = master.version;
        draw_set_font(fnt_dialogue);
        draw_text_outline((logo_x - 240) + 5, logo_y + 5, _ver_string);
        draw_set_font(fnt);
        var am = (dsin(current_time / 10) + 1) / 2;
        var _merge_sin = ((obj_mainmenu_controller.current_beat * 90) + 180) % 360;
        if (anim == 1)
        {
            _merge_sin = lerp(_merge_sin, 1080, lerp_easeOut(anim_time / 60));
        }
        var _merge_amt = 1 - (0.5 + (dsin(_merge_sin) / 2));
        var stcol = merge_color(c_white, c_fuchsia, _merge_amt);
        draw_set_color(stcol);
        var _text_xscale = 1;
        var _text_yscale = 1;
        switch (anim)
        {
            case 0:
                var _formuler = (1 / ((anim_time + 0.1) * 0.01)) * 0.001;
                _text_xscale = 1 + (0.325 - (_formuler * 0.325));
                _text_yscale = 1 / _text_xscale;
                break;
            case 1:
                _text_yscale = lerp(1.3, 1, lerp_easeOut(min(anim_time / 30, 1)));
                _text_xscale = 1 / _text_yscale;
                break;
        }
        var tx_y = logo_y + 158 + 45;
        var tx_x = 240;
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text_outline(tx_x, tx_y, text.press_space, undefined, undefined, undefined, _text_xscale, _text_yscale);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_white);
        draw_set_font(fnt);
        draw_sprite_ext(spr_logo, 0, logo_x, logo_y + 111, bg_scale, bg_scale, 0, c_white, 1);
    };
}
menu_main = {};
with (menu_main)
{
    menu_in = 0;
    cam_x = 0;
    cam_y = 0;
    buttons = [];
    cursor_hover = -1;
    prev_highlighted_button = -1;
    highlight_cooldown = 0;
    highlight_images = [[spr_mmui_hoverimg0_line, spr_mmui_hoverimg0_fill], [spr_mmui_hoverimg1_line, spr_mmui_hoverimg1_fill], [spr_mmui_hoverimg2_line, spr_mmui_hoverimg2_fill], [spr_none, spr_none], [spr_none, spr_none]];
    highlight_text = ["", "", "", "", ""];
    highlight_image_ind = array_length(highlight_images) - 1;
    prev_highlight_image_ind = highlight_image_ind;
    highlight_img_transition = 1;
    var _btn_sprites = [[spr_mmui_btn0_small, spr_mmui_btn0_big], [spr_mmui_btn1_small, spr_mmui_btn1_big], [spr_mmui_btn2_small, spr_mmui_btn2_big], [spr_mmui_btn3_small, spr_mmui_btn3_big]];
    if (version_controller.build_type == 3)
    {
        _btn_sprites[1] = [spr_mmui_event_btnendless_small, spr_mmui_event_btnendless_big];
    }
    var _screenmid = 135;
    var _seperation = 50 - ((array_length(_btn_sprites) - 5) * 11);
    var centered_mode = false;
    buttons_base_x = 20;
    buttons_hover_x_shift = 10;
    if (centered_mode)
    {
        buttons_base_x = 240;
        buttons_hover_x_shift = 0;
    }
    for (var i = 0; i < array_length(_btn_sprites); i++)
    {
        var _btn = {};
        with (_btn)
        {
            x = obj_mainmenu_controller.menu_main.buttons_base_x;
            y = _screenmid + (_seperation * ((i - (array_length(_btn_sprites) / 2)) + 0.5));
            locked = false;
            x_shift = 0;
            y_shift = 0;
            highlighted = false;
            sprite_small = _btn_sprites[i][0];
            sprite_big = _btn_sprites[i][1];
            if (centered_mode)
            {
                sprite_set_offset(sprite_small, sprite_get_width(sprite_small) / 2, sprite_get_yoffset(sprite_small));
                sprite_set_offset(sprite_big, sprite_get_width(sprite_big) / 2, sprite_get_yoffset(sprite_big));
            }
            highlighted_display = 0;
            btn_upscale = 1.5;
            click_sound = snd_menu_click;
            
            onclick = function()
            {
            };
            
            coords = [0, 0, 0, 0];
            
            _tick = function()
            {
                var _small_scale = lerp(1, btn_upscale, highlighted_display);
                var _xoff = sprite_get_xoffset(sprite_small) * _small_scale;
                var _yoff = sprite_get_yoffset(sprite_small) * _small_scale;
                var _width = sprite_get_width(sprite_small) * _small_scale;
                var _height = sprite_get_height(sprite_small) * _small_scale;
                var x1 = (x + x_shift) - _xoff;
                var y1 = (y + y_shift) - _yoff;
                var x2 = x1 + _width;
                var y2 = y1 + _height;
                x1 -= x_shift;
                coords = [x1, y1, x2, y2];
                highlighted_display = lerp(highlighted_display, highlighted, 0.3);
            };
            
            _draw = function()
            {
                var _small_scale = lerp(1, btn_upscale, highlighted_display);
                var _big_scale = lerp(1 / btn_upscale, 1, highlighted_display);
                var _small_shadow = lerp(2, 5, highlighted_display) * _small_scale;
                var _big_shadow = lerp(5, 8, highlighted_display) * _big_scale;
                var _small_alpha = 1;
                var _big_alpha = 0;
                if (highlighted_display > 0.5)
                {
                    _big_alpha = 1;
                    _small_alpha = 0;
                }
                var _draw_x = x + x_shift;
                var _draw_y = y + y_shift;
                var _frame = 0;
                var _sprbig = sprite_big;
                draw_sprite_ext(sprite_small, _frame, _draw_x, _draw_y + _small_shadow, _small_scale, _small_scale, 0, c_black, _small_alpha);
                draw_sprite_ext(sprite_small, _frame, _draw_x, _draw_y, _small_scale, _small_scale, 0, c_white, _small_alpha);
                draw_sprite_ext(sprite_big, _frame, _draw_x, _draw_y + _big_shadow, _big_scale, _big_scale, 0, c_black, _big_alpha);
                draw_sprite_ext(sprite_big, _frame, _draw_x, _draw_y, _big_scale, _big_scale, 0, c_white, _big_alpha);
                if (locked)
                {
                    var lock_x = _draw_x + (((sprite_get_width(sprite_big) / 2) - 25) * _big_scale);
                    var lock_y = _draw_y;
                    blendmode_set_multiply();
                    draw_sprite_ext(spr_mmui_btn1lock_small, 0, lock_x, lock_y, _small_scale, _small_scale, 0, c_white, _small_alpha);
                    blendmode_reset();
                    draw_sprite_ext(spr_mmui_btn1lock_small, 0, lock_x, lock_y, _small_scale, _small_scale, 0, c_white, _small_alpha * 0.35);
                    blendmode_set_multiply();
                    draw_sprite_ext(spr_mmui_btn1lock_big, 0, lock_x, lock_y, _big_scale, _big_scale, 0, c_white, _big_alpha);
                    blendmode_reset();
                    draw_sprite_ext(spr_mmui_btn1lock_big, 0, lock_x, lock_y, _big_scale, _big_scale, 0, c_white, _big_alpha * 0.35);
                }
            };
        }
        array_push(buttons, _btn);
    }
    
    buttons[0].onclick = function()
    {
        with (obj_mainmenu_controller)
        {
            start_menu_transition(menu_fileselect);
        }
    };
    
    if (!master.profile.unlocks.mind_select_menu)
    {
        highlight_images[1] = [spr_mmui_hoverimg1lock_line, spr_mmui_hoverimg1lock_fill];
        buttons[1].locked = true;
    }
    if (master.profile.unlocks.mind_select_menu)
    {
        buttons[1].click_sound = snd_menu_click_major;
    }
    
    buttons[1].onclick = function()
    {
        if (master.profile.unlocks.mind_select_menu)
        {
            with (obj_mainmenu_controller)
            {
                if (start_menu_transition(-1, 10, 30))
                {
                    var _css = instance_create_depth(0, 0, -1, obj_charselect_menu);
                    menu_transition_end = _css;
                }
            }
        }
        else
        {
            with (obj_mainmenu_controller)
            {
                menu_main.prev_highlight_image_ind = menu_main.highlight_image_ind;
                start_menu_transition(menu_popup);
                menu_popup.set_buttons(0);
                menu_popup.width = undefined;
                menu_popup.height = undefined;
                menu_popup.auto_line_break = true;
                menu_popup.set_text(master.lang.menus.main.character_select_locked);
            }
        }
    };
    
    if (array_length(buttons) > 2)
    {
        buttons[2].onclick = function()
        {
            if (obj_mainmenu_controller.options_enabled)
            {
                with (obj_mainmenu_controller)
                {
                    start_menu_transition(menu_options);
                }
            }
            else
            {
                with (obj_mainmenu_controller)
                {
                    start_menu_transition(menu_popup);
                    menu_popup.set_buttons(0);
                    menu_popup.width = undefined;
                    menu_popup.height = undefined;
                    menu_popup.auto_line_break = true;
                    menu_popup.set_text("This option is disabled for now.");
                }
            }
        };
    }
    if (array_length(buttons) > 3)
    {
        buttons[3].onclick = function()
        {
            open_url("https://www.kickstarter.com/projects/holohammer/MINDWAVE");
        };
    }
    submenu = new menu_constructor();
    with (submenu)
    {
        add_text_button("Credits", function()
        {
            with (obj_mainmenu_controller)
            {
                start_menu_transition(menu_popup);
                menu_popup.set_buttons(0);
                menu_popup.width = 420;
                menu_popup.height = 170;
                menu_popup.auto_line_break = false;
                menu_popup.set_text("Megalo224 - Creative Direction, Art + Animation\r\nmook (Michael Herndon) - Project Management, Programming\r\nMilkshake (Isabelle Beardsworth) - Gameplay + VFX Programming\r\nDorkus64 - Music + SFX\r\nStarmy + mizu (Carlos Galindo) - Writing");
                
                menu_popup.buttons[0].onclick = function()
                {
                    menu_popup.set_text("Additional Art by nyrusin and quak\r\nwith Character Contributions from SleepyDeeDee and Red Grizzly\r\nand Popup Art by Kate Pine, EtudeF0rGh0sts, cheyennix, and MaxSludgeDog\r\nVoice Clips from April Herndon\r\nand Kickstarter Consulting by CHI XU");
                    
                    menu_popup.buttons[0].onclick = function()
                    {
                        start_menu_transition(menu_main);
                    };
                };
            }
        }, 477, 247, 2, 2);
        add_text_button("Quit Game", function()
        {
            with (obj_mainmenu_controller)
            {
                if (active_menu == menu_main)
                {
                    with (obj_mainmenu_controller)
                    {
                        start_menu_transition(menu_popup);
                    }
                    menu_popup.set_buttons(1);
                    
                    menu_popup.on_yes_click = function()
                    {
                        game_end();
                    };
                    
                    menu_popup.width = undefined;
                    menu_popup.height = undefined;
                    menu_popup.auto_line_break = false;
                    menu_popup.set_text(master.lang.menus.main.quit_confirm);
                }
            }
        }, 477, 267, 2, 2);
    }
    
    _tick = function()
    {
        if (keyboard_check_pressed(vk_escape))
        {
            with (obj_mainmenu_controller)
            {
                if (active_menu == menu_main && !instance_exists(obj_charselect_menu))
                {
                    with (obj_mainmenu_controller)
                    {
                        start_menu_transition(menu_title);
                    }
                }
            }
        }
        var _lerp = menu_in;
        submenu.x = cam_x - obj_mainmenu_controller.cam_x;
        submenu.y = cam_y - obj_mainmenu_controller.cam_y;
        submenu.focused = focused;
        submenu._tick();
        var input_allowed = obj_mainmenu_controller.active_menu == self && !instance_exists(obj_charselect_menu);
        var _hovered = false;
        var highlighted_ind = -1;
        if (highlight_cooldown <= 0)
        {
            prev_highlighted_button = -1;
        }
        var _active = true;
        with (obj_mainmenu_controller)
        {
            _active = active_menu == menu_main || active_menu == menu_popup || active_menu == menu_fileselect;
        }
        if (!_active || instance_exists(obj_charselect_menu))
        {
            input_allowed = false;
        }
        var _prev_highlight_ind = highlight_image_ind;
        for (var i = 0; i < array_length(buttons); i++)
        {
            buttons[i].x = (buttons_base_x + cam_x) - obj_mainmenu_controller.cam_x;
            buttons[i]._tick();
            buttons[i].highlighted = prev_highlighted_button == buttons[i];
            if (buttons[i].highlighted)
            {
                highlighted_ind = i;
            }
            if (_hovered)
            {
                continue;
            }
            var _crds = buttons[i].coords;
            _hovered = input_allowed && point_in_rectangle(mouse_x, mouse_y, _crds[0], _crds[1], _crds[2], _crds[3]);
            if (_hovered)
            {
                prev_highlighted_button = buttons[i];
                highlighted_ind = i;
                buttons[i].highlighted = true;
                cursor_hover = i;
                var hlimg = i % (array_length(highlight_images) - 1);
                highlight_image_ind = hlimg;
                if (get_input_click())
                {
                    sfx_play(buttons[i].click_sound);
                    buttons[i].highlighted = false;
                    buttons[i].onclick();
                }
            }
        }
        if (prev_highlighted_button == -1)
        {
            highlight_image_ind = array_length(highlight_images) - 1;
        }
        if (highlight_img_transition < 1)
        {
            highlight_img_transition += 0.1;
        }
        if (highlight_image_ind != _prev_highlight_ind)
        {
            if (highlight_img_transition < 1)
            {
            }
            else
            {
                prev_highlight_image_ind = _prev_highlight_ind;
                highlight_img_transition = 0;
            }
        }
        for (var i = 0; i < array_length(buttons) && prev_highlighted_button != -1; i++)
        {
            var _btn = buttons[i];
            if (i == highlighted_ind)
            {
                _btn.x_shift = lerp(_btn.x_shift, 10, 0.3);
                _btn.y_shift = lerp(_btn.y_shift, 0, 0.3);
            }
            else
            {
                var _ind_dist = highlighted_ind - i;
                var _dist = _ind_dist;
                _dist *= -8.5;
                _dist /= abs(_ind_dist);
                _btn.x_shift = lerp(_btn.x_shift, 0, 0.3);
                _btn.y_shift = lerp(_btn.y_shift, _dist, 0.3);
            }
        }
        if (_hovered || !input_allowed)
        {
            highlight_cooldown = 2;
        }
        else
        {
            cursor_hover = -1;
            if (prev_highlighted_button == -1)
            {
                for (var i = 0; i < array_length(buttons); i++)
                {
                    with (buttons[i])
                    {
                        x_shift = lerp(x_shift, 0, 0.3);
                        y_shift = lerp(y_shift, 0, 0.3);
                    }
                }
            }
            var _bt = prev_highlighted_button;
            if (_bt != -1)
            {
                var _coords = _bt.coords;
                if (highlight_cooldown > 0 && (!point_in_rectangle(mouse_x, mouse_y, _coords[0], _coords[1] - 26, _coords[2], _coords[3] + 26) || !input_allowed))
                {
                    highlight_cooldown--;
                }
            }
        }
        if (submenu.cursor_hover != -1)
        {
            cursor_hover = array_length(buttons);
        }
    };
    
    _draw = function()
    {
        var _inds = [prev_highlight_image_ind, highlight_image_ind];
        var _als = [highlight_img_transition, 1 - highlight_img_transition];
        for (var i = 0; i < array_length(_inds); i++)
        {
            var highlight_spd = sprite_get_speed(highlight_images[_inds[i]][0]);
            var highlight_frame = (current_time / 1000) * highlight_spd;
            var hoverart_x = submenu.x;
            var hoverart_y = submenu.y;
            draw_sprite_ditherfaded(highlight_images[_inds[i]][0], highlight_frame, hoverart_x, hoverart_y, _als[i], 1, 1, 0, 16777215, 0.75);
            blendmode_set_addglow();
            draw_sprite_ditherfaded(highlight_images[_inds[i]][1], highlight_frame, hoverart_x, hoverart_y, _als[i], 1, 1, 0, 16777215, 0.6);
            blendmode_reset();
        }
        if (highlight_image_ind == cursor_hover)
        {
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text_outline(submenu.x + 380, submenu.y + 222, highlight_text[highlight_image_ind]);
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
        }
        for (var i = 0; i < array_length(buttons); i++)
        {
            var _base_y = buttons[i].y;
            buttons[i].y += submenu.y;
            buttons[i]._draw();
            buttons[i].y = _base_y;
        }
        submenu._draw();
    };
}
menu_options = new menu_constructor();
with (menu_options)
{
    menu_in = 0;
    cam_x = -480;
    cam_y = 0;
    menu = new options_menu_constructor();
    
    tick_before = function()
    {
        menu.x = (cam_x - obj_mainmenu_controller.cam_x) + (240 - (menu.width / 2));
        menu.y = (cam_y - obj_mainmenu_controller.cam_y) + 5;
        menu.input_allowed = menu_in > 0.9;
        if (menu.input_allowed && focused && menu.screen == 0 && keyboard_check_pressed(vk_escape))
        {
            menu.on_exit();
            sfx_play(snd_menu_back);
            focused = false;
            menu.input_allowed = false;
        }
        else
        {
            menu._tick();
        }
    };
    
    draw_before = function()
    {
        if (menu_in > 0)
        {
            menu._draw();
            cursor_hover = menu.cursor_hover;
        }
    };
}

menu_options.menu.on_exit = function()
{
    if (obj_mainmenu_controller.start_menu_transition(obj_mainmenu_controller.menu_main))
    {
        with (menu_main)
        {
            highlight_img_transition = 1;
            highlight_image_ind = array_length(highlight_images) - 1;
        }
    }
};

menu_fileselect = new menu_constructor();
with (menu_fileselect)
{
    cam_x = 0;
    cam_y = 0;
    add_sprite_button(spr_phfileselect_new, function()
    {
        if (!instance_exists(transition_controller))
        {
            buttons[0].click_sound = -1;
            buttons[1].click_sound = -1;
            buttons[2].click_sound = -1;
            audio_sound_gain(obj_mainmenu_controller.music, 0, 1000);
            with (master)
            {
                story_flags = struct_copy(default_story_flags);
            }
            var _tr = start_transition(transition_perlin);
            _tr.pause_frames += 120;
            
            _tr.on_intro_end = function()
            {
                instance_destroy(obj_mainmenu_controller);
                play_cutscene(cs_0_1);
                storymode_save();
            };
        }
    });
    buttons[0].click_sound = snd_menu_click_major;
    add_sprite_button(spr_phfileselect_continue, function()
    {
        if (!instance_exists(transition_controller))
        {
            buttons[0].click_sound = -1;
            buttons[1].click_sound = -1;
            buttons[2].click_sound = -1;
            audio_sound_gain(obj_mainmenu_controller.music, 0, 1000);
            var _tr = start_transition(transition_perlin);
            
            _tr.on_intro_end = function()
            {
                instance_destroy(obj_mainmenu_controller);
                storymode_load();
            };
        }
    });
    if (!story_file_exists())
    {
        buttons[1].image_index = 2;
        buttons[1].clickable = false;
    }
    buttons[1].click_sound = snd_menu_click_major;
    add_sprite_button(spr_phfileselect_back, function()
    {
        if (!instance_exists(transition_controller))
        {
            buttons[0].click_sound = -1;
            buttons[1].click_sound = -1;
            buttons[2].click_sound = -1;
            with (obj_mainmenu_controller)
            {
                start_menu_transition(menu_main);
            }
        }
    });
    buttons[2].click_sound = snd_menu_back;
    x = 240;
    y = -270;
    menu_in = 0;
    
    draw_before = function()
    {
        draw_set_alpha(menu_in * 0.5);
        draw_set_color(c_black);
        draw_rectangle(-1, -1, 481, 271, false);
        draw_set_color(c_white);
        draw_set_alpha(1);
        y = lerp(-270, 135, menu_in);
        draw_popupbox(x, y);
    };
}
menu_popup = new menu_constructor();
with (menu_popup)
{
    cam_x = 0;
    cam_y = 0;
    
    set_buttons = function(arg0 = 0)
    {
        buttons = [];
        switch (arg0)
        {
            case 0:
                add_text_button(master.lang.menus.main.popup_button_ok, function()
                {
                    with (obj_mainmenu_controller)
                    {
                        start_menu_transition(menu_main);
                    }
                }, 0, 40, 1, 1);
                break;
            case 1:
                add_text_button(master.lang.menus.main.popup_button_no, function()
                {
                    with (obj_mainmenu_controller)
                    {
                        start_menu_transition(menu_main);
                    }
                    on_no_click();
                }, 25, 40, 1, 1);
                add_text_button(master.lang.menus.main.popup_button_yes, function()
                {
                    with (obj_mainmenu_controller)
                    {
                        start_menu_transition(menu_main);
                    }
                    on_yes_click();
                }, -25, 40, 1, 1);
                buttons[0].y -= 100;
                break;
        }
    };
    
    on_yes_click = function()
    {
    };
    
    on_no_click = function()
    {
    };
    
    set_buttons();
    x = 240;
    y = -270;
    menu_in = 0;
    text = "";
    width = undefined;
    height = undefined;
    auto_line_break = true;
    textbox = new textbox_constructor();
    
    set_text = function(arg0)
    {
        if (is_undefined(width))
        {
            width = 221;
        }
        if (is_undefined(height))
        {
            height = 128;
        }
        textbox.width = width - 20;
        textbox.use_auto_break = auto_line_break;
        textbox.set_text(arg0);
    };
    
    draw_before = function()
    {
        if (menu_in == 0)
        {
            exit;
        }
        if (is_undefined(width))
        {
            width = 221;
        }
        if (is_undefined(height))
        {
            height = 128;
        }
        buttons[0].y = (height / 2) - 30;
        draw_set_alpha(menu_in * 0.5);
        draw_set_color(c_black);
        draw_rectangle(-1, -1, 481, 271, false);
        draw_set_color(c_white);
        draw_set_alpha(1);
        y = lerp(-270, 135, menu_in);
        draw_popupbox(x, y, width, height);
        textbox.draw(x, y);
    };
}
active_menu = menu_title;
menus = [menu_title, menu_main, menu_fileselect, menu_options, menu_popup];

tick_all_menus = function()
{
    for (var i = 0; i < array_length(menus); i++)
    {
        menus[i].focused = menus[i] == active_menu && !transition_happening;
        menus[i]._tick();
    }
};

tick_all_menus();

draw_all_menus = function()
{
    for (var i = 0; i < array_length(menus); i++)
    {
        menus[i]._draw();
    }
};

mmbg_args = 
{
    overlay_col: 11929488,
    things_sprite: spr_mmbg_8stuff,
    things_image_index: 0,
    blend_things_sprite: spr_mmbg_8stuff,
    blend_things_image_index: 1,
    things_blend_amount: 1,
    x: 0,
    y: 0
};

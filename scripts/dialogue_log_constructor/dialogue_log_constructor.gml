function dialogue_log_constructor() constructor
{
    x = 0;
    y = 0;
    list = [];
    scroll = 0;
    intro = true;
    display = 0;
    entries_onscreen = 3.25;
    frame_sprite = spr_dialogue_log_frame;
    mask_sprite = spr_dialogue_log_mask;
    image_index = 0;
    bg_color = 5575783;
    frame_color = 10432091;
    name_color = 2031655;
    var _bbox_l = sprite_get_bbox_left(mask_sprite);
    var _bbox_t = sprite_get_bbox_top(mask_sprite);
    var _bbox_r = sprite_get_bbox_right(mask_sprite);
    var _bbox_b = sprite_get_bbox_bottom(mask_sprite);
    var _bbox_w = _bbox_r - _bbox_l;
    var _bbox_h = _bbox_b - _bbox_t;
    surface = surface_create(_bbox_w + 2, _bbox_h + 2);
    sf_x = _bbox_l;
    sf_y = _bbox_t;
    scanlines_y = 0;
    is_open = false;
    open_progress = 0;
    open_display = 0;
    hovering = false;
    textboxes = [];
    text_h_space = 245;
    scrollbar = new scrollbar_constructor();
    scrollbar.x = 397;
    scrollbar.y = 40;
    scrollbar.container_width = 22;
    scrollbar.container_height = 199;
    scrollbar.scroll_wheel_strength = 0.25;
    scrollbar.inverse = true;
    scrollbar.bar_sprite = spr_dialogue_log_scrollbar;
    scrollbar.show_container = false;
    
    open = function()
    {
        scroll = 0;
        scrollbar.scroll = 0;
        is_open = true;
        textboxes = [];
        for (var i = 0; i < array_length(list); i++)
        {
            var _entry = list[i];
            var _str = _entry.text;
            var _fnt = draw_get_font();
            draw_set_font(fnt_dialogue);
            var _tb = new textbox_constructor();
            _tb.width = text_h_space;
            _tb.set_text(_str);
            draw_set_font(_fnt);
            textboxes[i] = _tb;
        }
        sfx_play(snd_log_open);
    };
    
    close = function()
    {
        if (is_open && open_progress > 0)
        {
            is_open = false;
            var _offs = (1 - open_progress) * 0.5;
            sfx_play(snd_log_close, false, 1, _offs);
            audio_stop_sound(snd_log_open);
        }
    };
    
    _on_close = function()
    {
    };
    
    _tick = function()
    {
        image_index += (sprite_get_speed(frame_sprite) / room_speed);
        image_index %= 6;
        if (keyboard_check_pressed(vk_tab) || keyboard_check_pressed(vk_escape))
        {
            close();
        }
        open_progress += (sign(real(is_open) - open_progress) * (1/15));
        if (is_open)
        {
            open_display = open_progress;
        }
        else
        {
            open_display = open_progress;
            if (open_progress == 0)
            {
                scrollbar.drag = false;
                _on_close();
            }
        }
        open_display = clamp(open_display, 0, 1);
        y = round(lerp(-270, 0, lerp_easeOutBack(open_display)));
        scrollbar.x = x + 397;
        scrollbar.y = y + 40;
        scrollbar.allow_input = is_open;
        scrollbar.tick();
        hovering = scrollbar.hovering;
        if (is_open)
        {
            scroll = lerp(scroll, scrollbar.scroll, 0.5);
            var closespr = spr_dialogue_log_frame_close;
            var close_x1 = x + sprite_get_bbox_left(closespr);
            var close_y1 = y + sprite_get_bbox_top(closespr);
            var close_x2 = x + sprite_get_bbox_right(closespr);
            var close_y2 = y + sprite_get_bbox_bottom(closespr);
            if (point_in_rectangle(mouse_x, mouse_y, close_x1, close_y1, close_x2, close_y2))
            {
                hovering = true;
                if (get_input_click())
                {
                    close();
                }
            }
        }
    };
    
    _draw = function()
    {
        if (open_progress <= 0)
        {
            exit;
        }
        var scrollstart = scroll;
        scroll = round_to_multiple(scroll, 0.0625);
        if (surface == -1)
        {
            exit;
        }
        blendmode_set_multiply();
        draw_clear(c_white);
        draw_sprite_ext(spr_dialogue_log_bg_overlay, 0, 0, 0, 1, 1, 0, c_white, open_display);
        blendmode_reset();
        var _bbox_l = sprite_get_bbox_left(mask_sprite);
        var _bbox_t = sprite_get_bbox_top(mask_sprite);
        var _bbox_r = sprite_get_bbox_right(mask_sprite);
        var _bbox_b = sprite_get_bbox_bottom(mask_sprite);
        var _bbox_w = _bbox_r - _bbox_l;
        var _bbox_h = _bbox_b - _bbox_t;
        sf_x = x + _bbox_l;
        sf_y = y + _bbox_t;
        if (!surface_exists(surface))
        {
            surface = surface_create(_bbox_w + 2, _bbox_h + 2);
        }
        sprite_set_offset(mask_sprite, _bbox_l, _bbox_t);
        sprite_set_offset(spr_dialogue_log_bg, _bbox_l, _bbox_t);
        sprite_set_offset(spr_dialogue_log_multunder, _bbox_l, _bbox_t);
        surface_set_target(surface);
        draw_clear_alpha(c_white, 0);
        draw_sprite(mask_sprite, image_index, 0, 0);
        gpu_set_colorwriteenable(1, 1, 1, 0);
        draw_sprite(spr_dialogue_log_bg, 0, 0, 0);
        var scrollbar_container_w = 22;
        var menu_w = _bbox_w - scrollbar_container_w;
        var menu_h = _bbox_h;
        var x_margin = 16;
        var head_h_space = surface_get_width(surface) - (x_margin * 2) - text_h_space - 15;
        var y_margin = 6;
        var entry_height = (menu_h - (y_margin * 2)) / entries_onscreen;
        var entry_start_y = menu_h - entry_height - y_margin;
        var _list = list;
        scrollbar.max_scroll = array_length(_list) - entries_onscreen;
        var _fnt = draw_get_font();
        draw_set_font(fnt_dialogue);
        var start_i = array_length(_list) - 1 - scroll;
        var i = ceil(start_i) + 1;
        while (i >= max(0, ceil(start_i) - entries_onscreen - 1))
        {
            var yy = round(entry_start_y + (entry_height * (i - start_i)));
            var _sep_w = menu_w - 16 - 3;
            var _sep_x = ((menu_w / 2) - (_sep_w / 2)) + 5;
            if (i > 0 && i <= (array_length(_list) - 1))
            {
                draw_sprite_ext(spr_dialogue_log_seperator, 0, _sep_x, yy, _sep_w, 1, 0, c_white, 1);
            }
            if (i == (array_length(_list) - 1) && array_length(_list) < entries_onscreen)
            {
                draw_sprite_ext(spr_dialogue_log_seperator, 0, _sep_x, yy + entry_height, _sep_w, 1, 0, c_white, 1);
            }
            if (i < array_length(_list))
            {
                var entry = _list[i];
                var xx = x_margin;
                var _order = [0, 1];
                if (entry.speaker_side == -1)
                {
                    _order = [1, 0];
                }
                for (var j = 0; j < 2; j++)
                {
                    switch (_order[j])
                    {
                        case 0:
                            var _tb = textboxes[i];
                            var textx = 0;
                            var _align = 0;
                            if (j == 0)
                            {
                                textx = text_h_space;
                                _align = 2;
                            }
                            _tb.halign = _align;
                            _tb.draw(xx + textx, yy + (entry_height / 2));
                            xx += text_h_space;
                            break;
                        case 1:
                            var headx = round(xx + (head_h_space / 2) + ((x_margin / 2) * entry.speaker_side));
                            draw_set_color(name_color);
                            draw_set_halign(fa_center);
                            draw_set_valign(fa_top);
                            var _name = strloc("character_names/" + entry.speaker_name);
                            var _nudge_down = 0;
                            if (string_height(_name) > 0)
                            {
                                _nudge_down = string_height(_name) / 2;
                            }
                            draw_text(headx, yy + 2 + _nudge_down, _name);
                            draw_set_color(c_white);
                            draw_set_halign(fa_left);
                            var _head_spr = entry.speaker_icon;
                            draw_sprite(_head_spr, 0, headx, yy + _nudge_down + (entry_height / 2));
                            xx += head_h_space;
                            break;
                    }
                }
            }
            i--;
        }
        draw_set_font(_fnt);
        gpu_set_colorwriteenable(1, 1, 1, 1);
        surface_reset_target();
        scroll = scrollstart;
        draw_surface(surface, sf_x, sf_y);
        scrollbar.draw();
        blendmode_set_multiply();
        draw_sprite(spr_dialogue_log_multunder, 0, sf_x, sf_y);
        blendmode_reset();
        draw_sprite(frame_sprite, image_index, x, y);
        if ((image_index % 2) > 0)
        {
            draw_sprite(spr_dialogue_log_frame_close, image_index, x, y);
            draw_sprite(spr_dialogue_log_frame_topelec, image_index, x, y);
            draw_sprite(spr_dialogue_log_frame_tubeleft, image_index, x, y);
            draw_sprite(spr_dialogue_log_frame_tuberight, image_index, x, y);
        }
        draw_sprite(spr_dialogue_log_frame_topelec2, image_index, x, y);
        var glow_alpha = (dsin((current_time / 1000 / 3) * 360) * 0.5) + 0.5;
        glow_alpha = round_to_multiple(glow_alpha, 0.1);
        blendmode_set_add();
        draw_sprite_ext(spr_dialogue_log_frame_glowface, 0, x, y, 1, 1, 0, c_white, glow_alpha);
        blendmode_reset();
    };
    
    _destroy = function()
    {
        surface_free(surface);
        surface = -1;
    };
}

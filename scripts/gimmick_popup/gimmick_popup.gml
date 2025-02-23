function gimmick_popup() : gimmick_constructor() constructor
{
    popups = [];
    time = 0;
    wait_for_minigame = true;
    appear_time_lower = room_speed * 3;
    appear_time_upper = room_speed * 6;
    first_popup_appear_time = infinity;
    finish_time = infinity;
    finish_round = infinity;
    sprites = [spr_popup_s1, spr_popup_s2, spr_popup_s3, spr_popup_s4, spr_popup_s5, spr_popup_s6, spr_popup_s7, spr_popup_s8];
    sounds = [];
    amount_appeared = 0;
    amount_busted = 0;
    amount_to_bust = 15;
    appear_timer = 0;
    appear_timer_speed = 1;
    
    set_appear_timer_speed = function()
    {
        return 1;
    };
    
    minigame_seen = false;
    grid_x = 5;
    grid_y = 5;
    cells_x = 10;
    cells_y = 5;
    cell_width = 47;
    cell_height = 52;
    cell_weights_default = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
    cells_free = array_create(cells_x * cells_y, 1);
    cell_weights = [];
    array_copy(cell_weights, 0, cell_weights_default, 0, array_length(cell_weights_default));
    
    set_cell_weight = function(arg0, arg1, arg2)
    {
        cell_weights[xy_to_index(arg0, arg1)] = arg2;
    };
    
    add_cell_weight = function(arg0, arg1, arg2)
    {
        cell_weights[xy_to_index(arg0, arg1)] += arg2;
    };
    
    index_to_xy = function(arg0)
    {
        var _xy = 
        {
            x: 0,
            y: 0
        };
        _xy.x = arg0 % cells_x;
        _xy.y = floor(arg0 / cells_x);
        return _xy;
    };
    
    xy_to_index = function(arg0, arg1)
    {
        if (arg0 >= 0 && arg0 < cells_x && arg1 >= 0 && arg1 < cells_y)
        {
            return arg0 + (arg1 * cells_x);
        }
        else
        {
            return -1;
        }
    };
    
    cell_xy_to_screen = function(arg0, arg1)
    {
        var _xy = 
        {
            x: 0,
            y: 0
        };
        _xy.x = grid_x + (arg0 * cell_width);
        _xy.y = grid_y + (arg1 * cell_height);
        return _xy;
    };
    
    screen_xy_to_cell = function(arg0, arg1)
    {
    };
    
    add_popup_at_pos = function(arg0, arg1, arg2)
    {
        var cells_w = round(sprite_get_width(arg0) / cell_width);
        var cells_h = round(sprite_get_height(arg0) / cell_height);
        var _inds_used = [];
        for (var i = 0; i < cells_w; i++)
        {
            for (var j = 0; j < cells_h; j++)
            {
                var _ind = xy_to_index(arg1 + i, arg2 + j);
                array_push(_inds_used, _ind);
                cells_free[_ind] -= 1;
            }
        }
        var _xy = cell_xy_to_screen(arg1, arg2);
        arg1 = _xy.x + sprite_get_xoffset(arg0);
        arg2 = _xy.y + sprite_get_yoffset(arg0);
        var sound_x = (((arg1 + (sprite_get_width(arg0) / 2)) - (get_screen_width() / 2)) * 60) + (get_screen_width() / 2);
        var sound_y = get_screen_height() / 2;
        amount_appeared++;
        var _area = cells_w * cells_h;
        var _sound = sfx_play(snd_gimmick_popup_loop, true, lerp(0, 0.3, _area / 6), random(audio_sound_length(snd_gimmick_popup_loop)), random_range(0.9, 1.2), false, 
        {
            x: sound_x,
            y: sound_y,
            z: 0
        }, false);
        array_push(sounds, _sound);
        var _gimmick = self;
        var _popup = 
        {
            x: arg1,
            y: arg2,
            xmod: 0,
            ymod: 0,
            sprite: arg0,
            time: 0,
            used_cells: _inds_used,
            sound: _sound,
            gimmick: _gimmick,
            close_time: infinity,
            close_anim: 0
        };
        with (_popup)
        {
            _start_close = function()
            {
                close_time = time;
            };
            
            _close = function()
            {
                for (var j = 0; j < array_length(used_cells); j++)
                {
                    gimmick.cells_free[used_cells[j]] += 1;
                }
                audio_stop_sound(sound);
                var _me = self;
                with (gimmick)
                {
                    array_delete(popups, array_get_index(popups, _me), 1);
                    amount_busted++;
                    if (amount_busted >= amount_to_bust)
                    {
                        finish_time = time;
                    }
                }
            };
        }
        array_push(popups, _popup);
    };
    
    add_popup = function(arg0)
    {
        var cells_w = round(sprite_get_width(arg0) / cell_width);
        var cells_h = round(sprite_get_height(arg0) / cell_height);
        var cell_index = -1;
        if (array_length(popups) == 0)
        {
            var cell_max_x = cells_x - 1 - (cells_w - 1);
            var cell_max_y = cells_y - 1 - (cells_h - 1);
            cell_index = xy_to_index(irandom(cell_max_x), irandom(cell_max_y));
        }
        else
        {
            var _fits = [];
            for (var _layer = 0; array_length(_fits) == 0; _layer++)
            {
                for (var i = 0; i < min(array_length(cells_free), cells_x * cells_y); i++)
                {
                    var _xy = index_to_xy(i);
                    var _test_base_cell_x = _xy.x;
                    var _test_base_cell_y = _xy.y;
                    var space_free = true;
                    var this_space_free_area = 0;
                    for (var tx = _test_base_cell_x; tx < (_test_base_cell_x + cells_w) && space_free; tx++)
                    {
                        for (var ty = _test_base_cell_y; ty < (_test_base_cell_y + cells_h) && space_free; ty++)
                        {
                            if (tx >= cells_x || ty >= cells_y)
                            {
                                space_free = false;
                            }
                            else
                            {
                                var _ind = xy_to_index(tx, ty);
                                if (_ind != -1)
                                {
                                    this_space_free_area += (cells_free[_ind] + _layer);
                                }
                            }
                        }
                    }
                    space_free = space_free && this_space_free_area >= (cells_w * cells_h);
                    if (space_free)
                    {
                        array_push(_fits, i);
                    }
                }
            }
            if (array_length(_fits) > 0)
            {
                cell_index = _fits[irandom(array_length(_fits) - 1)];
            }
        }
        if (cell_index != -1)
        {
            var _cell_xy = index_to_xy(cell_index);
            add_popup_at_pos(arg0, _cell_xy.x, _cell_xy.y);
        }
    };
    
    _init = function()
    {
        amount_appeared = 0;
        amount_busted = 0;
        appear_timer = irandom_range(appear_time_lower, appear_time_upper);
        if (first_popup_appear_time < infinity)
        {
            appear_timer = first_popup_appear_time;
        }
        start_finish = false;
        cursor_hover = -1;
        cursor_x = 0;
        cursor_y = 0;
    };
    
    _tick_before = function()
    {
        var clicked = false;
        cursor_hover = -1;
        var i = array_length(popups) - 1;
        while (i >= 0)
        {
            var _popup = popups[i];
            _popup.time++;
            if ((_popup.time % 10) == 0)
            {
                _popup.xmod = irandom_range(-2, 2);
                _popup.ymod = irandom_range(-2, 2);
            }
            var _dx = _popup.x + _popup.xmod;
            var _dy = _popup.y + _popup.ymod;
            var _spr = _popup.sprite;
            var xorigin1 = sprite_get_xoffset(_spr);
            var yorigin1 = sprite_get_yoffset(_spr);
            var x1 = (_dx - xorigin1) + sprite_get_bbox_left(_spr);
            var y1 = (_dy - yorigin1) + sprite_get_bbox_top(_spr);
            var x2 = (_dx - xorigin1) + sprite_get_bbox_right(_spr);
            var y2 = (_dy - yorigin1) + sprite_get_bbox_bottom(_spr);
            var mouse_over_box = point_in_rectangle(mouse_x, mouse_y, _dx - xorigin1, _dy - yorigin1, (_dx - xorigin1) + sprite_get_width(_spr), (_dy - yorigin1) + sprite_get_height(_spr));
            if (mouse_over_box)
            {
                cursor_hover = -1;
            }
            if (point_in_rectangle(mouse_x, mouse_y, x1, y1, x2, y2))
            {
                cursor_hover = i;
            }
            if (mouse_check_button_pressed(mb_left) && !clicked && _popup.time >= 30)
            {
                if (cursor_hover == i)
                {
                    clicked = true;
                    sfx_play(snd_menu_click_minor, false, 0.4);
                    _popup._start_close();
                    i--;
                }
                else if (mouse_over_box)
                {
                    clicked = true;
                }
            }
            var _close_anim = clamp((_popup.time - _popup.close_time) / 5, 0, 1);
            _popup.close_anim = _close_anim;
            if (_close_anim == 1)
            {
                _popup._close();
            }
            i--;
        }
        if (appear_timer > 0)
        {
            if (obj_minigame_controller.char._round < finish_round)
            {
                if (!wait_for_minigame || (wait_for_minigame && minigame_seen))
                {
                    appear_timer -= set_appear_timer_speed();
                }
                if (wait_for_minigame && !minigame_seen)
                {
                    if (array_length(obj_minigame_controller.active_mgs) > 0 && obj_minigame_controller.inbetween_timer <= 0)
                    {
                        minigame_seen = true;
                    }
                }
            }
            else if (array_length(popups) == 0)
            {
                start_finish = true;
            }
        }
        else if (amount_appeared < amount_to_bust && !start_finish && !blacklisted_by_minigame)
        {
            var _sprite = sprites[irandom(array_length(sprites) - 1)];
            add_popup(_sprite);
            appear_timer = irandom_range(appear_time_lower, appear_time_upper);
        }
        time++;
        blacklistable = array_length(popups) > 0;
        if (start_finish)
        {
            if (array_length(popups) == 0)
            {
                __deleted = true;
            }
        }
        else if (time > (finish_time + 60))
        {
            _finish();
        }
        cursor_x = mouse_x;
        cursor_y = mouse_y;
    };
    
    _tick_after = function()
    {
    };
    
    _draw_before = function()
    {
    };
    
    _draw_after = function()
    {
        for (var i = 0; i < array_length(popups); i++)
        {
            var _popup = popups[i];
            var _close = _popup.close_anim;
            var _df = _popup.time * (sprite_get_speed(_popup.sprite) / 60);
            var _dx = _popup.x + _popup.xmod;
            var _dy = _popup.y + _popup.ymod;
            var _tt = clamp(_popup.time / 30, 0, 1);
            var _dxs = abs(lerp(0, 1, lerp_easeInOutBack(_tt)));
            var _dys = lerp(1.3, 1, lerp_easeInOutBack(_tt)) * clamp(_tt / 0.25, 0, 1);
            _dxs *= lerp(1, 0.8, _close);
            _dys *= lerp(1, 0.8, _close);
            var _ditherfade = max(_close, get_blacklist_weight() * 0.75);
            if (_ditherfade == 0 && _tt == 1)
            {
                var _offx = sprite_get_xoffset(_popup.sprite);
                var _offy = sprite_get_yoffset(_popup.sprite);
                var _x1 = _dx - _offx;
                var _y1 = _dy - _offy;
                var _x2 = (_x1 + sprite_get_width(_popup.sprite)) - 1;
                var _y2 = (_y1 + sprite_get_height(_popup.sprite)) - 1;
                draw_rectangle(_x1, _y1, _x2, _y2, false);
            }
            draw_sprite_ditherfaded(_popup.sprite, _df, _dx, _dy, _ditherfade, _dxs, _dys);
        }
        if (array_length(popups) > 0)
        {
            var _fr = 0;
            if (cursor_hover >= 0)
            {
                _fr = 1;
            }
            if (_fr && mouse_check_button(mb_left))
            {
                _fr = 2;
            }
            var crsprite = spr_cursor_basic;
            draw_sprite_ext(crsprite, _fr, cursor_x, cursor_y, 2, 2, 0, c_white, 1);
        }
    };
    
    _finish = function()
    {
        for (var i = 0; i < array_length(popups); i++)
        {
            popups[i]._start_close();
        }
        start_finish = true;
    };
}

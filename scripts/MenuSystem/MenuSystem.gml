function menu_constructor() constructor
{
    buttons = [];
    highlighted_button = -1;
    virtual_cursor_hover = -1;
    cursor_hover = -1;
    vc_last = -1;
    focused = true;
    x = 0;
    y = 0;
    
    button = function() constructor
    {
        parent = -1;
        x = 0;
        y = 0;
        width = 100;
        height = 50;
        offset_x = 0;
        offset_y = 0;
        text = "Button";
        _sprite = -1;
        clickable = true;
        image_index = 0;
        image_speed = 1;
        click_sound = snd_menu_click;
        
        onpress = function()
        {
        };
        
        onrelease = function()
        {
        };
        
        onclick = function()
        {
        };
        
        onhover = function()
        {
        };
        
        whenhovered = function()
        {
        };
        
        onunhover = function()
        {
        };
        
        _tick = function()
        {
            if (sprite_exists(_sprite))
            {
                var stype = sprite_get_speed_type(_sprite);
                var _spd = sprite_get_speed(_sprite) * image_speed;
                switch (stype)
                {
                    case 0:
                        image_index += (_spd / room_speed);
                        break;
                    case 1:
                        image_index += _spd;
                        break;
                }
                image_index %= sprite_get_number(_sprite);
            }
        };
        
        _draw = function()
        {
            var coords = get_coords();
            if (sprite_exists(_sprite) && _sprite != -1)
            {
                draw_sprite(_sprite, image_index, x, y);
            }
            else
            {
                draw_rectangle(coords[0], coords[1], coords[2], coords[3], true);
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_text(x + (width / 2), y + (height / 2), text);
                draw_set_halign(fa_left);
                draw_set_valign(fa_top);
            }
        };
        
        set_sprite = function(arg0)
        {
            _sprite = arg0;
            frame = 0;
            var bbox = [sprite_get_bbox_left(_sprite), sprite_get_bbox_top(_sprite), sprite_get_bbox_right(_sprite), sprite_get_bbox_bottom(_sprite)];
            var offs = [sprite_get_xoffset(_sprite), sprite_get_yoffset(_sprite)];
            width = bbox[2] - bbox[0];
            height = bbox[3] - bbox[1];
            offset_x = bbox[0] - offs[0];
            offset_y = bbox[1] - offs[1];
        };
        
        get_coords = function()
        {
            return [round(offset_x + x), round(offset_y + y), round(offset_x + x + width), round(offset_y + y + height)];
        };
        
        _hovered = false;
        _pressed = false;
        _curxstart = 0;
        _curystart = 0;
    };
    
    add_text_button = function(arg0, arg1 = function()
    {
    }, arg2 = 0, arg3 = 0, arg4 = 0, arg5 = 0)
    {
        var _btn = new button();
        var _parent = self;
        _btn.text = arg0;
        with (_btn)
        {
            parent = _parent;
            width = string_width(arg0) + 6;
            height = string_height("A") + 6;
            switch (arg4)
            {
                case 0:
                    break;
                case 1:
                    arg2 -= (width / 2);
                    break;
                case 2:
                    arg2 -= width;
                    break;
            }
            switch (arg5)
            {
                case 0:
                    break;
                case 1:
                    arg3 -= (height / 2);
                    break;
                case 2:
                    arg3 -= height;
                    break;
            }
            onclick = arg1;
            x = arg2;
            y = arg3;
        }
        array_push(buttons, _btn);
        return _btn;
    };
    
    add_sprite_button = function(arg0, arg1 = function()
    {
    }, arg2 = 0, arg3 = 0)
    {
        var _btn = new button();
        var _parent = self;
        with (_btn)
        {
            parent = _parent;
            set_sprite(arg0);
            image_speed = 0;
            image_index = 0;
            
            onhover = function()
            {
                image_index = 1;
            };
            
            onunhover = function()
            {
                image_index = 0;
            };
            
            onclick = arg1;
            x = arg2;
            y = arg3;
        }
        array_push(buttons, _btn);
        return _btn;
    };
    
    mouse_x_prev = mouse_x;
    mouse_y_prev = mouse_y;
    
    tick_before = function()
    {
    };
    
    tick_after = function()
    {
    };
    
    draw_before = function()
    {
    };
    
    draw_after = function()
    {
    };
    
    _tick = function()
    {
        tick_before();
        var kdV = keyboard_check_pressed(ord("S")) - keyboard_check_pressed(ord("W"));
        var kdH = keyboard_check_pressed(ord("D")) - keyboard_check_pressed(ord("A"));
        kdV += (keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up));
        kdH += (keyboard_check_pressed(vk_left) - keyboard_check_pressed(vk_right));
        kdV = sign(kdV);
        kdH = sign(kdH);
        kdV = 0;
        kdH = 0;
        if (focused)
        {
            if (virtual_cursor_hover == -1)
            {
                if (abs(kdV) || abs(kdH))
                {
                    if (vc_last < 0 || vc_last >= array_length(buttons))
                    {
                        vc_last = 0;
                    }
                    virtual_cursor_hover = vc_last;
                    if (cursor_hover == -1)
                    {
                        kdV = 0;
                        kdH = 0;
                    }
                }
            }
            else
            {
                vc_last = virtual_cursor_hover;
                if (point_distance(mouse_x, mouse_y, mouse_x_prev, mouse_y_prev) > 2)
                {
                    virtual_cursor_hover = -1;
                }
            }
            var _cont = self;
            var curx, cury, curhold, curclick;
            if (virtual_cursor_hover == -1)
            {
                curx = mouse_x;
                cury = mouse_y;
                curclick = mouse_check_button_pressed(mb_left);
                curhold = mouse_check_button(mb_left);
                cursor_hover = -1;
            }
            else
            {
                var bt = buttons[virtual_cursor_hover];
                curx = bt.x + 1;
                cury = bt.y + 1;
                curclick = false;
                curhold = false;
                if (abs(kdV) || abs(kdH))
                {
                    virtual_cursor_hover += kdV;
                    if (virtual_cursor_hover < 0)
                    {
                        virtual_cursor_hover += array_length(buttons);
                    }
                    if (virtual_cursor_hover >= array_length(buttons))
                    {
                        virtual_cursor_hover -= array_length(buttons);
                    }
                }
            }
            for (var i = 0; i < array_length(buttons); i++)
            {
                var bt = buttons[i];
                bt.x += x;
                bt.y += y;
                with (bt)
                {
                    var coords = get_coords();
                    _hovered = _hovered && clickable;
                    if (_hovered)
                    {
                        if (_cont.cursor_hover == -1)
                        {
                            _cont.cursor_hover = i;
                            _cont.vc_last = i;
                        }
                        if (point_in_rectangle(curx, cury, coords[0], coords[1], coords[2], coords[3]))
                        {
                            whenhovered();
                            if (_pressed)
                            {
                                if (point_distance(curx, cury, _curxstart, _curystart) > 5)
                                {
                                    if (!curhold)
                                    {
                                        onrelease();
                                        _pressed = false;
                                    }
                                }
                                else if (!curhold)
                                {
                                    master.click = 0;
                                    _pressed = false;
                                    sfx_play(click_sound);
                                    onrelease();
                                    onclick();
                                }
                            }
                            else if (curclick)
                            {
                                _pressed = true;
                                _curxstart = curx;
                                _curystart = cury;
                                onpress();
                            }
                            else
                            {
                                onrelease();
                            }
                        }
                        else
                        {
                            onunhover();
                            _cont.cursor_hover = -1;
                            _hovered = false;
                        }
                    }
                    else if (clickable && point_in_rectangle(curx, cury, coords[0], coords[1], coords[2], coords[3]))
                    {
                        _hovered = true;
                        onhover();
                    }
                    _tick();
                }
                bt.x -= x;
                bt.y -= y;
            }
        }
        else
        {
            virtual_cursor_hover = -1;
            cursor_hover = -1;
            vc_last = -1;
        }
        mouse_x_prev = mouse_x;
        mouse_y_prev = mouse_y;
        tick_after();
    };
    
    _draw = function()
    {
        draw_before();
        for (var i = 0; i < array_length(buttons); i++)
        {
            var bt = buttons[i];
            bt.x += x;
            bt.y += y;
            with (bt)
            {
				_draw();
            }
            bt.x -= x;
            bt.y -= y;
        }
        draw_after();
    };
    
    tick = _tick;
    draw = _draw;
}

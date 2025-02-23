function draw_sprite_nineslice(arg0, arg1, arg2, arg3, arg4, arg5)
{
    var info = sprite_get_nineslice(arg0);
    var _replace_info = sprite_nineslice_create();
    _replace_info.enabled = false;
    sprite_set_nineslice(arg0, _replace_info);
    if (!info.enabled)
    {
        exit;
    }
    var l = info.left;
    var r = info.right;
    var t = info.top;
    var b = info.bottom;
    var tile_l = info.tilemode[0];
    var tile_t = info.tilemode[1];
    var tile_r = info.tilemode[2];
    var tile_b = info.tilemode[3];
    var tile_c = info.tilemode[4];
    var _sprite_width = sprite_get_width(arg0);
    var _sprite_height = sprite_get_height(arg0);
    var xoff = sprite_get_xoffset(arg0);
    var yoff = sprite_get_yoffset(arg0);
    arg2 -= ((_sprite_width - xoff) * (arg4 / _sprite_width));
    arg3 -= ((_sprite_height - yoff) * (arg5 / _sprite_height));
    var w = arg4;
    var h = arg5;
    var _tiles = [[0, 0, l, t, -1, -1], [l, 0, w - r - l, t, tile_t, 0], [w - r, 0, r, t, -1, -1], [0, t, l, h - b - t, tile_l, 1], [l, r, w - l - r, h - b - t, tile_c, 2], [w - r, t, r, h - b - t, tile_r, 1], [0, h - b, l, b, -1, -1], [l, h - b, w - l - r, b, tile_b, 0], [w - r, h - b, r, b, -1, -1]];
    for (var i = 0; i < array_length(_tiles); i++)
    {
        var tile = _tiles[i];
        var _left = tile[0];
        var _top = tile[1];
        var _x = floor(arg2 + _left);
        var _y = floor(arg3 + _top);
        var _width_pixels = tile[2];
        var _height_pixels = tile[3];
        var _tilemode = tile[4];
        var _extend_dir = tile[5];
        var _xreps = 1;
        var _yreps = 1;
        var _xscale = 1;
        var _yscale = 1;
        var _x_add = 0;
        var _y_add = 0;
        var repeat_mode = false;
        var _mirror_x = false;
        var _mirror_y = false;
        var _extend_x = _extend_dir == 0 || _extend_dir == 2;
        var _extend_y = _extend_dir == 1 || _extend_dir == 2;
        var _tile_base_width = _sprite_width - l - r;
        var _tile_base_height = _sprite_height - t - b;
        switch (_tilemode)
        {
            case -1:
                _xscale = 1;
                _yscale = 1;
                break;
            case 0:
                var _width = _width_pixels / _tile_base_width;
                var _height = _height_pixels / _tile_base_height;
                if (_extend_x)
                {
                    var _tile_width = _tile_base_width;
                    var _desired_width = _width_pixels;
                    _xscale = _desired_width / _tile_width;
                }
                if (_extend_y)
                {
                    _yscale = _height_pixels / _tile_base_height;
                }
                break;
            case 1:
            case 2:
                repeat_mode = true;
                if (_extend_x)
                {
                    _x_add = _tile_base_width;
                    _xreps = ceil((_width_pixels - l - r) / _tile_base_width);
                    if (_tilemode == 2)
                    {
                        _mirror_x = true;
                    }
                }
                if (_extend_y)
                {
                    _y_add = _tile_base_height;
                    _yreps = ceil((_height_pixels - t - b) / _tile_base_height);
                    if (_tilemode == 2)
                    {
                        _mirror_y = true;
                    }
                }
                break;
            case 3:
                break;
            case 4:
                _xreps = 0;
                _yreps = 0;
                break;
        }
        for (var yy = 0; yy < _yreps; yy++)
        {
            for (var xx = 0; xx < _xreps; xx++)
            {
                var _draw_x = _x + (xx * _tile_base_width);
                var _draw_y = _y + (yy * _tile_base_height);
                var _draw_left = _left;
                var _draw_top = _top;
                var _draw_width = _width_pixels;
                var _draw_height = _height_pixels;
                var _draw_xscale = _xscale;
                var _draw_yscale = _yscale;
                if (repeat_mode)
                {
                    if ((xx + 1) >= _xreps)
                    {
                        var _widthsofar = _tile_base_width * (_xreps - 1);
                        var _full_width = arg4 - l - r;
                        var _widthnow = _full_width - _widthsofar;
                        _draw_width = min(_draw_width, _widthnow);
                    }
                    if ((yy + 1) >= _yreps)
                    {
                        var _heightsofar = _tile_base_height * (_yreps - 1);
                        var _full_height = arg5 - l - r;
                        var _heightnow = _full_height - _heightsofar;
                        _draw_height = min(_draw_height, _heightnow);
                    }
                }
                draw_sprite_part_ext(arg0, arg1, _draw_left, _draw_top, _draw_width, _draw_height, _draw_x, _draw_y, _draw_xscale, _draw_yscale, c_white, 1);
            }
        }
    }
    sprite_set_nineslice(arg0, info);
}

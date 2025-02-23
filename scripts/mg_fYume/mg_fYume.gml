function mg_fYume() : minigame_constructor() constructor
{
    name = "Yume";
    prompt = "EXIT!";
    time_limit = 16;
    efin_skip_amount = 5;
    timer_script = timer_tutorial;
    music = mf1_mus;
    music_bpm = 128;
    music_loops = false;
    control_style = build_control_style(["arrows"]);
    screen_w = 480;
    screen_h = 270;
    metascript_init = mf1_metascript_init;
    metascript_start = mf1_metascript_start;
    metascript_tick_before = mf1_metascript_tick_before;
    metascript_draw_before = mf1_metascript_draw_before;
    metascript_draw_after = mf1_metascript_draw_after;
    metascript_cleanup = mf1_metascript_cleanup;
    define_object("player", 
    {
        init: mf1scr_player_init,
        tick: mf1scr_player_tick
    });
    define_object("enemy", 
    {
        init: mf1scr_enemy_init,
        tick: mf1scr_enemy_tick
    });
    define_object("enemy_copy", 
    {
        tick: mf1scr_enemy_copy_tick
    });
    define_object("door", 
    {
        draw: mf1scr_door_draw
    }, 
    {
        sprite_index: mf1_spr_door,
        image_speed: 0,
        closest: 0,
        closest_display: 0
    });
    define_object("blue", {}, 
    {
        width: 96,
        height: 32,
        sprite_index: mf1_spr_blueblue
    });
    define_object("hole1", {}, 
    {
        width: 96,
        height: 32,
        sprite_index: mf1_spr_hole1,
        mask: mf1_spr_hole1mask
    });
    define_object("hole2", {}, 
    {
        width: 160,
        height: 32,
        sprite_index: mf1_spr_hole2,
        mask: mf1_spr_hole2mask
    });
    define_object("lamp", {}, 
    {
        width: 8,
        height: 8,
        sprite_index: mf1_spr_lamp,
        mask: mf1_spr_lampmask
    });
}

function mf1_metascript_init()
{
    win = false;
    lose = false;
    level_w = 544;
    level_h = 544;
    bg_sprite = mf1_spr_floor;
    bg_speed_x = -1;
    bg_speed_y = -1;
    musvol = 1;
    walls = [];
    obstacles = [];
    sizes = 
    {
        hole1: [3, 1],
        hole2: [5, 1],
        lamp: [5, 1],
        blue: [3, 2],
        door: [0, 0]
    };
    audio_sound_gain(obj_minigame_controller.current_process_mg.music, 1, 0);
    holes_sf = surface_create(480, 270);
    _cell_amount_w = level_w / 32;
    _cell_amount_h = level_h / 32;
    _cells = [];
    _path_cells = [];
    for (var cx = 0; cx < _cell_amount_w; cx++)
    {
        var _yarr = array_create(_cell_amount_h, 0);
        _cells[cx] = _yarr;
    }
    _center_cell_x = floor(_cell_amount_w / 2);
    _center_cell_y = floor(_cell_amount_h / 2);
    var _dir = irandom(360);
    var _len = 4;
    if (get_minigame_times_played() == 0)
    {
        _len = 2;
    }
    door_cell_x = round(_center_cell_x + lengthdir_x(_len, _dir));
    door_cell_y = round(_center_cell_y + (lengthdir_y(_len, _dir) * 0.5625));
    door_x = (door_cell_x - _center_cell_x) * 32;
    door_y = (door_cell_y - _center_cell_y) * 32;
    door = create_object("door", 
    {
        x: door_x,
        y: door_y,
        depth: -door_y
    });
    doors = [door];
    array_push(obstacles, ["door", door]);
    player_cell_x = round(_center_cell_x + lengthdir_x(-_len, _dir));
    player_cell_y = round(_center_cell_y + (lengthdir_y(-_len, _dir) * 0.5625));
    player_x = (player_cell_x - _center_cell_x) * 32;
    player_y = (player_cell_y - _center_cell_y) * 32;
    var _lerpamt = random_range(0.4, 0.6);
    var pathnode_x = lerp(0, door_x, _lerpamt);
    var pathnode_y = lerp(0, door_y, _lerpamt);
    _len = 64;
    _dir = point_direction(pathnode_x, pathnode_y, door_x, door_y);
    _dir += (choose(-90, 90) + random_range(-10, 10));
    pathnode_x += lengthdir_x(_len, _dir);
    pathnode_y += lengthdir_y(_len, _dir);
    pathnode_x = clamp(pathnode_x, -level_w / 2, level_w / 2);
    pathnode_y = clamp(pathnode_y, -level_h / 2, level_h / 2);
    pathnode_x += (_center_cell_x * 32);
    pathnode_y += (_center_cell_y * 32);
    pathnode_x /= 32;
    pathnode_y /= 32;
    pathnode_x = clamp(round(pathnode_x), 0, _cell_amount_w - 1);
    pathnode_y = clamp(round(pathnode_y), 0, _cell_amount_h - 1);
    var _section = 0;
    var _points = [player_cell_x, player_cell_y, pathnode_x, pathnode_y];
    var _shifts = [[0, -2], [-1, -1], [0, -1], [1, -1], [-2, 0], [-1, 0], [0, 0], [1, 0], [2, 0], [-1, 1], [0, 1], [1, 1], [0, 2]];
    for (_section = 0; _section < 2; _section++)
    {
        var _steps = ceil(point_distance(_points[0], _points[1], _points[2], _points[3]) * 1.5);
        for (var i = 0; i < (_steps + 1); i++)
        {
            var _testx = round(lerp(_points[0], _points[2], i / _steps));
            var _testy = round(lerp(_points[1], _points[3], i / _steps));
            for (var _shift = 0; _shift < array_length(_shifts); _shift++)
            {
                var __cx = _testx + _shifts[_shift][0];
                var __cy = _testy + _shifts[_shift][1];
                if (__cx < 0)
                {
                    __cx += _cell_amount_w;
                }
                if (__cx >= _cell_amount_w)
                {
                    __cx -= _cell_amount_w;
                }
                if (__cy < 0)
                {
                    __cy += _cell_amount_h;
                }
                if (__cy >= _cell_amount_h)
                {
                    __cy -= _cell_amount_h;
                }
                __cx = clamp(_testx + _shifts[_shift][0], 0, _cell_amount_w - 1);
                __cy = clamp(_testy + _shifts[_shift][1], 0, _cell_amount_h - 1);
                _cells[__cx][__cy] = 1;
                array_push(_path_cells, [__cx, __cy]);
            }
        }
        _points = [pathnode_x, pathnode_y, door_cell_x, door_cell_y];
    }
    
    print_debug_grid = function()
    {
        var _str = "PATH:\n";
        for (var yy = 0; yy < _cell_amount_h; yy++)
        {
            for (var xx = 0; xx < _cell_amount_w; xx++)
            {
                var _cell = _cells[xx][yy];
                var _char = " ";
                if (_cell == 2)
                {
                    _char = "x";
                }
                if (_cell == 3)
                {
                    _char = "O";
                }
                if (_cell == 1)
                {
                    _char = "|";
                    if (door_cell_x == xx && door_cell_y == yy)
                    {
                        _char = "D";
                    }
                    if (player_cell_x == xx && player_cell_y == yy)
                    {
                        _char = "P";
                    }
                }
                _str += ("[" + _char + "]");
            }
            _str += "\n";
        }
        _str += "---------------------------------------------------";
        show_debug_message(_str);
    };
    
    print_debug_grid();
    
    place_obstacle_at_cell = function(arg0, arg1, arg2, arg3 = true)
    {
        if (!is_string(arg2))
        {
            exit;
        }
        var xpos = (arg0 - _center_cell_x) * 32;
        var ypos = (arg1 - _center_cell_y) * 32;
        var _obj = create_object(arg2, 
        {
            x: xpos,
            y: ypos,
            depth: -arg1
        });
        _obj.visible = arg3;
        array_push(obstacles, [arg2, _obj]);
        return _obj;
    };
    
    var _objects = ["hole1", "hole2", "lamp", "lamp", "blue", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    for (var cy = 0; cy < _cell_amount_h; cy++)
    {
        for (var cx = 0; cx < _cell_amount_w; cx++)
        {
            var _ob = _objects[irandom(array_length(_objects) - 1)];
            if (is_string(_ob))
            {
                var ob_size = struct_get(sizes, _ob);
                var ob_w = ceil(ob_size[0]);
                var ob_h = ceil(ob_size[1]);
                var _valid = true;
                var mycells = [];
                var xx = cx - ceil(ob_w / 2);
                while (xx < (cx + ceil(ob_w / 1.5)) && _valid)
                {
                    var yy = cy - ceil(ob_h / 2);
                    while (yy < (cy + ceil(ob_h / 1.5)) && _valid)
                    {
                        var _check_x = xx;
                        if (_check_x < 0)
                        {
                            _check_x += _cell_amount_w;
                        }
                        if (_check_x >= _cell_amount_w)
                        {
                            _check_x -= _cell_amount_w;
                        }
                        var _check_y = yy;
                        if (_check_y < 0)
                        {
                            _check_y += _cell_amount_h;
                        }
                        if (_check_y >= _cell_amount_h)
                        {
                            _check_y -= _cell_amount_h;
                        }
                        if (_cells[_check_x][_check_y] == 0)
                        {
                            array_push(mycells, [_check_x, _check_y]);
                        }
                        else
                        {
                            _valid = false;
                        }
                        yy++;
                    }
                    xx++;
                }
                if (_valid)
                {
                    place_obstacle_at_cell(cx, cy, _ob);
                    for (var i = 0; i < array_length(mycells); i++)
                    {
                        _cells[mycells[i][0]][mycells[i][1]] = 2;
                    }
                    _cells[cx][cy] = 3;
                }
            }
        }
    }
    var obs = array_length(obstacles);
    for (var cx = -1; cx <= 1; cx++)
    {
        for (var cy = -1; cy <= 1; cy++)
        {
            if (!(cx == 0 && cy == 0))
            {
                for (var i = 0; i < obs; i++)
                {
                    var offx = level_w * cx;
                    var offy = level_h * cy;
                    var ob = create_object(obstacles[i][0], 
                    {
                        x: obstacles[i][1].x + offx,
                        y: obstacles[i][1].y + offy,
                        depth: -(obstacles[i][1].y + offy)
                    });
                    array_push(obstacles, [obstacles[i][0], ob]);
                    ob.depth = -ob.y;
                    if (obstacles[i][0] == "door")
                    {
                        array_push(doors, ob);
                    }
                }
            }
        }
    }
    
    set_walls = function()
    {
        walls = [];
        for (var i = 0; i < array_length(obstacles); i++)
        {
            var _ob = obstacles[i][1];
            if (variable_struct_exists(_ob, "width"))
            {
                _ob.depth = -_ob.y;
                var _obx = _ob.x;
                var _oby = _ob.y;
                var _obw = _ob.width;
                var _obh = _ob.height;
                var x1 = _obx - (_obw / 2);
                var y1 = _oby - (_obh / 2);
                var x2 = _obx + (_obw / 2);
                var y2 = _oby + (_obh / 2);
                array_push(walls, [x1, y1, x2, y2]);
            }
        }
    };
    
    set_walls();
    var enemy_cells = [];
    var enemy_amount = 3;
    if (get_game_difficulty() == 0)
    {
        enemy_amount = 0;
    }
    for (var i = 0; i < enemy_amount; i++)
    {
        var _cc = [irandom(_cell_amount_w - 1), irandom(_cell_amount_h - 1)];
        while (_cells[_cc[0]][_cc[1]] != 0 || point_distance(_cc[0], _cc[1], player_cell_x, player_cell_y) < 3 || point_distance(_cc[0], _cc[1], door_cell_x, door_cell_y) < 3)
        {
            _cc = [irandom(_cell_amount_w - 1), irandom(_cell_amount_h - 1)];
        }
        enemy_cells[i] = _cc;
    }
    enemies = [];
    enemy_copies = [];
    for (var i = 0; i < enemy_amount; i++)
    {
        var _spawn_cell_x = enemy_cells[i][0];
        var _spawn_cell_y = enemy_cells[i][1];
        var _spawn_x = _spawn_cell_x;
        var _spawn_y = _spawn_cell_y;
        var aggro = get_game_difficulty() >= 2;
        _spawn_x -= _center_cell_x;
        _spawn_y -= _center_cell_y;
        _spawn_x *= 32;
        _spawn_y *= 32;
        var _nme = create_object("enemy", 
        {
            x: _spawn_x,
            y: _spawn_y,
            depth: -_spawn_y,
            aggro: aggro
        });
        array_push(enemies, _nme);
        var _parent = enemies[array_length(enemies) - 1];
        for (var cx = -1; cx <= 1; cx++)
        {
            for (var cy = -1; cy <= 1; cy++)
            {
                if (!(cx == 0 && cy == 0))
                {
                    array_push(enemy_copies, create_object("enemy_copy", 
                    {
                        parent: _parent,
                        offset: [level_w * cx, level_h * cy]
                    }));
                }
            }
        }
    }
    
    spawn_enemy_at_cell = function(arg0, arg1, arg2 = 0)
    {
        var _spawn_x = arg0;
        var _spawn_y = arg1;
        _spawn_x -= _center_cell_x;
        _spawn_y -= _center_cell_y;
        _spawn_x *= 32;
        _spawn_y *= 32;
        var _nme = create_object("enemy", 
        {
            x: _spawn_x,
            y: _spawn_y,
            depth: -_spawn_y,
            aggro: arg2
        });
        array_push(enemies, _nme);
        return _nme;
    };
    
    destroy_obstacles = function()
    {
        walls = [];
        for (var i = 0; i < array_length(obstacles); i++)
        {
            destroy_object(obstacles[i][1]);
        }
        obstacles = [];
    };
    
    destroy_enemies = function(arg0 = [])
    {
        for (var i = 0; i < array_length(enemies); i++)
        {
            if (!array_contains(arg0, enemies[i]))
            {
                destroy_object(enemies[i]);
            }
        }
        for (var i = 0; i < array_length(enemy_copies); i++)
        {
            if (!array_contains(arg0, enemy_copies[i].parent))
            {
                destroy_object(enemy_copies[i]);
            }
        }
    };
    
    player = create_object("player", 
    {
        x: player_x,
        y: player_y,
        depth: -player_y
    });
    update_draw_order();
    win_or_lose = 0;
    endfade = 0;
    endfadedir = 0;
    windoor = sprite_get_number(mf1_spr_door) - 1;
    timer = 0;
}

function mf1_metascript_start()
{
    for (var i = 0; i < array_length(enemies); i++)
    {
        enemies[i].can_move = true;
    }
}

function mf1_metascript_cleanup()
{
    if (surface_exists(holes_sf))
    {
        surface_free(holes_sf);
    }
}

function mf1_metascript_tick_before()
{
    win_or_lose = get_win_state();
    timer++;
    if (get_win_state() == 0)
    {
        if (door.image_index > (sprite_get_number(mf1_spr_door) - 1) && door.image_speed > 0)
        {
            endfadedir = 1;
            door.image_speed = 0;
            game_win();
        }
    }
    endfade += (endfadedir * 0.1 * get_game_speed());
    var goal = 1.5;
    if (get_win_state() == -1)
    {
        goal = 3.5;
    }
    if (endfadedir == 1 && endfade >= goal)
    {
        endfadedir = -1;
        if (get_win_state() == 1)
        {
            sfx_play(mf1_snd_nature);
        }
        else
        {
            endfade = 0;
        }
        if (get_win_state() == -1)
        {
            var _xchange = player_x - player.x;
            var _ychange = player_y - player.y;
            player.x += _xchange;
            player.start_x += _xchange;
            player.moveto_x += _xchange;
            player.y += _ychange;
            player.start_y += _ychange;
            player.moveto_y += _ychange;
            player.image_index = 0;
            destroy_enemies();
            audio_stop_sound(mf1_snd_static);
            sfx_play(mf1_snd_evil);
            var _places = [[-3, -2, 1], [-2, -2, 0], [-1, -2, 1], [0, -2, 0], [1, -2, 1], [2, -2, 0], [3, -2, 1], [-3, -1, 1], [3, -1, 1], [-3, 0, 1], [3, 0, 1], [-3, 1, 1], [3, 1, 1], [-3, 2, 1], [-2, 2, 0], [-1, 2, 1], [0, 2, 0], [1, 2, 1], [2, 2, 0], [3, 2, 1]];
            for (var i = 0; i < array_length(_places); i++)
            {
                var cx = player_cell_x + _places[i][0];
                var cy = player_cell_y + _places[i][1];
                var _ob = place_obstacle_at_cell(cx, cy, "blue", _places[i][2]);
            }
            update_draw_order();
            set_walls();
            for (var xx = -8; xx <= 8; xx++)
            {
                for (var yy = -8; yy <= 8; yy++)
                {
                    if (!(xx >= -4 && xx <= 4 && yy >= -2 && yy <= 2) && ((xx + yy) % 3) == 0)
                    {
                        spawn_enemy_at_cell(player_cell_x + xx, player_cell_y + yy, 0);
                    }
                }
            }
            bg_sprite = mf1_spr_losebg;
            bg_speed_x = 5;
            bg_speed_y = 5;
            player.dead = false;
        }
    }
    if (endfadedir == -1)
    {
        var _mus = obj_minigame_controller.current_process_mg.music;
        musvol = lerp(musvol, 0, 0.05);
        audio_sound_gain(_mus, musvol, 0);
        if (get_win_state() != -1)
        {
            if (endfade <= -0.25 && windoor >= 0.5)
            {
                var prev_windoor = windoor;
                windoor -= ((sprite_get_speed(mf1_spr_door) / 60) * get_game_speed());
                windoor = clamp(windoor, 0.4, 9);
                if (ceil(prev_windoor) != ceil(windoor) && ceil(prev_windoor) == 3)
                {
                    sfx_play(mf1_snd_door_close);
                }
            }
        }
    }
    var closest_dist = infinity;
    array_sort(doors, function(arg0, arg1)
    {
        var _dist1 = point_distance(arg0.x, arg0.y, player.x, player.y);
        var _dist2 = point_distance(arg1.x, arg1.y, player.x, player.y);
        var _diff = _dist1 - _dist2;
        if (_diff == 0)
        {
            _diff = 1;
        }
        return _diff;
    });
}

function mf1_metascript_draw_before()
{
    var _cam = cam2d_get_view();
    var _camx = camera_get_view_x(_cam);
    var _camy = camera_get_view_y(_cam);
    draw_sprite_tiled(bg_sprite, (get_current_frame() / 60) * sprite_get_speed(bg_sprite), _camx + ((timer * bg_speed_x) / 10), _camy + ((timer * bg_speed_y) / 10));
    if (!surface_exists(holes_sf))
    {
        holes_sf = surface_create(480, 270);
    }
    var sf = surface_get_target();
    surface_reset_target();
    surface_set_target(holes_sf);
    draw_clear_alpha(c_white, 0);
    for (var i = 0; i < array_length(obstacles); i++)
    {
        var _ob = obstacles[i][1];
        switch (_ob.sprite_index)
        {
            case mf1_spr_lamp:
            case mf1_spr_hole1:
            case mf1_spr_hole2:
                with (_ob)
                {
                    game = get_meta_object();
                    var _w = sprite_get_width(sprite_index);
                    var _h = sprite_get_height(sprite_index);
                    var _ofx = sprite_get_xoffset(sprite_index);
                    var _ofy = sprite_get_yoffset(sprite_index);
                    draw_sprite(mask, 0, x - _camx, y - _camy);
                }
                break;
        }
    }
    gpu_set_colorwriteenable(1, 1, 1, 0);
    draw_sprite_tiled(mf1_spr_cloud, 0, timer / 10, timer / 10);
    gpu_set_colorwriteenable(1, 1, 1, 1);
    surface_reset_target();
    surface_set_target(sf);
    camera_apply(_cam);
    draw_surface(holes_sf, _camx, _camy);
    draw_sprite_ext(mf1_spr_player_shadow, 0, player.x, player.y, 1, 1, 0, c_white, 1);
}

function mf1_metascript_draw_after()
{
    blendmode_set_add();
    draw_clear_alpha(c_white, 0);
    camera_apply(cam2d_get_view());
    for (var i = 0; i < array_length(obstacles); i++)
    {
        var _ob = obstacles[i][1];
        var _glow = -1;
        var _xx = 0;
        var _yy = 0;
        switch (_ob.sprite_index)
        {
            case mf1_spr_lamp:
                _glow = mf1_spr_ADDhole1andlampglow;
                _xx = 59;
                break;
            case mf1_spr_hole1:
                _glow = mf1_spr_ADDhole1andlampglow;
                break;
            case mf1_spr_hole2:
                _glow = mf1_spr_ADDhole2glow;
                break;
        }
        if (_glow != -1)
        {
            draw_sprite(_glow, 0, _ob.x + _xx, _ob.y + _yy);
        }
    }
    blendmode_reset();
    var cam = cam2d_get_view();
    camera_apply(cam);
    var camx = camera_get_view_x(cam);
    var camy = camera_get_view_y(cam);
    if (endfadedir == -1 && get_win_state() != -1)
    {
        draw_sprite_tiled(mf1_spr_winbg, 0, camx + endfade, camy);
        draw_sprite(mf1_spr_winfg, 0, camx, camy);
        draw_sprite(mf1_spr_door, windoor, camx + 64, camy + 148);
        draw_sprite(mf1_spr_player_down, 0, camx + 64, camy + 155);
    }
    if (endfade > 0 && get_win_state() != -1)
    {
        draw_set_color(c_black);
        draw_set_alpha(endfade);
        draw_rectangle(camx - 1, camy - 1, camx + 481, camy + 481, false);
        draw_set_alpha(1);
        draw_set_color(c_white);
    }
}

function mf1scr_door_draw()
{
    _draw_self();
    draw_sprite(mf1_spr_door_exit, 0, x, y);
}

function mf1scr_player_init()
{
    sprite_index = mf1_spr_player_down;
    collided = false;
    moving = false;
    move_prog = 0;
    move_speed = 0.0625;
    start_x = x;
    start_y = y;
    moveto_x = x;
    moveto_y = y;
    move_cooldown = 0;
    image_speed = 0;
    mys = 6;
    dead = false;
}

function mf1scr_player_tick()
{
    var game = get_meta_object();
    if (game.win)
    {
        exit;
    }
    var input = get_input();
    var xi = input.key.right - input.key.left;
    var yi = input.key.down - input.key.up;
    if (!dead && game.endfade <= 0)
    {
        if (moving)
        {
            move_prog += (move_speed * get_game_speed());
            move_prog = clamp(move_prog, 0, 1);
            x = lerp(start_x, moveto_x, move_prog);
            y = lerp(start_y, moveto_y, move_prog);
            depth = -y - 1;
            var prev_image_index = image_index;
            image_index = move_prog * 4;
            if (floor(prev_image_index) == (floor(image_index) - 1) && (floor(prev_image_index) % 2) == 0)
            {
                sfx_play(mf1_snd_walk);
            }
            if (move_prog >= 1)
            {
                move_prog = 0;
                moving = false;
                move_cooldown = 0;
                if (x < (-game.level_w / 2))
                {
                    x += game.level_w;
                }
                if (y < (-game.level_h / 2))
                {
                    y += game.level_h;
                }
                if (x > (game.level_w / 2))
                {
                    x -= game.level_w;
                }
                if (y > (game.level_h / 2))
                {
                    y -= game.level_h;
                }
                if (point_distance(x, y, game.door.x, game.door.y) < 15)
                {
                    game.win = true;
                    obj_minigame_controller.current_process_mg.win_on_timeover = true;
                    game.door.image_speed = 1 * get_game_speed();
                    sfx_play(mf1_snd_door_open);
                    depth = game.door.depth - 1;
                }
            }
        }
        else
        {
            start_x = x;
            start_y = y;
            moveto_x = x;
            moveto_y = y;
            if (move_cooldown > 0)
            {
                move_cooldown--;
            }
            else if (abs(xi) || abs(yi))
            {
                var xdist = xi * 32;
                var ydist = yi * 32;
                moveto_x = x + xdist;
                moveto_y = y + ydist;
                var canmove = true;
                var pxi = xi;
                var pyi = yi;
                for (var i = 0; i < array_length(game.walls) && canmove; i++)
                {
                    var _wall = game.walls[i];
                    for (var j = 1; j <= 2; j++)
                    {
                        if (rectangle_in_rectangle(x - mys, (y + (ydist / j)) - mys, x + mys, y + (ydist / j) + mys, _wall[0], _wall[1], _wall[2], _wall[3]))
                        {
                            moveto_y = y;
                            yi = 0;
                            ydist = 0;
                        }
                        if (rectangle_in_rectangle((x + (xdist / j)) - mys, y - mys, x + (xdist / j) + mys, y + mys, _wall[0], _wall[1], _wall[2], _wall[3]))
                        {
                            moveto_x = x;
                            xi = 0;
                            xdist = 0;
                        }
                    }
                    if (point_distance(x, y, moveto_x, moveto_y) == 0)
                    {
                        canmove = false;
                    }
                    else
                    {
                        for (var j = 1; j <= 1; j++)
                        {
                            canmove = canmove && !rectangle_in_rectangle((x + (xdist / j)) - mys, (y + (ydist / j)) - mys, x + (xdist / j) + mys, y + (ydist / j) + mys, _wall[0], _wall[1], _wall[2], _wall[3]);
                        }
                    }
                }
                moving = canmove;
                var _sprites = [mf1_spr_player_upleft, mf1_spr_player_up, mf1_spr_player_upright, mf1_spr_player_left, mf1_spr_player_right, mf1_spr_player_right, mf1_spr_player_downleft, mf1_spr_player_down, mf1_spr_player_downright];
                if (xi == 0 && yi == 0)
                {
                    xi = pxi;
                    yi = pyi;
                }
                sprite_index = _sprites[4 + xi + (yi * 3)];
            }
        }
    }
    else
    {
        moving = false;
        start_x = x;
        start_y = x;
        move_prog = 0;
    }
    camera_set_view_pos(cam2d_get_view(), x - 240, y - 31 - 135);
}

function mf1scr_enemy_init()
{
    can_move = false;
    sprite_index = mf1_spr_enemy;
    collided = false;
    moving = false;
    move_prog = 0;
    move_speed = 0.0625;
    start_x = x;
    start_y = y;
    moveto_x = x;
    moveto_y = y;
    move_cooldown = 0;
    mys = 6;
    aggro = 0;
    attacking = false;
    move_countdown = irandom_range(30, 80);
    possible_moves = [[-1, -1], [0, -1], [1, 1], [-1, 0], [1, 0], [-1, 1], [0, 1], [1, 1]];
    
    check_kill = function()
    {
        var game = get_meta_object();
        if (point_distance(x, y, game.player.x, game.player.y) <= 5)
        {
            game.player.dead = true;
            game.endfadedir = 1;
            game.bg_sprite = mf1_spr_static;
            sfx_play(mf1_snd_static);
            game_lose();
            attacking = true;
            start_x = x;
            start_y = y;
            game.destroy_obstacles();
            game.destroy_enemies([self]);
        }
    };
}

function mf1scr_enemy_tick()
{
    var game = get_meta_object();
    if (game.win)
    {
        exit;
    }
    var xi = 0;
    var yi = 0;
    if (attacking)
    {
        x = start_x + random_range(-3, 3);
        y = start_y + random_range(-3, 3);
        depth = game.player.depth - 10;
        exit;
    }
    if (moving)
    {
        move_prog += (move_speed * get_game_speed());
        move_prog = clamp(move_prog, 0, 1);
        x = lerp(start_x, moveto_x, move_prog);
        y = lerp(start_y, moveto_y, move_prog);
        depth = -y - 1;
        image_index = move_prog * 4;
        if (move_prog >= 1)
        {
            move_prog = 0;
            moving = false;
            move_cooldown = 0;
            if (x < (-game.level_w / 2))
            {
                x += game.level_w;
            }
            if (y < (-game.level_h / 2))
            {
                y += game.level_h;
            }
            if (x > (game.level_w / 2))
            {
                x -= game.level_w;
            }
            if (y > (game.level_h / 2))
            {
                y -= game.level_h;
            }
        }
    }
    else
    {
        var _move;
        if (move_countdown > 0)
        {
            if (can_move)
            {
                move_countdown--;
            }
        }
        else if (aggro)
        {
            move_countdown = irandom_range(5, 20);
            var player = game.player;
            xi = sign(player.x - x);
            yi = sign(player.y - y);
        }
        else
        {
            move_countdown = irandom_range(30, 80);
            _move = irandom(array_length(possible_moves) - 1);
            xi = possible_moves[_move][0];
            yi = possible_moves[_move][1];
        }
        start_x = x;
        start_y = y;
        moveto_x = x;
        moveto_y = y;
        if (move_cooldown > 0)
        {
            move_cooldown--;
        }
        else if (abs(xi) || abs(yi))
        {
            var xdist = xi * 32;
            var ydist = yi * 32;
            moveto_x = x + xdist;
            moveto_y = y + ydist;
            var canmove = true;
            for (var retries = 0; point_distance(x + xdist, y + ydist, game.door.x, game.door.y) < 32 && retries < 8 && !aggro; retries++)
            {
                _move++;
                _move = _move % array_length(possible_moves);
                xi = possible_moves[_move][0];
                yi = possible_moves[_move][1];
                xdist = xi * 32;
                ydist = yi * 32;
                moveto_x = x + xdist;
                moveto_y = y + ydist;
            }
            var pxi = xi;
            var pyi = yi;
            for (var i = 0; i < array_length(game.walls) && canmove; i++)
            {
                var _wall = game.walls[i];
                for (var j = 1; j <= 2; j++)
                {
                    if (rectangle_in_rectangle(x - mys, (y + (ydist / j)) - mys, x + mys, y + (ydist / j) + mys, _wall[0], _wall[1], _wall[2], _wall[3]))
                    {
                        moveto_y = y;
                        yi = 0;
                        ydist = 0;
                    }
                    if (rectangle_in_rectangle((x + (xdist / j)) - mys, y - mys, x + (xdist / j) + mys, y + mys, _wall[0], _wall[1], _wall[2], _wall[3]))
                    {
                        moveto_x = x;
                        xi = 0;
                        xdist = 0;
                    }
                }
                if (point_distance(x, y, moveto_x, moveto_y) == 0)
                {
                    canmove = false;
                }
                else
                {
                    for (var j = 1; j <= 1; j++)
                    {
                        canmove = canmove && !rectangle_in_rectangle((x + (xdist / j)) - mys, (y + (ydist / j)) - mys, x + (xdist / j) + mys, y + (ydist / j) + mys, _wall[0], _wall[1], _wall[2], _wall[3]);
                    }
                }
            }
            moving = canmove;
            if (moving && abs(xi))
            {
                image_xscale = -xi;
            }
        }
    }
    check_kill();
}

function mf1scr_enemy_copy_tick()
{
    sprite_index = parent.sprite_index;
    image_index = parent.image_index;
    image_speed = 0;
    image_xscale = parent.image_xscale;
    x = parent.x + offset[0];
    y = parent.y + offset[1];
    depth = -y;
}

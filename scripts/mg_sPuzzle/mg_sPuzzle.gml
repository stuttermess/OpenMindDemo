function mg_sPuzzle() : minigame_constructor() constructor
{
    name = "Puzzle";
    prompt = "DROP!";
    time_limit = 16;
    timer_script = timer_sparkle;
    efin_skip_amount = 16;
    music = ms15_mus;
    music_bpm = 128;
    control_style = build_control_style(["arrows", "spacebar"]);
    metascript_init = ms15_metascript_init;
    metascript_start = ms15_metascript_start;
    metascript_tick_before = ms15_metascript_tick_before;
    metascript_tick_after = ms15_metascript_tick_after;
    metascript_draw_before = ms15_metascript_draw_before;
    metascript_draw_after = ms15_metascript_draw_after;
    metascript_cleanup = ms15_metascript_cleanup;
    define_object("movablepiece", 
    {
        init: ms15scr_movablepiece_init,
        tick: ms15scr_movablepiece_tick,
        draw: ms15scr_movablepiece_draw
    });
    define_object("board", 
    {
        init: ms15scr_board_init,
        tick: ms15scr_board_tick,
        draw: ms15scr_board_draw
    });
}

function ms15_metascript_init()
{
    tv_sf = surface_create(480, 270);
    screen_x = 240;
    screen_y = 135;
    screen_y = 105;
    boards[0] = create_object("board", 
    {
        x: screen_x - 100 - 6,
        y: screen_y - 84
    });
    boards[1] = create_object("board", 
    {
        x: (screen_x - 100 - 6) + 124,
        y: screen_y - 84,
        next_piece_dir: -1
    });
    var _jb = boards[1].board[0];
    var _a = 1;
    var _h = 0;
    var _b = 1;
    var _k = 1;
    var _pieces_base_height = 1;
    var _pieces_max_height = 5;
    var _height = array_length(_jb);
    var _xoff = random(1);
    for (var i = 0; i < array_length(_jb[0]); i++)
    {
        var _x = (i / (array_length(_jb[0]) - 1)) + _xoff;
        var _y = _height - _pieces_base_height;
        var _wave = (_a * cos((((_x * 2) - _h) / _b) * pi)) + _k;
        _y -= round((_pieces_max_height - _pieces_base_height) * (_wave / 2));
        _y += choose(-1, 0, 1);
        _y = clamp(_y, 0, _height - 1);
        _x = i;
        for (var _yy = _y; _yy < _height; _yy++)
        {
            _jb[_yy][_x] = choose(1, 3, 5, 7, 9, 11, 13);
        }
    }
    abbie_bounce = 0;
    jenny_bounce = 0;
    var _difficulty = get_game_difficulty();
    switch (_difficulty)
    {
        case 0:
            boards[0].board[0] = [[0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 2], [0, 0, 0, 0, 0, 0, 4], [0, 0, 0, 0, 0, 0, 6], [7, 7, 7, 7, 7, 7, 7], [5, 5, 5, 5, 5, 5, 5], [3, 3, 3, 3, 3, 3, 3], [1, 1, 1, 1, 1, 1, 1]];
            boards[0].start_pieces[0] = [[8, 1]];
            boards[0].ghosts = [[3, 10, 8], [4, 10, 1]];
            obj_minigame_controller.current_process_mg.efin_skip_amount = 5;
            break;
        case 1:
            boards[0].board[0] = [[0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [4, 0, 0, 0, 0, 0, 0], [2, 0, 9, 9, 9, 0, 0], [9, 9, 9, 6, 9, 0, 8], [1, 9, 3, 3, 5, 5, 5], [1, 3, 3, 5, 5, 7, 7], [1, 1, 3, 3, 5, 7, 7]];
            boards[0].start_pieces[0] = [[10, 13]];
            boards[0].ghosts = [[3, 9, 10], [4, 9, 13]];
            obj_minigame_controller.current_process_mg.efin_skip_amount = 5;
            break;
        case 2:
        default:
            boards[0].board[0] = [[0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 4, 6, 0, 0, 0, 8], [8, 5, 3, 0, 0, 0, 2], [3, 3, 3, 9, 9, 9, 9], [2, 3, 3, 1, 1, 1, 1], [3, 3, 7, 7, 7, 1, 7], [1, 1, 1, 7, 7, 7, 7], [7, 6, 12, 10, 12, 2, 7], [7, 7, 5, 11, 9, 11, 1], [7, 5, 5, 11, 9, 11, 1]];
            boards[0].start_pieces[0] = [[10, 13]];
            boards[0].ghosts = [[4, 7, 10], [5, 7, 13]];
            break;
    }
    boards[0].shuffle_pieces();
    boards[0].create_piece(true);
    boards[1].create_piece();
    boards[1].player_num = 1;
    boards[1].cpu_level = 1;
    current_beat = get_time_limit() - get_time();
    prev_beat = current_beat;
    beat_skip = 0;
}

function ms15_metascript_start()
{
    boards[0].mp.active = true;
    boards[1].mp.active = true;
}

function ms15_metascript_tick_before()
{
    var _cb = get_time_limit() - get_time();
    if (abs(prev_beat - _cb) >= 1)
    {
        beat_skip = round(abs(prev_beat - _cb));
    }
    current_beat = _cb + beat_skip;
    abbie_bounce = lerp(abbie_bounce, 0, 0.3);
    jenny_bounce = lerp(jenny_bounce, 0, 0.15);
}

function ms15_metascript_tick_after()
{
    prev_beat = (get_time_limit() - get_time()) + beat_skip;
}

function ms15_metascript_draw_before()
{
    draw_clear(c_black);
    regular_surface = surface_get_target();
    surface_reset_target();
    if (!surface_exists(tv_sf))
    {
        tv_sf = surface_create(480, 270);
    }
    surface_set_target(tv_sf);
    draw_clear(c_black);
    draw_sprite(ms15_spr_bg, 0, screen_x, screen_y);
}

function ms15_metascript_draw_after()
{
    draw_sprite(ms15_spr_fg, 0, screen_x, screen_y);
    for (var i = 0; i < array_length(boards); i++)
    {
        boards[i].draw_next_pieces();
    }
    surface_reset_target();
    surface_set_target(regular_surface);
    var fisheye_magnitude = lerp(0, 0.5, mouse_y / 270);
    draw_surface(tv_sf, 0, 0);
    blendmode_set_multiply();
    draw_sprite(ms15_spr_real_multscanlines, 0, 0, 0);
    blendmode_reset();
    draw_sprite(ms15_spr_real_bg, 0, 0, 0);
    var _win_state = get_win_state();
    var _won = _win_state == 1;
    var _lost = _win_state == -1;
    var abbie_x = (155 + sprite_get_xoffset(ms15_spr_real_sbody)) - 227;
    var abbie_y = 46 + sprite_get_yoffset(ms15_spr_real_sbody);
    var abbie_controller_down = boards[0].controller_down;
    var abbie_xscale = 1 + (abbie_bounce * 0.1);
    var abbie_yscale = 1 / abbie_xscale;
    draw_sprite_ext(ms15_spr_real_scontroller, 0, abbie_x, abbie_y + abbie_controller_down, abbie_xscale, abbie_yscale, 0, c_white, 1);
    draw_sprite_ext(ms15_spr_real_sbody, 0, abbie_x, abbie_y, abbie_xscale, abbie_yscale, 0, c_white, 1);
    draw_sprite_ext(ms15_spr_real_shead, _won, abbie_x, abbie_y, abbie_xscale, abbie_yscale, 0, c_white, 1);
    var jenny_x = 321 + sprite_get_xoffset(ms15_spr_real_jcontroller);
    var jenny_y = 47 + sprite_get_yoffset(ms15_spr_real_jcontroller);
    var jenny_controller_down = boards[1].controller_down;
    var jenny_xscale = 1 + (jenny_bounce * 0.1);
    var jenny_yscale = 1 / jenny_xscale;
    draw_sprite_ext(ms15_spr_real_jcontroller, 0, jenny_x, jenny_y + jenny_controller_down, jenny_xscale, jenny_yscale, 0, c_white, 1);
    draw_sprite_ext(ms15_spr_real_jbody, 0, jenny_x, jenny_y, jenny_xscale, jenny_yscale, 0, c_white, 1);
    draw_sprite_ext(ms15_spr_real_jhead, _won, jenny_x, jenny_y, jenny_xscale, jenny_yscale, 0, c_white, 1);
    var _end_overlays = [ms15_spr_real_slose, spr_none, ms15_spr_real_happy];
    if (_win_state != 0)
    {
        var _spr = _end_overlays[1 + _win_state];
        var _frame = ((sprite_get_speed(_spr) / 60) * get_current_frame()) % sprite_get_number(_spr);
        draw_sprite(_spr, _frame, 0, 0);
    }
}

function ms15_metascript_cleanup()
{
    if (surface_exists(tv_sf))
    {
        surface_free(tv_sf);
    }
}

function ms15scr_board_init()
{
    beatsound = -1;
    current_board = 0;
    player_num = 0;
    cpu_level = 0;
    start_piece_num = 0;
    input_pressed = 0;
    controller_down = 0;
    next_pieces_amount = 1;
    next_pieces = [];
    
    add_to_piece_queue_end = function()
    {
        var _p1 = (irandom_range(0, 6) * 2) + 1;
        var _p2 = (irandom_range(0, 6) * 2) + 1;
        array_push(next_pieces, [_p1, _p2]);
    };
    
    choose_next_piece = function()
    {
        add_to_piece_queue_end();
        var _piece = next_pieces[0];
        array_delete(next_pieces, 0, 1);
        return _piece;
    };
    
    for (var i = 0; i < next_pieces_amount; i++)
    {
        add_to_piece_queue_end();
    }
    upwards_space = 3;
    board[0] = [[0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0]];
    start_pieces[0] = [[1, 1]];
    
    shuffle_pieces = function()
    {
        var flip = choose(0, 1);
        if (flip)
        {
            for (var i = 0; i < array_length(board[0]); i++)
            {
                board[0][i] = array_reverse(board[0][i]);
            }
            for (var i = 0; i < array_length(ghosts); i++)
            {
                ghosts[i][0] = board_w - 1 - ghosts[i][0];
            }
            var _save = ghosts[1][2];
            ghosts[1][2] = ghosts[0][2];
            ghosts[0][2] = _save;
        }
        var _shift = irandom_range(0, 7) * 2;
        for (var cx = 0; cx < array_length(board[0]); cx++)
        {
            var _arr = board[0][cx];
            for (var cy = 0; cy < array_length(_arr); cy++)
            {
                if (_arr[cy] > 0)
                {
                    _arr[cy] += _shift;
                    if (_arr[cy] > 14)
                    {
                        _arr[cy] -= 14;
                    }
                }
            }
        }
        for (var i = 0; i < array_length(ghosts); i++)
        {
            ghosts[i][2] += _shift;
            if (ghosts[i][2] > 14)
            {
                ghosts[i][2] -= 14;
            }
        }
        start_pieces[0][0][0] += _shift;
        start_pieces[0][0][1] += _shift;
        if (start_pieces[0][0][0] > 14)
        {
            start_pieces[0][0][0] -= 14;
        }
        if (start_pieces[0][0][1] > 14)
        {
            start_pieces[0][0][1] -= 14;
        }
    };
    
    board[1] = [[0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 0, 0, 0, 0, 0, 0], [0, 1, 3, 5, 7, 9, 0], [1, 3, 5, 7, 9, 11, 0], [1, 3, 5, 7, 9, 11, 0], [1, 3, 5, 7, 9, 11, 0]];
    start_pieces[1] = [[11, 14]];
    board_combo = 0;
    presim_combo = 0;
    board_combo_display_timer = 0;
    board_combo_display_timer_max = 120 / get_game_speed();
    board_h = array_length(board[current_board]);
    board_w = array_length(board[current_board][0]);
    width_pixels = 84;
    height_pixels = 12 * (12 + upwards_space);
    next_piece_dir = 1;
    next_piece_x = 53;
    next_piece_y = 29;
    
    draw_next_pieces = function()
    {
        var _next_piece = next_pieces[0];
        var _npx = x + (width_pixels / 2) + (next_piece_x * next_piece_dir);
        var _npy = y + next_piece_y;
        for (var i = 0; i < 2; i++)
        {
            _npy += (i * 12);
            var _spr = ms15_scr_piece_to_sprite(_next_piece[i]);
            draw_sprite(_spr, 0, _npx, _npy);
        }
    };
    
    ghosts = [];
    
    create_piece = function(arg0 = false)
    {
        var _me = self;
        mp = create_object("movablepiece", 
        {
            piece1: start_pieces[current_board][start_piece_num][0],
            piece2: start_pieces[current_board][start_piece_num][1],
            board: _me,
            player_movable: true
        });
    };
    
    mp = -1;
    drops = [];
    drops_struct = {};
    drop_anim = 1;
    drop_anim_anchor_beat = 0;
    drop_anim_time = 14;
    pops_struct = {};
    pop_anim = 1;
    pop_anim_anchor_beat = 0;
    pop_anim_time = 14;
    drop_anim_beats = 0.5;
    pop_anim_beats = 0.5;
    matchstarts_struct = {};
}

function ms15scr_board_tick()
{
    var game = get_meta_object();
    if (board_combo_display_timer > 0)
    {
        board_combo_display_timer--;
        if (board_combo_display_timer == 0)
        {
        }
    }
    if (presim_combo > 2)
    {
        obj_minigame_controller.current_process_mg.win_on_timeover = true;
    }
    if (drop_anim < 1)
    {
        if (drop_anim == 0)
        {
            drop_anim_anchor_beat = floor(game.current_beat);
        }
        if (player_num == 0 && board_combo > 2 && get_win_state() == 0)
        {
            game.abbie_bounce = 1;
            game.jenny_bounce = 1;
            game_win();
        }
        drop_anim = clamp((game.current_beat - drop_anim_anchor_beat) / (drop_anim_beats / 0.5), 0, 1);
        if (drop_anim >= 1)
        {
            drop_anim = 1;
            ms15_scr_check_matches();
        }
    }
    if (pop_anim < 1)
    {
        if (pop_anim == 0)
        {
            pop_anim_anchor_beat = floor(game.current_beat);
        }
        pop_anim = ((game.current_beat - pop_anim_anchor_beat) / (pop_anim_beats / 0.5)) * 2;
        if (pop_anim >= 1)
        {
            pop_anim = 1;
            ms15scr_delete_popped_pieces();
            ms15_scr_start_drop();
        }
    }
    if (mp != -1)
    {
        if (player_num == 0)
        {
            var input = get_input();
            mp.input = input;
        }
        else if (cpu_level >= 1)
        {
            var input = mp.input.key;
            if (get_win_state() == 1)
            {
                input.right_press = 0;
                input.left_press = 0;
                input.space_press = 0;
            }
            else
            {
                input.right_press = irandom(100) < 5;
                input.left_press = irandom(100) < 5;
                input.space_press = irandom(100) < 1;
            }
        }
    }
    var _key = mp.input.key;
    input_pressed--;
    if (_key.left_press || _key.right_press || _key.down_press || _key.space_press || _key.up_press)
    {
        input_pressed = 12;
    }
    controller_down = (input_pressed % 10) > 5;
}

function ms15scr_delete_popped_pieces()
{
    var _pops = struct_get_names(pops_struct);
    for (var i = 0; i < array_length(_pops); i++)
    {
        var _pop = struct_get(pops_struct, _pops[i]);
        var _x = _pop[0];
        var _y = _pop[1];
        board[current_board][_y][_x] = 0;
        if (struct_exists(matchstarts_struct, _pops[i]))
        {
            struct_remove(matchstarts_struct, _pops[i]);
        }
    }
}

function ms15scr_board_draw()
{
    if (drop_anim < 1)
    {
        for (var i = 0; i < array_length(drops); i++)
        {
            var _this_drop = drops[i];
            var _x = _this_drop.x;
            var _y1 = _this_drop.y1;
            var _y2 = _this_drop.y2;
            var _piece = _this_drop.piece;
            var _sprite = _this_drop.sprite;
            if (_sprite != -1)
            {
                var _pos1 = ms15_scr_grid_to_world(_x, _y1);
                var _pos2 = ms15_scr_grid_to_world(_x, _y2);
                _y1 = _pos1[1];
                _y2 = _pos2[1];
                var _dist = _y2 - _y1;
                _x = _pos1[0];
                var _anim = lerp_easeIn(drop_anim);
                var _y = lerp(_y1, _y2, _anim);
                draw_sprite(_sprite, 0, _x, _y);
            }
        }
    }
    for (var i = 0; i < (board_w * board_h); i++)
    {
        var currcol = i div board_h;
        var currrow = i - (currcol * board_h);
        var piecenum = board[current_board][currrow][currcol];
        var is_ghost = piecenum >= 20;
        if (is_ghost)
        {
            piecenum -= 20;
        }
        var piece_alpha = 1;
        if (is_ghost)
        {
            piece_alpha = 0.5;
        }
        if (piecenum != 0)
        {
            var _spr = ms15_scr_sprite_at_grid_space(currcol, currrow);
            var _pos = ms15_scr_grid_to_world(currcol, currrow);
            var _x = _pos[0];
            var _y = _pos[1];
            var _struct_str = ms15_scr_grid_space_to_string(currcol, currrow);
            if (_spr != -1 && (drop_anim >= 1 || (drop_anim < 1 && !struct_exists(drops_struct, _struct_str))))
            {
                var xscale = 1;
                var yscale = 1;
                if (pop_anim < 1 && struct_exists(pops_struct, _struct_str))
                {
                    var _anim = lerp_easeInBack(pop_anim);
                    var _scale = lerp(1, 0, _anim);
                    _scale = max(1 + ((_scale - 1) * 3), 0);
                    xscale = _scale;
                    yscale = _scale;
                }
                draw_sprite_ext(_spr, 0, _x, _y, xscale, yscale, 0, c_white, piece_alpha);
            }
        }
    }
    var meta = get_meta_object();
    for (var i = 0; i < array_length(ghosts); i++)
    {
        var _col = ghosts[i][0];
        var _row = ghosts[i][1];
        var piecenum = ghosts[i][2];
        var _spr = ms15_scr_piece_to_sprite(piecenum);
        var _pos = ms15_scr_grid_to_world(_col, _row);
        var _x = _pos[0];
        var _y = _pos[1];
        var _al = 0.3125 + (dcos(meta.current_beat * 360) * 0.1875);
        draw_sprite_ext(_spr, 0, _x, _y, 1, 1, 0, c_white, _al);
    }
}

function ms15_scr_start_drop(arg0 = false)
{
    var game = ms15_scr_get_board();
    with (game)
    {
        ghosts = [];
        drops = [];
        drops_struct = {};
        var _board = board[current_board];
        for (var cellx = 0; cellx < board_w; cellx++)
        {
            var celly = board_h - 1;
            while (celly >= 0)
            {
                var _piece_num = _board[celly][cellx];
                if (_piece_num == 0)
                {
                    var lowest_blank = celly;
                    var lookup = celly - 1;
                    while (lookup > 0)
                    {
                        var piece_at_cell = _board[lookup][cellx];
                        if (piece_at_cell != 0)
                        {
                            _piece_num = _board[lookup][cellx];
                            var _piece_sprite = ms15_scr_piece_to_sprite(_piece_num);
                            var _thisdrop = 
                            {
                                x: cellx,
                                y1: lookup,
                                y2: lowest_blank,
                                piece: _piece_num,
                                sprite: _piece_sprite
                            };
                            array_push(drops, _thisdrop);
                            var _struct_str = ms15_scr_grid_space_to_string(cellx, lowest_blank);
                            struct_set(drops_struct, _struct_str, 1);
                            if ((_piece_num % 2) == 0)
                            {
                                struct_remove(matchstarts_struct, ms15_scr_grid_space_to_string(cellx, lookup));
                                struct_set(matchstarts_struct, _struct_str, 
                                {
                                    x: cellx,
                                    y: lowest_blank
                                });
                            }
                            _board[lowest_blank][cellx] = _piece_num;
                            _board[lookup][cellx] = 0;
                            lowest_blank--;
                        }
                        lookup--;
                    }
                    celly = -1;
                }
                else
                {
                    var _struct_str = ms15_scr_grid_space_to_string(cellx, celly);
                    if (_piece_num >= 20)
                    {
                        _board[celly][cellx] = 0;
                    }
                    else if ((_piece_num % 2) == 0)
                    {
                        struct_set(matchstarts_struct, _struct_str, 
                        {
                            x: cellx,
                            y: celly
                        });
                    }
                }
                celly--;
            }
        }
        if (arg0)
        {
            return ms15_scr_check_matches(arg0);
        }
        else if (array_length(drops) > 0)
        {
            drop_anim = 0;
            mp.movable = false;
        }
        else
        {
            ms15_scr_check_matches();
        }
    }
}

function ms15_scr_check_matches(arg0 = false)
{
    var game = ms15_scr_get_board();
    var meta = get_meta_object();
    with (game)
    {
        drops_struct = {};
        pops_struct = {};
        var matchstarts_names = struct_get_names(matchstarts_struct);
        for (var i = 0; i < array_length(matchstarts_names); i++)
        {
            var _this_matchstart = struct_get(matchstarts_struct, matchstarts_names[i]);
            var _cx = _this_matchstart.x;
            var _cy = _this_matchstart.y;
            var _matchstart_piece = board[current_board][_cy][_cx];
            var _matchstart_matches = [[_cx, _cy]];
            var checked_cells = {};
            struct_set(checked_cells, ms15_scr_grid_space_to_string(_cx, _cy), 1);
            var _matches_len = array_length(_matchstart_matches);
            for (var j = 0; j < _matches_len; j++)
            {
                var _adjacents = ms15_scr_get_adjacent_pieces(_matchstart_matches[j][0], _matchstart_matches[j][1]);
                var anymatches = false;
                for (var k = 0; k < array_length(_adjacents); k++)
                {
                    var _this_adjacent = _adjacents[k];
                    var this_space_str = ms15_scr_grid_space_to_string(_this_adjacent.x, _this_adjacent.y);
                    if (_this_adjacent.x >= 0 && _this_adjacent.x < board_w && _this_adjacent.y >= 0 && _this_adjacent.y < board_h)
                    {
                        if ((_this_adjacent.piece == _matchstart_piece || _this_adjacent.piece == (_matchstart_piece - 1)) && _this_adjacent.piece != -1)
                        {
                            anymatches = true;
                            if (!struct_exists(checked_cells, this_space_str))
                            {
                                array_push(_matchstart_matches, [_this_adjacent.x, _this_adjacent.y]);
                                struct_set(pops_struct, this_space_str, [_this_adjacent.x, _this_adjacent.y]);
                                _matches_len++;
                            }
                        }
                    }
                    struct_set(checked_cells, this_space_str, 1);
                }
                if (anymatches)
                {
                    var this_space_str = ms15_scr_grid_space_to_string(_cx, _cy);
                    struct_set(pops_struct, this_space_str, [_cx, _cy]);
                }
            }
        }
        if (array_length(struct_get_names(pops_struct)) > 0)
        {
            if (arg0)
            {
                board_combo++;
                ms15scr_delete_popped_pieces();
                return ms15_scr_start_drop(arg0);
            }
            else
            {
                pop_anim = 0;
                sfx_play(ms15_snd_pop, false, 1, 0, 1 + (min(board_combo, 8) * 0.11));
                board_combo++;
                if (beatsound == -1 && (round(meta.current_beat - meta.beat_skip) % 4) == 0)
                {
                    beatsound = sfx_play(ms15_snd_beat, true, 1, 0, get_game_speed(), true);
                }
            }
        }
        else
        {
            if (!arg0)
            {
                board_combo_display_timer = board_combo_display_timer_max;
                mp.movable = true;
                mp.set_pieces();
                if (beatsound != -1)
                {
                    audio_stop_sound(beatsound);
                    beatsound = -1;
                }
            }
            return false;
        }
    }
}

function ms15_scr_presim_combo()
{
    var game = ms15_scr_get_board();
    var meta = get_meta_object();
    var combo_count = 0;
    with (game)
    {
        var _board = board[current_board];
        var _board_save = [];
        for (var i = 0; i < array_length(_board); i++)
        {
            _board_save[i] = [];
            array_copy(_board_save[i], 0, _board[i], 0, array_length(_board[i]));
        }
        ms15_scr_start_drop(true);
        combo_count = board_combo;
        board_combo = 0;
        for (var i = 0; i < array_length(_board); i++)
        {
            array_copy(_board[i], 0, _board_save[i], 0, array_length(_board_save[i]));
        }
    }
    return combo_count;
}

function ms15_scr_get_adjacent_pieces(arg0, arg1)
{
    var ajds = [];
    for (var a = 0; a < 360; a += 90)
    {
        var _x = round(arg0 + dcos(a));
        var _y = round(arg1 + dsin(a));
        var _piece = ms15_scr_piece_at_grid_space(_x, _y);
        if (_piece != -1)
        {
            var bababa = 0;
        }
        array_push(ajds, 
        {
            x: _x,
            y: _y,
            piece: _piece
        });
    }
    return ajds;
}

function ms15_scr_grid_space_to_string(arg0, arg1)
{
    return string(arg0) + "_" + string(arg1);
}

function ms15_scr_piece_at_grid_space(arg0, arg1)
{
    var game = ms15_scr_get_board();
    arg0 = round(arg0);
    arg1 = round(arg1);
    if (arg0 < 0 || arg0 >= game.board_w)
    {
        return 99;
    }
    if (arg1 < 0)
    {
        return 0;
    }
    if (arg1 < 0 || arg1 >= array_length(game.board[game.current_board]))
    {
        return -1;
    }
    else if (arg0 < 0 || arg0 >= array_length(game.board[game.current_board][arg1]))
    {
        return -1;
    }
    else
    {
        return game.board[game.current_board][arg1][arg0];
    }
}

function ms15_scr_grid_space_is_free(arg0, arg1)
{
    arg0 = round(arg0);
    arg1 = round(arg1);
    var game = ms15_scr_get_board();
    var _piece = ms15_scr_piece_at_grid_space(arg0, arg1);
    return _piece <= 0 && _piece != -1;
}

function ms15_scr_sprite_at_grid_space(arg0, arg1)
{
    arg0 = round(arg0);
    arg1 = round(arg1);
    var game = ms15_scr_get_board();
    return ms15_scr_piece_to_sprite(ms15_scr_piece_at_grid_space(arg0, arg1));
}

function ms15_scr_piece_to_sprite(arg0)
{
    if (arg0 >= 20)
    {
        arg0 -= 20;
    }
    return asset_get_index("ms15_spr_piece" + string(arg0));
}

function ms15_scr_grid_to_world(arg0, arg1)
{
    var game = ms15_scr_get_board();
    return [game.x + (arg0 * 12) + 6, game.y + ((arg1 - game.upwards_space) * 12) + 6];
}

function ms15_scr_world_to_grid(arg0, arg1)
{
    var game = ms15_scr_get_board();
    return [floor((arg0 - game.x) / 12), floor((arg1 - game.y) / 12) + game.upwards_space];
}

function ms15_scr_get_board()
{
    var game = self;
    if (struct_exists(self, "IAMAPIECE"))
    {
        game = board;
    }
    return game;
}

function ms15scr_movablepiece_init()
{
    var game = get_meta_object();
    startx = 2;
    starty = 3;
    startrot = 0;
    IAMAPIECE = true;
    active = false;
    x = startx;
    y = starty;
    rot = startrot;
    x2 = x + dcos(rot * 90);
    y2 = y - dsin(rot * 90);
    rotdir = 0;
    rotation_blocked = false;
    doublerotate_timer = 0;
    doublerotate_timer_max = 20;
    right_hold_timer = 0;
    left_hold_timer = 0;
    down_hold_timer = 0;
    input_hold_timer_max = 15;
    hori_input_repeat = 5;
    down_input_repeat = 6;
    attempteddrops = 0;
    dropnext = false;
    piece_w = 12;
    droptickmaxtime = 45;
    droptick = droptickmaxtime;
    movable = true;
    player_movable = false;
    move = false;
    xmove = 0;
    ymove = 0;
    x2move = 0;
    y2move = 0;
    piece2_anim = 1;
    piece2_anim_time = 5;
    piece2_old_rot = 0;
    piece2_new_rot = rot;
    input = 
    {
        key: 
        {
            left_press: 0,
            right_press: 0,
            down_press: 0,
            left: 0,
            right: 0,
            down: 0,
            space_press: 0,
            up_press: 0
        }
    };
    
    set_pieces = function()
    {
        var game = ms15_scr_get_board();
        var _pieces = game.choose_next_piece();
        piece1 = _pieces[0];
        piece2 = _pieces[1];
    };
}

function ms15scr_movablepiece_tick()
{
    var game = get_meta_object();
    var ikey = input.key;
    if (!active)
    {
        exit;
    }
    if (!movable)
    {
        exit;
    }
    if (dropnext && floor(game.current_beat) > floor(game.prev_beat))
    {
        dropnext = false;
        game = board;
        game.board[game.current_board][y][x] = piece1;
        game.board[game.current_board][y2][x2] = piece2;
        x = startx;
        y = starty;
        rot = startrot;
        x2 = x + dcos(rot * 90);
        y2 = y - dsin(rot * 90);
        attempteddrops = 0;
        movable = false;
        game.board_combo = 0;
        game.presim_combo = ms15_scr_presim_combo();
        ms15_scr_start_drop();
        exit;
    }
    var _left_press = input.key.left_press;
    var _right_press = input.key.right_press;
    var _down_press = input.key.down_press;
    var _left = input.key.left;
    var _right = input.key.right;
    var _down = input.key.down;
    var _space_press = input.key.space_press;
    var _up_press = input.key.up_press;
    if (!player_movable)
    {
        _left_press = 0;
        _right_press = 0;
        _down_press = 0;
        _left = 0;
        _right = 0;
        _down = 0;
        _space_press = 0;
        _up_press = 0;
    }
    var gamespeed = get_game_speed();
    if (_right)
    {
        right_hold_timer += 1;
    }
    else
    {
        right_hold_timer = 0;
    }
    if (_left)
    {
        left_hold_timer += 1;
    }
    else
    {
        left_hold_timer = 0;
    }
    var rightkey = _right_press || (_right && right_hold_timer >= input_hold_timer_max);
    var leftkey = _left_press || (_left && left_hold_timer >= input_hold_timer_max);
    var movex = rightkey - leftkey;
    if (right_hold_timer >= input_hold_timer_max)
    {
        right_hold_timer -= hori_input_repeat;
    }
    if (left_hold_timer >= input_hold_timer_max)
    {
        left_hold_timer -= hori_input_repeat;
    }
    var input_down = _down;
    var input_down_press = _down_press;
    if (input_down)
    {
        down_hold_timer += 1;
        if (input_down_press)
        {
            down_hold_timer = 15;
        }
    }
    else
    {
        down_hold_timer = 0;
    }
    var downkey = _down_press || (_down && down_hold_timer >= input_hold_timer_max);
    if (down_hold_timer >= input_hold_timer_max)
    {
        down_hold_timer -= down_input_repeat;
    }
    if (downkey)
    {
        droptick = 0;
    }
    var _testmove = false;
    if (movex != 0)
    {
        xmove += movex;
        x2move += movex;
        droptick *= 0.75;
        droptick = round(droptick);
    }
    if (_space_press || _up_press)
    {
        rotdir = _space_press - _up_press;
        if (doublerotate_timer > 0)
        {
            rotdir *= 2;
            droptick *= 0.75;
            droptick = round(droptick);
        }
    }
    if (doublerotate_timer > 0)
    {
        doublerotate_timer--;
    }
    game = board;
    droptick -= gamespeed;
    if (droptick <= 0)
    {
        var piece1check = ms15_scr_grid_space_is_free(x, y + 1);
        var piece2check = ms15_scr_grid_space_is_free(x2, y2 + 1);
        if (!piece1check || !piece2check)
        {
            attempteddrops++;
            if (attempteddrops >= 2 && y2 >= 0 && y >= 0)
            {
                dropnext = true;
            }
        }
        else
        {
            attempteddrops = 0;
            droptick = droptickmaxtime;
            ymove += 1;
            y2move += 1;
        }
    }
    if (piece2_anim < 1)
    {
        piece2_anim += (gamespeed / piece2_anim_time);
    }
    if (xmove != 0 || ymove != 0 || x2move != 0 || y2move != 0 || rotdir != 0)
    {
        ms15_scr_move();
    }
}

function ms15_scr_move()
{
    var testx = x + xmove;
    var testy = y + ymove;
    var testx2 = x2 + x2move;
    var testy2 = y2 + y2move;
    if (rotdir != 0)
    {
        var testr = rot + rotdir;
        x2move += (testx - testx2);
        y2move += (testy - testy2);
        x2move += dcos(testr * 90);
        y2move += -dsin(testr * 90);
        testx2 = x2 + x2move;
        testy2 = y2 + y2move;
    }
    var game = get_meta_object();
    var _piece1_space_free = ms15_scr_grid_space_is_free(testx, testy);
    var _piece2_space_free = ms15_scr_grid_space_is_free(testx2, testy2);
    var _valid_mode = false;
    rotation_blocked = false;
    if (_piece1_space_free)
    {
        if (_piece2_space_free)
        {
            _valid_mode = true;
        }
        else if (rotdir != 0)
        {
            var backx = testx - testx2;
            var backy = testy - testy2;
            xmove += backx;
            ymove += backy;
            x2move += backx;
            y2move += backy;
            testx = x + xmove;
            testy = y + ymove;
            testx2 = x2 + x2move;
            testy2 = y2 + y2move;
            var back_piece1free = ms15_scr_grid_space_is_free(testx, testy);
            var back_piece2free = ms15_scr_grid_space_is_free(testx2, testy2);
            if (back_piece1free && back_piece2free)
            {
                _valid_mode = true;
            }
            else
            {
                _valid_mode = false;
                rotation_blocked = true;
            }
        }
    }
    else
    {
        _valid_mode = false;
    }
    if (_valid_mode)
    {
        var oldrot = rot;
        x += xmove;
        y += ymove;
        x2 += x2move;
        y2 += y2move;
        rot += rotdir;
        if (rot != oldrot)
        {
            piece2_anim = 0;
            piece2_old_rot = oldrot;
            piece2_new_rot = rot;
        }
    }
    if (rotation_blocked && rotdir != 0)
    {
        doublerotate_timer = doublerotate_timer_max;
    }
    move = false;
    xmove = 0;
    ymove = 0;
    x2move = 0;
    y2move = 0;
    rotdir = 0;
}

function ms15scr_movablepiece_draw()
{
    if (!movable)
    {
        exit;
    }
    var _pos1 = ms15_scr_grid_to_world(x, y);
    var _pos2 = ms15_scr_grid_to_world(x2, y2);
    draw_sprite(ms15_scr_piece_to_sprite(piece1), 0, _pos1[0], _pos1[1]);
    if (piece2_anim < 1)
    {
        var _angle = lerp(piece2_old_rot, piece2_new_rot, piece2_anim);
        var _x2 = _pos1[0] + (dcos(_angle * 90) * 12);
        var _y2 = _pos1[1] - (dsin(_angle * 90) * 12);
        draw_sprite(ms15_scr_piece_to_sprite(piece2), 0, _x2, _y2);
    }
    else
    {
        draw_sprite(ms15_scr_piece_to_sprite(piece2), 0, _pos2[0], _pos2[1]);
    }
}

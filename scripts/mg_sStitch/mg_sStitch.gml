function mg_sStitch() : minigame_constructor() constructor
{
    name = "Stitch";
    prompt = "STITCH!";
    time_limit = 12;
    timer_script = timer_sparkle;
    efin_skip_amount = 6;
    music = ms17_mus;
    music_bpm = 128;
    control_style = build_control_style(["cursor"]);
    gimmick_blacklist = [gimmick_flip];
    metascript_init = ms17_metascript_init;
    metascript_tick_before = ms17_metascript_tick_before;
    metascript_tick_after = ms17_metascript_tick_after;
    metascript_draw_before = ms17_metascript_draw_before;
    metascript_draw_after = ms17_metascript_draw_after;
    define_object("sparkle", 
    {
        init: -1
    }, {});
}

function ms17_metascript_init()
{
    input = get_input();
    imouse = input.mouse;
    prevmousex = imouse.x;
    prevmousey = imouse.y;
    angle = 0;
    prevangle = angle;
    dir = 0;
    stitchpointsdiff[0] = [[186, 66], [155, 107], [232, 98], [165, 165], [240, 156], [208, 202]];
    stitchpointsdiff[1] = [[186, 66], [155, 107], [232, 98], [173, 140], [247, 125], [175, 182], [255, 167], [211, 220]];
    stitchpointsdiff[2] = stitchpointsdiff[1];
    var _max = 2;
    if (get_game_speed() > 1.5)
    {
        _max = 1;
    }
    stitchpoints = stitchpointsdiff[clamp(get_game_difficulty(), 0, _max)];
    surf = -1;
    winbgsurf = -1;
    t = 0;
    a = 0;
    pixel = 1;
    wintimer = 25 + ((1 - get_game_speed()) * 20);
    show_debug_message(wintimer);
    pointsattached = [];
    ropesystem = new verletSystem(0.99, 0.5);
    connectedropelength = 10;
    segments = (array_length(stitchpoints) - 2) * connectedropelength;
    rope = verletGroupCreateRope(ropesystem, imouse.x, imouse.y, 0, 1, 7, segments + 1, 8, 20);
}

function ms17_metascript_tick_before()
{
    input = get_input();
    imouse = input.mouse;
    if (verletSystemExists(ropesystem))
    {
        ropesystem.simulate();
    }
    for (var i = 1; i < (array_length(stitchpoints) - 1); i++)
    {
        var _plen = array_length(pointsattached);
        var _range = 3;
        if (i == (_plen + 1))
        {
            _range = 12;
        }
        var _attach = false;
        if (!array_contains(pointsattached, i))
        {
            if (_plen == 0 && i == 1)
            {
                if (point_distance(imouse.x, imouse.y, stitchpoints[i][0], stitchpoints[i][1]) <= _range)
                {
                    pointsattached[0] = i;
                    _attach = true;
                }
            }
            if (_plen >= 1)
            {
                var _p = pointsattached[_plen - 1];
                show_debug_message("{0} {1}", i, _range);
                if (line_intersects_circle(stitchpoints[i][0], stitchpoints[i][1], _range, imouse.x, imouse.y, stitchpoints[_p][0], stitchpoints[_p][1]))
                {
                    pointsattached[_plen] = i;
                    _attach = true;
                }
            }
        }
        if (_attach)
        {
            sfx_play(ms17_snd_stitch, false, 1, 0, random_range(0.9, 1.1));
        }
    }
    for (var i = 0; i < array_length(pointsattached); i++)
    {
        var ind = pointsattached[i];
        rope.vertexChangeData(i * connectedropelength, stitchpoints[ind][0], stitchpoints[ind][1], undefined, true);
    }
    var point_index = array_length(pointsattached) * connectedropelength;
    rope.vertexChangeData(point_index, imouse.x, imouse.y, undefined, false);
    rope.vertexChangeData(point_index + 1, imouse.x + 1, imouse.y, undefined, false);
    if (get_win_state() == 1)
    {
        var l = array_length(stitchpoints);
        for (var i = 1; i < (l - 1); i++)
        {
            var targetx = lerp(stitchpoints[0][0], stitchpoints[l - 1][0], stitchpoints[i][1] / ((stitchpoints[0][1] + stitchpoints[l - 1][1]) / 2));
            stitchpoints[i][0] = lerp(stitchpoints[i][0], targetx, 0.2 * get_game_speed());
        }
    }
}

function ms17_metascript_tick_after()
{
    var sortedarray = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];
    var arraycheck = [];
    array_copy(arraycheck, 0, sortedarray, 0, array_length(pointsattached));
    if (get_win_state() == 0)
    {
        if (array_equals(pointsattached, arraycheck))
        {
            if (array_length(pointsattached) == (array_length(stitchpoints) - 2))
            {
                sfx_play(ms17_snd_win);
                game_win();
            }
        }
        else
        {
            sfx_play(ms17_snd_lose);
            game_lose();
        }
    }
}

function ms17_metascript_draw_before()
{
    shader_set_wavy(ms17_spr_bg, get_current_frame() / 100, 1, 10, 50, 1, 40, 20);
    draw_sprite_tiled(ms17_spr_bg, 0, 0, 0);
    shader_reset();
    draw_sprite(ms17_spr_bear, 0, 240, 135);
    if (!surface_exists(surf))
    {
        surf = surface_create(480, 270);
    }
    surface_set_target(surf);
    draw_clear_alpha(c_white, 0);
    gpu_set_blendenable(false);
    gpu_set_colorwriteenable(false, false, false, true);
    draw_set_alpha(0);
    draw_rectangle(0, 0, 480, 270, false);
    draw_set_alpha(1);
    draw_primitive_begin(pr_trianglestrip);
    for (var i = 0; i < array_length(stitchpoints); i++)
    {
        draw_vertex(stitchpoints[i][0], stitchpoints[i][1]);
    }
    draw_primitive_end();
    gpu_set_blendenable(true);
    gpu_set_colorwriteenable(true, true, true, true);
    gpu_set_blendmode_ext(7, bm_inv_dest_alpha);
    gpu_set_alphatestenable(true);
    draw_sprite(ms17_spr_fluff, 0, 240, 135);
    gpu_set_alphatestenable(false);
    gpu_set_blendmode(bm_normal);
    surface_reset_target();
    draw_surface(surf, 0, 0);
    if (get_win_state() != 1)
    {
        for (var i = 1; i < (array_length(stitchpoints) - 1); i++)
        {
            draw_sprite(ms17_spr_numbers, i - 1, stitchpoints[i][0], stitchpoints[i][1]);
            draw_sprite(ms17_spr_circle, t, stitchpoints[i][0], stitchpoints[i][1]);
        }
    }
    t += 0.1;
}

function ms17_metascript_draw_after()
{
    mousex = imouse.x;
    mousey = imouse.y;
    if (mousex != prevmousex || mousey != prevmousey)
    {
        dir = point_direction(mousex, mousey, prevmousex, prevmousey);
        angle = angle_lerp(angle, dir, 0.3);
    }
    prevmousex = mousex;
    prevmousey = mousey;
    prevangle = angle;
    if (get_win_state() != 1)
    {
        if (verletSystemExists(ropesystem))
        {
            ropesystem.draw();
        }
    }
    else
    {
        for (var i = 1; i < (array_length(stitchpoints) - 2); i++)
        {
            draw_line_color(stitchpoints[i][0], stitchpoints[i][1], stitchpoints[i + 1][0], stitchpoints[i + 1][1], c_black, c_black);
        }
        if (verletSystemExists(ropesystem))
        {
            ropesystem = -1;
        }
    }
    draw_set_alpha(0.5);
    draw_circle(mousex, mousey, 5, false);
    draw_set_alpha(1);
    draw_set_color(c_black);
    draw_circle(mousex, mousey, 5, true);
    draw_set_color(c_white);
    if (get_win_state() != 0)
    {
        wintimer--;
        if (wintimer <= 0)
        {
            var time = get_current_frame();
            var _xx = 240;
            var _yy = 135;
            var _w = sprite_get_width(ms17_spr_resultsbg) - 8;
            var _h = sprite_get_height(ms17_spr_resultsbg) - 8;
            if (!surface_exists(winbgsurf))
            {
                winbgsurf = surface_create(_w, _h);
            }
            draw_set_alpha(a);
            if (get_win_state() == 1)
            {
                surface_set_target(winbgsurf);
                shader_set_wavy(ms17_spr_winbg, get_current_frame() / 100, 2, 50, 10, 2, 50, 10);
                draw_sprite(ms17_spr_winbg, 0, _w / 2, _h / 2);
                shader_reset();
                draw_sprite(ms17_spr_winscreen, time / 3, _w / 2, (_h / 2) + 10);
                surface_reset_target();
            }
            else if (get_win_state() == -1)
            {
                surface_set_target(winbgsurf);
                shader_set_wavy(ms17_spr_losebg, get_current_frame() / 100, 2, 50, 10, 2, 50, 10);
                draw_sprite(ms17_spr_losebg, 0, _w / 2, _h / 2);
                shader_reset();
                draw_sprite(ms17_spr_lose_jen, time / 3, _w / 2, (_h / 2) + 10);
                draw_sprite(ms17_spr_lose_abb, time / 3, _w / 2, (_h / 2) + 10);
                surface_reset_target();
            }
            draw_set_alpha(1);
            shader_set_pixelate(pixel, ms17_spr_winscreen, time / 100);
            draw_surface(winbgsurf, _xx - (_w / 2), _yy - (_h / 2));
            shader_reset();
            draw_sprite_ext(ms17_spr_resultsbg, 0, _xx, _yy, 1, 1, 0, c_white, a);
            if (game_get_pause() != 1)
            {
                pixel += (0.3 * get_game_speed());
                a += (0.1 * get_game_speed());
            }
        }
    }
}

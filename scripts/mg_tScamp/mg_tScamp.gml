function mg_tScamp() : minigame_constructor() constructor
{
    name = "Scamp";
    prompt = "CIRCLE!";
    time_limit = 8;
    efin_skip_amount = 8;
    music = mt0_mus;
    music_bpm = 128;
    music_loops = false;
    control_style = build_control_style(["cmove"]);
    gimmick_blacklist = [gimmick_flip];
    metascript_start = mt0_metascript_start;
    metascript_init = mt0_metascript_init;
    metascript_tick_before = mt0_metascript_tick_before;
    metascript_draw_before = mt0_metascript_draw_before;
    metascript_draw_after = mt0_metascript_draw_after;
    define_object("player", 
    {
        init: mt0scr_player_init,
        tick: mt0scr_player_tick,
        draw: mt0scr_player_draw
    });
    define_object("mouse", 
    {
        init: mt0scr_mouse_init,
        tick: mt0scr_mouse_tick,
        draw: mt0scr_mouse_draw
    });
    define_object("pop", 
    {
        init: mt0scr_pop_init,
        tick: mt0scr_pop_tick,
        draw: mt0scr_pop_draw
    });
}

function mt0_metascript_init()
{
    toolong = 0;
    player = create_object("player");
    mouse = create_object("mouse");
    pix = 1;
    winsurf = -1;
    spr = -1;
    dudes = 1;
    scx = array_create(dudes, 320);
    scy = array_create(dudes, 150);
    scystart = array_create(dudes, 150);
    scvsp = array_create(dudes, 0);
    scxs = array_create(dudes, 1);
    scys = array_create(dudes, 1);
    sca = array_create(dudes, 0);
    animstate = array_create(dudes, "squish");
    scspr = array_create(dudes, mt0_spr_scamp_jump);
}

function mt0_metascript_tick_before()
{
    if (get_win_state() == 1 && player.timer >= 50)
    {
        pix++;
    }
}

function mt0_metascript_draw_before()
{
    draw_clear(c_white);
    if (!surface_exists(winsurf))
    {
        winsurf = surface_create(480, 270);
    }
    if (get_win_state() == 1)
    {
        if (player.timer >= 50)
        {
            surface_set_target(winsurf);
            draw_clear(c_white);
            draw_sprite(mt0_spr_scamp_win, pix / 10, 0, 0);
            var xoff = 0;
            var yoff = 0;
            var ii = abs(sin(pix / 10));
            var jj = abs(cos(pix / 10));
            for (var i = 0; i < dudes; i++)
            {
                if (!game_get_pause())
                {
                    if (animstate[i] == "squish")
                    {
                        scxs[i] = lerp(scxs[i], 1.5, 0.1);
                        scys[i] = lerp(scys[i], 0.3, 0.1);
                        if (scxs[i] >= 1.4)
                        {
                            scxs[i] = 1;
                            scys[i] = 1;
                            scspr[i] = mt0_spr_scamp_winjump;
                            animstate[i] = "jump";
                            sfx_play(mt0_snd_jump);
                        }
                    }
                    if (animstate[i] == "jump")
                    {
                        sca[i] += 10;
                        scy[i] = (scystart[i] - 40) + (-sin(sca[i] / 114.591559) * 50);
                        if (sca[i] >= 360)
                        {
                            scspr[i] = mt0_spr_scamp_jump;
                            sca[i] = 0;
                            scy[i] = scystart[i];
                            animstate[i] = "squish";
                        }
                    }
                }
                draw_sprite_ext(scspr[i], 0, scx[i], scy[i], scxs[i], scys[i], sca[i], c_white, 1);
            }
            surface_reset_target();
            var _tex = surface_get_texture(winsurf);
            shader_set_pixelate_tex(1 + ((pix * pix) / 5), _tex, texture_get_uvs(_tex));
            draw_surface(winsurf, 0, 0);
            shader_reset();
        }
    }
}

function mt0_metascript_draw_after()
{
}

function mt0scr_player_init()
{
    game = get_meta_object();
    sprite_index = mt0_spr_scamp;
    x = 240;
    y = 135;
    xprev = x;
    yprev = y;
    direction = choose(-135, -45, 45, 135);
    spd = (get_game_speed() * 2) - 0.5;
    hsp = 0;
    vsp = 0;
    grv = 0;
    var w = sprite_get_width(mt0_spr_scamp) - 10;
    left = 0 + w;
    right = 480 - w;
    top = 0 + w;
    bottom = 270 - w;
    startjump = false;
    timer = 0;
    jump = false;
    shakeamp = 3;
    polygonarray[0] = -1;
    sound = -1;
    follow_arrsize = 15;
    for (var i = follow_arrsize; i >= 0; i--)
    {
        follow_xpos[i] = x;
        follow_ypos[i] = y;
    }
}

function mt0scr_player_tick()
{
    game = get_meta_object();
    x += lengthdir_x(spd, direction);
    y += lengthdir_y(spd, direction);
    xto = x + lengthdir_x(spd, direction);
    yto = y + lengthdir_y(spd, direction);
    if (xto >= right || xto <= left)
    {
        x = clamp(x, left, right);
        direction = -direction + 180;
    }
    if (yto <= top || yto >= bottom)
    {
        direction = -direction;
    }
    var arr = polygonarray;
    
    win = function()
    {
        sprite_index = mt0_spr_scamp_pause;
        spd = 0;
        catchx = x;
        catchy = y;
        startjump = true;
        game.mouse.stopdrawing = true;
        game_win();
        audio_stop_sound(sound);
        audio_stop_sound(mt0_snd_walk);
        sfx_play(mt0_snd_win);
    };
    
    if (array_length(arr) >= 2)
    {
        if (bounding_box_in_polygon(mt0_spr_scamp, x, y - (sprite_get_height(sprite_index) / 2), arr))
        {
            win();
        }
        if (bounding_box_in_polygon(mt0_spr_scamp, follow_xpos[follow_arrsize - 1], follow_ypos[follow_arrsize - 1] - (sprite_get_height(sprite_index) / 2), arr))
        {
            win();
        }
        if (point_in_polygon(x, y - (sprite_get_height(sprite_index) / 2), convert_array_for_point_in_polygon(arr)))
        {
            win();
        }
        if (point_in_polygon(follow_xpos[follow_arrsize - 1], follow_ypos[follow_arrsize - 1] - (sprite_get_height(sprite_index) / 2), convert_array_for_point_in_polygon(arr)))
        {
            win();
        }
        polygonarray = array_create(0, 0);
    }
    if (startjump)
    {
        if (timer == 20)
        {
            jump = true;
            hsp = (x >= 240) ? -2 : 2;
            vsp = random_range(-3, -5);
            grv = 0.2;
        }
        if (timer < 20)
        {
            x = catchx + random_range(-shakeamp, shakeamp);
            y = catchy + random_range(-shakeamp, shakeamp);
            shakeamp = lerp(shakeamp, 0, 0.2);
        }
        if (jump)
        {
            sprite_index = mt0_spr_scamp_jump;
        }
        x += hsp;
        y += vsp;
        vsp += grv;
        timer++;
    }
    if (x != xprev || y != yprev)
    {
        var i = follow_arrsize - 1;
        while (i > 0)
        {
            follow_xpos[i] = follow_xpos[i - 1];
            follow_ypos[i] = follow_ypos[i - 1];
            i--;
        }
        follow_xpos[0] = x;
        follow_ypos[0] = y;
    }
    xprev = x;
    yprev = y;
}

function mt0scr_player_draw()
{
    if (!startjump)
    {
        draw_sprite(sprite_index, image_index, x + random_range(-1, 1), y + random_range(-1, 1));
    }
    else
    {
        _draw_self();
    }
}

function mt0scr_mouse_init()
{
    polygonpoints[0] = [0, 0];
    drawpoints[0] = [0, 0];
    tick = 0;
    maxtick = 1;
    maxlength = 600;
    closed = false;
    lastsegment = -1;
    mousereset = false;
    stopdrawing = false;
    sound = -1;
    barxoffset = 0;
    game = get_meta_object();
}

function mt0scr_mouse_tick()
{
    var input = get_input();
    x = input.mouse.x;
    y = input.mouse.y;
    polylength = 0;
    var l = array_length(polygonpoints);
    if (input.mouse.click && !mousereset && !stopdrawing)
    {
        if (sound == -1)
        {
            sound = sfx_play(mt0_snd_pencil, true);
        }
        if (tick <= 0)
        {
            l = array_length(polygonpoints);
            if (l > 1)
            {
                if (point_distance(polygonpoints[l - 1][0], polygonpoints[l - 1][1], x, y) >= 10)
                {
                    polygonpoints[l] = [x, y];
                }
            }
            else
            {
                polygonpoints[l] = [x, y];
            }
        }
        var l2 = array_length(drawpoints);
        if (l2 > 1)
        {
            if (point_distance(drawpoints[l2 - 1][0], drawpoints[l2 - 1][1], x, y) >= 10)
            {
                drawpoints[l2] = [x, y];
            }
        }
        else
        {
            drawpoints[l2] = [x, y];
        }
    }
    if (l > 1)
    {
        for (var i = 1; i < l; i++)
        {
            if (i > 2)
            {
                if (i < (l - 2))
                {
                    if (line_segments_intersect(polygonpoints[l - 2][0], polygonpoints[l - 2][1], polygonpoints[l - 1][0], polygonpoints[l - 1][1], polygonpoints[i][0], polygonpoints[i][1], polygonpoints[i - 1][0], polygonpoints[i - 1][1]))
                    {
                        closed = true;
                        lastsegment = i - 2;
                    }
                }
            }
            if (i > 1)
            {
                polylength += point_distance(polygonpoints[i][0], polygonpoints[i][1], polygonpoints[i - 1][0], polygonpoints[i - 1][1]);
            }
            if (i == (l - 1))
            {
            }
        }
    }
    if (l > 8)
    {
        if (point_distance(polygonpoints[1][0], polygonpoints[1][1], polygonpoints[l - 1][0], polygonpoints[l - 1][1]) <= 120)
        {
            closed = true;
        }
    }
    if (polylength >= maxlength)
    {
    }
    if (closed && lastsegment != -1)
    {
        array_delete(polygonpoints, 0, lastsegment);
        mousereset = true;
        if (closed)
        {
            game.player.polygonarray = polygonpoints;
        }
        mt0scr_create_pop_particle();
        polygonpoints = 0;
        polygonpoints = array_create(0, -1);
        drawpoints = 0;
        drawpoints = array_create(0, -1);
        if (sound != -1)
        {
            sfx_play(mt0_snd_pop);
        }
        audio_stop_sound(sound);
        sound = -1;
    }
    if (input.mouse.click_release || polylength >= maxlength)
    {
        if (sound != -1)
        {
            sfx_play(mt0_snd_pop);
        }
        audio_stop_sound(sound);
        sound = -1;
        if (closed)
        {
            game.player.polygonarray = polygonpoints;
        }
        mt0scr_create_pop_particle();
        polygonpoints = 0;
        polygonpoints = array_create(0, -1);
        drawpoints = 0;
        drawpoints = array_create(0, -1);
        closed = false;
        lastsegment = -1;
        if (polylength >= maxlength)
        {
            mousereset = true;
        }
        else
        {
            mousereset = false;
        }
    }
    tick--;
    if (tick < 0)
    {
        tick = maxtick;
    }
    if (game.player.jump)
    {
        barxoffset = lerp(barxoffset, -30, 0.1);
    }
}

function mt0scr_mouse_draw()
{
    for (var i = 1; i < array_length(drawpoints); i++)
    {
        temppoints[i][0] = drawpoints[i][0];
        temppoints[i][1] = drawpoints[i][1];
        temppoints[i][0] += random_range(-1, 1);
        temppoints[i][1] += random_range(-1, 1);
        if (i > 2)
        {
            var col1 = make_color_hsv((i * 15) % 255, 255, 255);
            var col2 = make_color_hsv(((i - 1) * 15) % 255, 255, 255);
            var xx1 = temppoints[i][0];
            var yy1 = temppoints[i][1];
            var xx2 = temppoints[i - 1][0];
            var yy2 = temppoints[i - 1][1];
            draw_line_width_color(xx1, yy1, xx2, yy2, 2, col1, col2);
            linecol[i] = col2;
        }
    }
    draw_sprite(spr_cursor_basic, 0, x, y);
    var bot = 140;
    var _x = 10;
    var _y = 10;
    if (game.toolong >= 0)
    {
        _x = 10 + random_range(-1, 1);
        _y = 10 + random_range(-1, 1);
        game.toolong--;
    }
    draw_set_color(c_black);
    draw_rectangle(_x + barxoffset, _y, _x + 10 + barxoffset, bot, false);
    if (game.toolong >= 0)
    {
        draw_sprite(mt0_spr_progressbar, 1, _x + 1 + barxoffset, _y + 1);
    }
    else
    {
        draw_sprite(mt0_spr_progressbar, 0, _x + 1 + barxoffset, _y + 1);
    }
    draw_set_color(c_black);
    draw_healthbar(_x + barxoffset, _y, _x + 10 + barxoffset, bot, (polylength / maxlength) * 100, c_black, c_black, c_black, 2, false, false);
    draw_set_color(c_white);
}

function mt0scr_pop_init()
{
    die = 1;
    spd = random_range(1, 4);
    falloff = random_range(0.03, 0.1);
    life = random_range(10, 30);
    startx = 240;
    starty = 135;
    startspd = spd / 1.5;
    dir = 0;
}

function mt0scr_pop_tick()
{
    if (die != 0)
    {
        startx = x;
        starty = y;
        dir = point_direction(x, y, centerx, centery) + 180;
        x += lengthdir_x(spd * 2, dir);
        y += lengthdir_y(spd * 2, dir);
    }
    die = 0;
    x += lengthdir_x(spd, dir);
    y += lengthdir_y(spd, dir);
    startx += lengthdir_x(startspd, dir);
    starty += lengthdir_y(startspd, dir);
    spd = lerp(spd, 0, falloff);
    if (life <= 0)
    {
        destroy_object(self);
    }
    life--;
}

function mt0scr_pop_draw()
{
    draw_set_color(linecol);
    draw_line_width(x, y, startx, starty, 2);
    draw_set_color(c_white);
}

function convert_array_for_point_in_polygon(arg0)
{
    var input_array = arg0;
    var output_array = [];
    for (var i = 1; i < array_length(input_array); i++)
    {
        var sub_array = input_array[i];
        array_push(output_array, sub_array[0]);
        array_push(output_array, sub_array[1]);
    }
    return output_array;
}

function mt0scr_create_pop_particle()
{
    var p = drawpoints;
    var plen = array_length(p);
    var cenx = 0;
    var ceny = 0;
    for (var i = 1; i < plen; i++)
    {
        cenx += (p[i][0] / plen);
        ceny += (p[i][1] / plen);
    }
    for (var i = 4; i < plen; i += 3)
    {
        create_object("pop", 
        {
            x: p[i][0],
            y: p[i][1],
            centerx: cenx,
            centery: ceny,
            linecol: linecol[i - 1]
        });
    }
}

function mt0_metascript_start()
{
    player.sound = sfx_play(mt0_snd_walk, true);
}

function mg_sGrizz() : minigame_constructor() constructor
{
    name = "Grizz Crossing";
    prompt = "CROSS!";
    time_limit = 10;
    music = ms0_mus;
    music_bpm = 128;
    control_style = build_control_style(["dleft", "dright", "spacebar"]);
    var playervars = {};
    with (playervars)
    {
        x = 0;
        y = 0;
        image_xscale = 1;
        xv = 0;
        yv = 0;
        sprite_index = ms0_spr_player;
        skid = -1;
        hsp = 0;
        vsp = 0;
        grv = 0.15;
        onfloor = false;
        walkspd = 0;
        maxwalkspd = 2.5;
        acel = 0.1;
        decel = 0.3;
        aimside = 1;
        kyote = 0;
        maxkyote = 8;
        jumpheight = -4;
    }
    define_object("player", 
    {
        tick: ms0scr_player_tick
    }, playervars);
    define_object("goal", 
    {
        tick: ms0scr_goal_tick
    }, 
    {
        sprite_index: ms0_spr_flag
    });
    define_object("platform", {}, {});
    metascript_init = ms0_metascript_init;
    metascript_tick_before = ms0_metascript_tick_before;
    metascript_draw_before = ms0_metascript_draw_before;
    metascript_draw_after = ms0_metascript_draw_after;
}

function ms0_metascript_init()
{
    p = 0;
    clouds_x = 0;
    show_win = 0;
    lives_shake_x = 0;
    lives_shake_y = 0;
    levellayout[0] = [["player", [130, 170]], ["long platform", [130, 180]], ["short platform", [235, 153]], ["long platform", [338, 127]], ["flag", [338, 121]]];
    levellayout[1] = [["player", [330, 106]], ["long platform", [318, 106]], ["short platform", [168, 173]], ["flag", [155, 167]]];
    levellayout[2] = [["player", [205, 178]], ["short platform", [205, 178]], ["long platform", [314, 140]], ["long platform", [166, 108]], ["flag", [166, 102]]];
    fliplayout = choose(0, 1);
    l = irandom_range(0, array_length(levellayout) - 1);
    for (var i = 0; i < array_length(levellayout[l]); i++)
    {
        var xx = levellayout[l][i][1][0];
        var yy = levellayout[l][i][1][1];
        if (fliplayout)
        {
            xx = get_screen_width() - xx;
        }
        switch (levellayout[l][i][0])
        {
            case "player":
                player = create_object("player", 
                {
                    x: xx,
                    y: yy
                });
                break;
            case "short platform":
                platform[p] = create_object("platform", 
                {
                    x: xx,
                    y: yy,
                    sprite_index: ms0_spr_platform1
                });
                p++;
                break;
            case "long platform":
                platform[p] = create_object("platform", 
                {
                    x: xx,
                    y: yy,
                    sprite_index: ms0_spr_platform2
                });
                p++;
                break;
            case "flag":
                goal = create_object("goal", 
                {
                    x: xx,
                    y: yy
                });
                break;
        }
    }
    player.image_xscale = sign(get_screen_height() - player.x);
}

function ms0_metascript_tick_before()
{
    clouds_x += (0.08333333333333333 * get_game_speed());
    show_win += ((real(get_win_state() == 1) - show_win) * 0.4 * get_game_speed());
    lives_shake_x += sign(0 - lives_shake_x);
    lives_shake_x *= -1;
}

function ms0_metascript_draw_before()
{
    draw_sprite(ms0_spr_bg, 0, 0, 0);
    draw_sprite(ms0_spr_bg_clouds, 0, clouds_x, 0);
    shader_set_wavy(ms0_spr_bg_clouds_reflection, get_current_frame() / 10, 0.2, 100, 1, 0.5, 100, 1);
    draw_sprite(ms0_spr_bg_clouds_reflection, 0, clouds_x, 0);
    shader_reset();
    shader_set_wavy(ms0_spr_bg_reflection, get_current_frame() / 10, 0.2, 100, 1, 0.5, 100, 1);
    draw_sprite(ms0_spr_bg_reflection, 0, 0, 0);
    shader_reset();
    draw_sprite(ms0_spr_bg_candy, 0, 0, 0);
    draw_sprite(ms0_spr_bg_buildings, 0, 0, 0);
}

function ms0_metascript_draw_after()
{
    gpu_set_blendmode_multiply();
    draw_sprite(ms0_spr_multiplywinshade, 0, 219 * (-1 + show_win), 0);
    draw_sprite_ext(ms0_spr_multiplywinshade, 0, get_screen_width() + (219 * (1 - show_win)), 0, -1, 1, 0, c_white, 1);
    gpu_set_blendmode(bm_normal);
    draw_sprite(ms0_spr_bottomleftwin, 0, get_screen_width() * (-1 + show_win), get_screen_height());
    draw_sprite(ms0_spr_toprightwin, 0, get_screen_width() * (2 - show_win), 0);
    draw_sprite(ms0_spr_lives, clamp(get_game_lives(), 0, 4), lives_shake_x, lives_shake_y);
}

function ms0scr_player_tick()
{
    var _inp = get_input();
    var ikey = _inp.key;
    var movex = ikey.right - ikey.left;
    if (movex != 0)
    {
        walkspd = lerp(walkspd, maxwalkspd * movex, acel);
    }
    else
    {
        walkspd = lerp(walkspd, 0, decel);
    }
    var game_speed = get_game_speed();
    hsp = walkspd * game_speed;
    vsp += (grv * (game_speed * 1.1));
    x = clamp(x, 0, get_screen_width());
    if (onfloor)
    {
        kyote = maxkyote;
    }
    if (ikey.space_press)
    {
        if (onfloor || kyote > 0)
        {
            kyote = 0;
            vsp = jumpheight + (-(game_speed - 1) * 1.6);
            sfx_play(ms0_snd_jump);
        }
    }
    uphold = ikey.space;
    if (vsp < 0 && !uphold)
    {
        vsp = max(vsp, jumpheight / 2);
    }
    kyote--;
    onfloor = false;
    var game = get_meta_object();
    for (var i = 0; i < game.p; i++)
    {
        var plat = game.platform[i];
        if (collide_obj_fast(self, x + hsp, y, plat, plat.x, plat.y))
        {
            while (!collide_obj_fast(self, x + sign(hsp), y, plat, plat.x, plat.y))
            {
                x += sign(hsp);
            }
            hsp = 0;
        }
        if (collide_obj_fast(self, x, y + vsp, plat, plat.x, plat.y))
        {
            while (!collide_obj_fast(self, x, y + sign(vsp), plat, plat.x, plat.y))
            {
                y += sign(vsp);
            }
            vsp = 0;
        }
        while (collide_obj_fast(self, x, y, plat, plat.x, plat.y))
        {
            y--;
        }
        onfloor = onfloor || collide_obj_fast(self, x, y + 1, plat, plat.x, plat.y);
    }
    x += hsp;
    y += vsp;
    aimside = movex;
    if (aimside != 0)
    {
        image_xscale = aimside;
    }
    if (movex != 0)
    {
        image_speed = abs(hsp / 2);
    }
    else
    {
        image_speed = 1;
    }
    if (skid <= 0)
    {
        if (hsp >= -0.1 && hsp <= 0.1)
        {
            sprite_index = ms0_spr_player;
        }
        else
        {
            sprite_index = ms0_spr_player_run;
        }
    }
    else
    {
        if (sprite_index != ms0_spr_player_turn && onfloor)
        {
            sfx_play(ms0_snd_skid);
        }
        sprite_index = ms0_spr_player_turn;
    }
    if (movex != 0 && sign(hsp) != aimside && hsp != 0)
    {
        skid = 12;
    }
    skid--;
    if (!onfloor)
    {
        sprite_index = ms0_spr_player_jump;
    }
    if (y >= get_screen_height())
    {
        if (get_win_state() == 0)
        {
            sfx_play(ms0_snd_lose);
            game.lives_shake_x = 5;
        }
        game_lose();
    }
}

function ms0scr_goal_tick()
{
    var game = get_meta_object();
    if (collide_obj_fast(self, x, y, game.player, game.player.x, game.player.y))
    {
        if (get_win_state() == 0)
        {
            sfx_play(ms0_snd_win);
        }
        game_win();
    }
    if (get_win_state() == 1)
    {
        image_angle += 35;
    }
}

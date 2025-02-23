function mg_tDuel() : minigame_constructor() constructor
{
    name = "Duel";
    prompt = "DUEL!";
    use_prompt = true;
    use_timer = true;
    time_limit = 24;
    music = sfx_none;
    music_bpm = 128;
    music_loops = false;
    music_ignore_bpm = false;
    control_style = build_control_style(["spacebar"]);
    screen_w = 480;
    screen_h = 270;
    metascript_init = mt2_metascript_init;
    metascript_start = mt2_metascript_start;
    metascript_tick_before = mt2_metascript_tick_before;
    metascript_tick_after = metascript_blank;
    metascript_draw_before = mt2_metascript_draw_before;
    metascript_draw_after = metascript_blank;
    metascript_cleanup = metascript_blank;
    define_object("guy");
    define_object("you", {}, 
    {
        sprite_index: mt2_spr_you
    });
}

function mt2_metascript_init()
{
    active = false;
    ystart = 210;
    ytarget = 165;
    yy = ystart;
    t = 0.001;
    i = 0;
    lose = false;
    randomize();
    shootbeat = irandom_range(24, 40) / 4;
    canshoot = false;
    losetime = 0;
    shoottimer = 35;
    backshake = [[0, 0], [0, 0], [0, 0]];
    shake_intensity = 4;
    guy2 = create_object("guy", 
    {
        x: 240,
        y: 0,
        sprite_index: mt2_spr_vick
    });
    guy1 = create_object("guy", 
    {
        x: 240,
        y: 0,
        sprite_index: mt2_spr_rin
    });
    you_sign = create_object("you", 
    {
        x: 240,
        y: guy1.y
    });
    show_debug_message(shootbeat);
    
    do_lose_anim = function()
    {
        if (guy1.sprite_index != mt2_spr_rin_die)
        {
            guy1.sprite_index = mt2_spr_rin_die;
            guy1.image_index = 0;
            guy1.image_speed = 1 * get_game_speed();
            guy1.y = 135;
            guy1.depth = -1;
            guy2.image_index = 0;
            update_draw_order();
            canshoot = false;
            sfx_play(mt2_snd_gunshot);
            outro_beat = ceil(current_beat + 1);
        }
    };
    
    musvol = audio_sound_get_gain(obj_minigame_controller.game_music);
    outro_beat = get_time_limit() - 1;
}

function mt2_metascript_start()
{
    active = true;
    sfx_play(mt2_snd_wind);
}

function mt2_metascript_tick_before()
{
    var input = get_input();
    if (active)
    {
        t += (0.0005 * ((get_game_speed() * 2) - 1));
        t = clamp(t, 0, 1);
        yy = lerp(yy, ytarget, t);
    }
    if (get_win_state() == 0 && !canshoot)
    {
        guy1.y = yy;
        guy2.y = yy;
    }
    current_beat = get_time_limit() - get_time();
    you_sign.y = guy1.y;
    if (abs(yy - ytarget) < 0.2)
    {
        you_sign.image_alpha = lerp(you_sign.image_alpha, 0, 0.1);
    }
    var lowvol = 0.2;
    if (current_beat <= 1)
    {
        var _prog = clamp(current_beat, 0, 1);
        audio_sound_gain(obj_minigame_controller.game_music, lerp(musvol, musvol * lowvol, _prog), 0);
    }
    else if (current_beat > outro_beat)
    {
        var _prog = clamp(current_beat - outro_beat, 0, 1);
        audio_sound_gain(obj_minigame_controller.game_music, lerp(musvol * lowvol, musvol, _prog), 0);
    }
    for (var i = 0; i < array_length(backshake) && canshoot && (get_current_frame() % 2) == 0; i++)
    {
        var _thisshake = backshake[i];
        _thisshake[0] = random_range(-5, 5) * shake_intensity;
        _thisshake[1] = random_range(-5, 5) * shake_intensity;
    }
    if (canshoot)
    {
        shake_intensity = lerp(shake_intensity, 1, 0.1);
    }
    if (current_beat >= shootbeat && !canshoot && get_win_state() == 0)
    {
        canshoot = true;
        sfx_play(mt2_snd_now);
        audio_stop_sound(mt2_snd_wind);
        for (var i = 0; i < array_length(backshake); i++)
        {
            backshake[i] = [irandom_range(6, 10) * choose(-1, 1), irandom_range(6, 10) * choose(-1, 1)];
        }
        guy1.image_index = 1;
        guy2.image_index = 1;
    }
    if (input.key.space_press && get_win_state() == 0 && shoottimer > 0 && round(yy) == ytarget)
    {
        if (canshoot)
        {
            guy2.sprite_index = mt2_spr_vick_die;
            guy2.image_speed = 1 * get_game_speed();
            guy2.y = 135;
            guy2.image_index = 0;
            guy2.depth = -1;
            update_draw_order();
            outro_beat = ceil(current_beat + 1);
            sfx_play(mt2_snd_gunshot);
            game_win();
        }
        else
        {
            lose = true;
            guy1.sprite_index = mt2_spr_rin_click;
            guy2.sprite_index = mt2_spr_vick_crazy;
            sfx_play(mt2_snd_click);
            game_lose();
        }
        canshoot = false;
    }
    if (get_win_state() == 1)
    {
        if (guy2.image_index >= (sprite_get_number(mt2_spr_vick_die) - 1))
        {
            guy2.image_index = sprite_get_number(mt2_spr_vick_die) - 1;
            guy2.image_speed = 0;
        }
        guy1.sprite_index = mt2_spr_rin;
        guy1.image_index = 0;
    }
    else if (lose)
    {
        switch (guy1.sprite_index)
        {
            case mt2_spr_rin_click:
                if (guy1.image_index >= (sprite_get_number(mt2_spr_rin_click) - 1))
                {
                    do_lose_anim();
                }
                break;
            case mt2_spr_rin_die:
                if (guy1.image_index >= (sprite_get_number(mt2_spr_rin_die) - 1))
                {
                    guy1.image_speed = 0;
                    guy1.image_index = sprite_get_number(mt2_spr_rin_die) - 1;
                }
                break;
        }
    }
    if (canshoot)
    {
        shoottimer--;
        if (shoottimer <= 0)
        {
            lose = true;
            do_lose_anim();
            game_lose();
        }
    }
}

function mt2_metascript_draw_before()
{
    if (!canshoot)
    {
        draw_clear(c_white);
    }
    else
    {
        draw_clear(c_black);
        var cx = 240;
        var cy = 135;
        draw_sprite(mt2_spr_rin_back, 0, cx + backshake[0][0], cy + backshake[0][1]);
        draw_sprite(mt2_spr_vin_back, 0, cx + backshake[1][0], cy + backshake[1][1]);
        draw_sprite(mt2_spr_back_alert, 0, cx + backshake[2][0], cy + backshake[2][1]);
    }
}

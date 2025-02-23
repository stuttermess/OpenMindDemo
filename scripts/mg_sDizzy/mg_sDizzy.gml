function mg_sDizzy() : minigame_constructor() constructor
{
    name = "Dizzy";
    prompt = "SPIN!";
    time_limit = 12;
    music = ms11_mus;
    music_bpm = 128;
    control_style = build_control_style(["cmove"]);
    metascript_init = ms11_metascript_init;
    metascript_start = ms11_metascript_start;
    metascript_tick_before = ms11_metascript_tick_before;
    metascript_draw_before = ms11_metascript_draw_before;
    metascript_draw_after = ms11_metascript_draw_after;
    metascript_cleanup = ms11_metascript_cleanup;
    define_object("pippi", 
    {
        init: ms11scr_pippi_init,
        tick: ms11scr_pippi_tick,
        draw: ms11scr_pippi_draw
    });
}

function ms11scr_pippi_init()
{
    sprite_index = ms11_spr_pippi;
    x = get_screen_width() / 2;
    y = (get_screen_height() / 2) - 15;
    eye1x = 202.5;
    eye1y = 124.5;
    eye2x = 277.5;
    eye2y = 124.5;
    eyerot = 0;
    previous_angle = eyerot;
    rev = 0;
    prevrev = rev;
    revolutions = 0;
    revolutionstowin = 6;
    sf = surface_create(sprite_get_width(sprite_index), 270);
    wavyness = 0;
    scale = 1;
    targetscale = 1;
    spinsnd = -1;
}

function ms11scr_pippi_tick()
{
    var input = get_input();
    var imouse = input.mouse;
    eyerot = point_direction(x, y, imouse.x, imouse.y) - 90;
    anglediff = eyerot - previous_angle;
    if (spinsnd != -1)
    {
        audio_sound_pitch(spinsnd, (scale * 1) + clamp(abs(anglediff) / 20, 1, 1.5));
    }
    if (anglediff > get_screen_height())
    {
        prevrev = rev;
        rev++;
    }
    else if (anglediff < -get_screen_height())
    {
        prevrev = rev;
        rev--;
    }
    revolutions = max(abs(prevrev), abs(rev));
    var towavystart = revolutionstowin / 3;
    var _wavy_prog = clamp((revolutions - towavystart) / towavystart, 0, 1);
    wavyness = lerp(wavyness, _wavy_prog, 0.3);
    targetscale = 1 + (revolutions / 20);
    scale = lerp(scale, targetscale, 0.4);
    image_xscale = scale;
    image_yscale = scale;
    previous_angle = eyerot;
    var game = get_meta_object();
    if (revolutions >= revolutionstowin && get_win_state() == 0)
    {
        audio_stop_sound(spinsnd);
        game_win();
        var _snd = sfx_play(ms11_snd_fall);
        audio_sound_gain(_snd, 2, 0);
        destroy_object();
        game.won = true;
    }
}

function ms11scr_pippi_draw()
{
    var game = get_meta_object();
    if (!surface_exists(sf))
    {
        sf = surface_create(sprite_get_width(sprite_index), 270);
    }
    surface_set_target(sf);
    draw_clear_alpha(c_white, 0);
    matrix_set(2, matrix_build(((surface_get_width(sf) - 480) / 2) + game.bg_x, game.bg_y, 0, 0, 0, 0, 1, 1, 1));
    draw_sprite_ext(ms11_spr_pippi_eye_whites, 0, x, y, scale * 1.5, scale * 1.5, 0, c_white, 1);
    draw_sprite_ext(ms11_spr_pippi_eye, 0, eye1x, eye1y, scale, scale, eyerot, c_white, 1);
    draw_sprite_ext(ms11_spr_pippi_eye, 0, eye2x, eye2y, scale, scale, eyerot, c_white, 1);
    _draw_self();
    matrix_set(2, matrix_build_identity());
    surface_reset_target();
    shader_set_wavy_texture(surface_get_texture(sf), get_current_frame(), 0.2, 40, wavyness * 5, 0, 0, 0);
    draw_surface(sf, -20, 0);
    shader_reset();
}

function ms11_metascript_init()
{
    var game = get_meta_object();
    struct_set(game, "won", false);
    won = false;
    i = 0;
    pippi = create_object("pippi");
    xx = 0;
    freq = 6;
    playcrash = false;
    bg_x = 0;
    bg_y = 0;
}

function ms11_metascript_start()
{
    with (pippi)
    {
        spinsnd = sfx_play(ms11_snd_spin, true, 1.7);
    }
}

function ms11_metascript_tick_before()
{
    game = get_meta_object();
    var input = get_input();
    imouse = input.mouse;
    if (game.won)
    {
        i += 0.15;
        if (i >= 7 && !playcrash)
        {
            playcrash = true;
            var _snd = sfx_play(ms11_snd_crash);
            audio_sound_gain(_snd, 2, 0);
        }
        won = true;
        bg_x = lerp(bg_x, 0, 0.2);
        bg_y = lerp(bg_y, 0, 0.2);
    }
    else
    {
        bg_x = (imouse.x - (get_screen_width() / 2)) * -0.025;
        bg_y = (imouse.y - (get_screen_height() / 2)) * -0.025;
    }
}

function ms11_metascript_draw_before()
{
    draw_clear(c_teal);
    shader_set_wavy(ms11_spr_bg, get_current_frame() / 6, 0.35, 50, 4, 0, 0, 0);
    draw_sprite_ext(ms11_spr_bg, 0, (get_screen_width() / 2) + xx + (bg_x / 5), (get_screen_height() / 2) + (bg_y / 5), 0.6 + (pippi.scale * 0.5), 0.6 + (pippi.scale * 0.5), 0, c_white, 1);
    shader_reset();
}

function ms11_metascript_draw_after()
{
    if (game.won)
    {
        pippi.scale = 1;
        draw_sprite_ext(ms11_spr_fall, i, get_screen_width() / 2, get_screen_height() / 2, pippi.scale, pippi.scale, 0, c_white, 1);
        if (i >= 7)
        {
            xx = random_range(-freq, freq);
            freq = lerp(freq, 0, 0.05);
        }
    }
    else
    {
        evidently_the_arrows_are_not_temp = true;
        draw_sprite_ext(ms11_spr_arrows_temp, 0, get_screen_width() / 2, (get_screen_height() / 2) - 5, 1, 1, get_current_frame() * 1.5 * 2.5, c_white, 2.5 - (pippi.scale * 2));
        draw_sprite(ms11_spr_icecream, get_current_frame() / 5, imouse.x, imouse.y);
    }
}

function ms11_metascript_cleanup()
{
    surface_free(pippi.sf);
}

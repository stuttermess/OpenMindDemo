function mg_sPcMash() : minigame_constructor() constructor
{
    name = "Pc Mash";
    prompt = "SPAM!";
    time_limit = 18;
    music = ms4_mus;
    music_bpm = 128;
    control_style = build_control_style(["keyboard"]);
    metascript_init = ms4_metascript_init;
    metascript_tick_before = ms4_metascript_tick_before;
    metascript_tick_after = ms4_metascript_tick_after;
    metascript_draw_before = ms4_metascript_draw_before;
    metascript_draw_after = ms4_metascript_draw_after;
    metascript_cleanup = ms4_metascript_cleanup;
    define_object("text", 
    {
        init: ms4scr_text_init,
        tick: ms4scr_text_tick,
        draw: ms4scr_text_draw
    });
    define_object("textparticle", 
    {
        init: ms4scr_textparticle_init,
        tick: ms4scr_textparticle_tick,
        draw: ms4scr_textparticle_draw
    });
}

function ms4_metascript_cleanup()
{
}

function ms4_metascript_init()
{
    var _keys = "1234567890QWERTYUIOPASDFGHJKLZXCVBNM";
    for (var _i = 1; _i <= string_length(_keys); _i++)
    {
        ds_list_add(master.input_keys_check, string_char_at(_keys, _i));
    }
    textparticle[0] = 0;
    won = false;
    text = create_object("text", 
    {
        x: 60,
        y: 60
    });
    zoom = 1;
    yy = 0;
    i = 0;
    shakeamt = 0;
    shakelen = 0;
    shx = 0;
    shy = 0;
}

function ms4_metascript_tick_before()
{
    shakelen--;
}

function ms4_metascript_tick_after()
{
    if (won && i >= 30)
    {
        zoom = lerp(zoom, 0.38, 0.1);
        yy = lerp(yy, 15, 0.1);
    }
    if (won)
    {
        i++;
    }
}

function ms4_metascript_draw_before()
{
    draw_clear(#84B3EA);
}

function ms4_metascript_draw_after()
{
    if (won && i >= 30)
    {
        draw_surface_ext(text.surf, (get_screen_width() / 2) - (surface_get_width(text.surf) * zoom * 0.5), (get_screen_height() / 2) - (surface_get_height(text.surf) * zoom * 0.5) - yy, zoom, zoom, 0, c_white, 1);
        draw_sprite_ext(ms4_spr_computer_bg, 0, get_screen_width() / 2, get_screen_height() / 2, 2.8 * zoom, 2.8 * zoom, 0, c_white, 1);
    }
    else
    {
        if (shakelen > 0)
        {
            shx = random_range(-shakeamt, shakeamt);
            shy = random_range(-shakeamt, shakeamt);
        }
        else
        {
            shx = 0;
            shy = 0;
        }
        if (surface_exists(text.surf))
        {
            draw_surface(text.surf, 0, 0);
        }
    }
}

function ms4scr_text_init()
{
    keyboard_string = "";
    width = 225;
    mjtext = "bro i went to just grab cereal wth is he even doing";
    textheight = 0;
    txt = "";
    textstartx = 82.5;
    endX = textstartx;
    scrollamt = 0;
    lastkeyboard_string = "";
    xmov = 0;
    ymov = 0;
    wonmoveup = 0;
    charactersneededtowin = 200 / get_game_speed();
    tickamt = 0;
    chars = "ADSKJHFSADJHLGHIUDSOG";
    _str = "";
    chardelayfactor = 0;
    charamt = 0;
    charaddamt = 1;
    chardelay = 100;
    charaddspd = 60;
    surf = surface_create(get_screen_width(), get_screen_height());
}

function ms4scr_text_tick()
{
    var game = get_meta_object();
    var _input = get_input();
    var r = random_range(0, string_length(chars) + 1);
    c = string_char_at(chars, r);
    charactersneededtowin = 200 / get_game_speed();
    charactersneededtowin = max(30, charactersneededtowin);
    if (!game.won)
    {
        if (string_length(_str) >= 1)
        {
            var lines = [];
            var currentLine = "";
            for (var i = 1; i <= string_length(_str); i++)
            {
                currentLine += string_char_at(_str, i);
                if (string_width(currentLine) > width)
                {
                    array_push(lines, currentLine);
                    currentLine = string_char_at(_str, i);
                }
            }
            if (currentLine != "")
            {
                array_push(lines, currentLine);
            }
            var lastLine = lines[array_length(lines) - 1];
            endX = textstartx + string_width(lastLine);
        }
        if (_input.key.any_press)
        {
            charamt += charaddamt;
            chardelayfactor = charamt / charaddamt;
            var rr = random_range(0, string_length(chars) + 1);
            var cc = string_char_at(chars, rr);
            _str += cc;
            game.shakeamt = 1 + (clamp((string_length(_str) - 30) / charactersneededtowin, 0, 1) * 10);
            game.shakelen = 10;
            var _snd = sfx_play(choose(ms4_snd_type1, ms4_snd_type2, ms4_snd_type3));
            audio_sound_gain(_snd, random_range(0.8, 1.2), 0);
            audio_sound_pitch(_snd, random_range(0.9, 1.1));
        }
        if (chardelayfactor >= 1)
        {
            chardelay = charaddspd / chardelayfactor;
        }
        if (tickamt >= chardelay)
        {
            tickamt = 0;
            _str += c;
            game.textparticle[array_length(game.textparticle)] = create_object("textparticle", 
            {
                char: c,
                x: endX,
                y: 212
            });
        }
        tickamt++;
        chardelay += 1;
        chardelayfactor = max(0.01, chardelayfactor - 1);
    }
    if (string_length(txt) >= charactersneededtowin && get_win_state() != 1)
    {
        game_win();
        game.won = true;
        wonmoveup = 24;
    }
}

function ms4scr_text_draw()
{
    var game = get_meta_object();
    if (!surface_exists(surf))
    {
        surf = surface_create(get_screen_width(), get_screen_height());
    }
    surface_set_target(surf);
    draw_sprite(ms4_spr_bg, 0, get_screen_width() / 2, get_screen_height() / 2);
    draw_sprite(ms4_spr_bg, 0, (get_screen_width() / 2) + xmov + game.shx, (get_screen_height() / 2) + ymov + game.shy);
    gpu_set_blendmode_multiply();
    draw_sprite(ms4_spr_MULTwindowshadow, 0, xmov + game.shx, ymov + game.shy);
    gpu_set_blendmode(bm_normal);
    draw_sprite(ms4_spr_window, 0, 0 + xmov + game.shx, 0 + ymov + game.shy);
    draw_set_font(fnt_ms4);
    draw_set_color(#293189);
    draw_sprite(ms4_spr_mj, 0, textstartx + xmov + game.shx, (((60 - textheight) + ymov) - wonmoveup) + game.shy);
    draw_sprite(ms4_spr_cat, 0, textstartx + xmov + game.shx, (((60 - textheight) + ymov) - wonmoveup) + game.shy);
    draw_text_ext(textstartx + xmov + game.shx, (((180 - textheight) + ymov) - wonmoveup) + game.shy, mjtext, 15, width);
    draw_sprite(ms4_spr_mj, 0, textstartx + xmov + game.shx, (((180 - textheight) + ymov) - wonmoveup) + game.shy);
    draw_set_valign(fa_bottom);
    txt = string_to_wrapped(string_upper(_str), width, "\n", true);
    if (!game.won)
    {
        txt += "|";
    }
    textheight = max(string_height("M"), string_height(txt));
    scrollamt = string_height(txt) / string_height("M");
    var textbar_h = 1;
    if (wonmoveup == 0)
    {
        textbar_h = max(1, string_height(txt) / 21);
    }
    else
    {
        draw_sprite(ms4_spr_sp, 0, textstartx + xmov + game.shx, ((202.5 + ymov) - textheight) + game.shy);
    }
    draw_sprite_ext(ms4_spr_textbar, 0, textstartx + xmov + game.shx, 229.5 + ymov + game.shy, 1, textbar_h, 0, c_white, 1);
    draw_text(textstartx + xmov + game.shx, ((228 + ymov) - wonmoveup) + game.shy, txt);
    draw_sprite(ms4_spr_topbar, 0, (get_screen_width() / 2) + xmov + game.shx, 0 + ymov + game.shy);
    draw_set_valign(fa_top);
    draw_sprite(ms4_spr_sp, 0, textstartx + xmov + game.shx, 213 + ymov + game.shy);
    draw_sprite(ms4_spr_arrow, 0, 412.5 + xmov + game.shx, 219 + ymov + game.shy);
    draw_set_color(c_white);
    draw_set_font(fnt_pixel);
    var timer = get_timer();
    if (string_length(txt) <= (charactersneededtowin / 2))
    {
        draw_sprite(ms4_spr_emoji3, timer, 379.5 + xmov + game.shx, 21 + ymov + game.shy);
        draw_sprite(ms4_spr_emoji1, timer, 375 + xmov + game.shx, 216 + ymov + game.shy);
    }
    else
    {
        draw_sprite(ms4_spr_emoji4, timer, 379.5 + xmov + game.shx, 21 + ymov + game.shy);
        draw_sprite(ms4_spr_emoji2, timer, 375 + xmov + game.shx, 216 + ymov + game.shy);
    }
    for (var i = 0; i < array_length(game.textparticle); i++)
    {
        with (game.textparticle[i])
        {
            ms4scr_textparticle_draw();
        }
    }
    surface_reset_target();
    if (game.won == true && (get_current_frame() % 3) == 0)
    {
    }
}

function ms4scr_textparticle_init()
{
    game = get_meta_object();
    char = "W";
    hsp = random_range(-2, 2);
    vsp = random_range(-3, -1);
    grv = 0.1;
    rot = 0;
    rotspd = random_range(-10, 10);
    maxlife = 100;
    life = maxlife;
}

function ms4scr_textparticle_tick()
{
    x += hsp;
    y += vsp;
    vsp += grv;
    rot += rotspd;
    life--;
    if (life <= 0)
    {
        array_shift(game.textparticle);
        destroy_object();
    }
}

function ms4scr_textparticle_draw()
{
    draw_set_font(fnt_ms4);
    var c = 8991017;
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed_color(x, y, char, 1, 1, rot, c, c, c, c, 1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}

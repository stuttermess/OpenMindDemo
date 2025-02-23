function mg_sDial() : minigame_constructor() constructor
{
    name = "Dial";
    prompt = "DIAL!";
    time_limit = 14;
    efin_skip_amount = 5;
    music = ms12_mus;
    music_bpm = 128;
    gimmick_blacklist = [gimmick_flip];
    control_style = build_control_style(["cmove", "cclick"]);
    metascript_init = ms12_metascript_init;
    metascript_tick_before = ms12_metascript_tick_before;
    metascript_tick_after = ms12_metascript_tick_after;
    metascript_draw_before = ms12_metascript_draw_before;
    metascript_draw_after = ms12_metascript_draw_after;
    define_object("spacebar", 
    {
        init: ms12scr_button_init,
        tick: ms12scr_button_tick,
        draw: ms12scr_button_draw
    });
}

function ms12scr_button_init()
{
    sprite_index = ms12_spr_button;
    myid = -1;
    pushtimer = 0;
    x = 0;
    y = 0;
}

function ms12scr_button_draw()
{
    var game = get_meta_object();
    draw_sprite(sprite_index, image_index, x + round(game.randx), y + round(game.randy));
    var btn_yoff = 16.5;
    if (image_index == 0)
    {
        btn_yoff = 12;
    }
    else
    {
    }
    draw_sprite(ms12_spr_numbers, myid, ceil(x + 15) + round(game.randx), ceil(y + btn_yoff) + round(game.randy));
}

function ms12scr_button_tick()
{
    str = function(arg0)
    {
        return string(arg0);
    };
    
    image_index = 0;
    var input = get_input();
    var imouse = input.mouse;
    var game = get_meta_object();
    if (game.won)
    {
        exit;
    }
    for (var i = 0; i < string_length(game.num); i++)
    {
        var n = string(game.dialnum);
        if (string_char_at(game.num, i + 1) != string_char_at(n, i + 1))
        {
            game.num = "";
            game.shake = 2;
            sfx_play(ms12_snd_error);
        }
    }
    if (imouse.click_press)
    {
        var spr = sprite_index;
        var x1 = sprite_get_bbox_left(spr) + x;
        var y1 = sprite_get_bbox_top(spr) + y;
        var x2 = sprite_get_bbox_right(spr) + x;
        var y2 = sprite_get_bbox_bottom(spr) + y;
        if (point_in_rectangle(imouse.x, imouse.y, x1, y1, x2, y2))
        {
            if (myid <= 8)
            {
                game.num += str(myid + 1);
            }
            else if (myid == 10)
            {
                game.num += "0";
            }
            var btn_snd = sfx_play(ms12_snd_button);
            audio_sound_pitch(btn_snd, 1 + (myid / 10));
        }
    }
    if (imouse.click)
    {
        var spr = sprite_index;
        var x1 = sprite_get_bbox_left(spr) + x;
        var y1 = sprite_get_bbox_top(spr) + y;
        var x2 = sprite_get_bbox_right(spr) + x;
        var y2 = sprite_get_bbox_bottom(spr) + y;
        if (point_in_rectangle(imouse.x, imouse.y, x1, y1, x2, y2))
        {
            image_index = 1;
        }
    }
}

function ms12_metascript_init()
{
    num = "";
    won = false;
    wonscreen_y = 270;
    shake = 0;
    a = 0;
    ringtime = 120;
    phonea = 0;
    ringsound_played = false;
    dialnumx = 285;
    dialnumy = 180;
    phonex = 24;
    phoney = -6;
    randx = 0;
    randy = 0;
    totalbuttons = 12;
    buttonstartx = 37;
    buttonstarty = 107.5;
    buttonbufferx = 1.5;
    buttonbuffery = 4.5;
    buttonwidth = sprite_get_width(ms12_spr_button);
    buttonheight = sprite_get_height(ms12_spr_button);
    numstartx = 57;
    numstarty = 10.5;
    numwidth = sprite_get_width(ms12_spr_numbers) + 1;
    row = 0;
    phonesubimg = 0;
    winphonesubimg = 0;
    winphonex = 0;
    helloclip = false;
    dialnums = ["53669", "22253"];
    if (get_game_difficulty() >= 2)
    {
        array_push(dialnums, "27975");
    }
    dialnum = dialnums[irandom(array_length(dialnums) - 1)];
    dialspr = spr_missing;
    switch (dialnum)
    {
        case "53669":
            dialspr = ms12_spr_combination1;
            winphonesubimg = 1;
            break;
        case "22253":
            dialspr = ms12_spr_combination3;
            winphonesubimg = 3;
            break;
        case "27975":
            dialspr = ms12_spr_combination2;
            winphonesubimg = 2;
            break;
        case 3:
            dialspr = ms12_spr_combination3;
            break;
    }
    var j = 0;
    for (var i = 0; i < totalbuttons; i++)
    {
        var xx = buttonstartx + ((buttonwidth + buttonbufferx) * (i - (row * 3)));
        var yy = buttonstarty + ((buttonheight + buttonbuffery) * row);
        buttonid = i;
        button[i] = create_object("spacebar", 
        {
            x: xx,
            y: yy,
            myid: buttonid
        });
        j++;
        if (j >= 3)
        {
            j = 0;
            row++;
        }
    }
    winphonesubimgtoshow = winphonesubimg;
}

function ms12_metascript_tick_before()
{
    var input = get_input();
    imouse = input.mouse;
    mousespr = 0;
    for (var i = 0; i < array_length(button); i++)
    {
        var spr = ms12_spr_button;
        var x1 = sprite_get_bbox_left(spr) + button[i].x;
        var y1 = sprite_get_bbox_top(spr) + button[i].y;
        var x2 = sprite_get_bbox_right(spr) + button[i].x;
        var y2 = sprite_get_bbox_bottom(spr) + button[i].y;
        if (point_in_rectangle(imouse.x, imouse.y, x1, y1, x2, y2))
        {
            mousespr = 1;
            if (mouse_check_button(mb_left))
            {
                mousespr = 2;
            }
        }
    }
    if (won)
    {
        wonscreen_y += ((135 - wonscreen_y) * 0.5);
    }
}

function ms12_metascript_tick_after()
{
    if (!won)
    {
        var _numpads = [96, 97, 98, 99, 100, 101, 102, 103, 104, 105];
        for (var i = 0; i < array_length(_numpads) && 0; i++)
        {
            if (keyboard_check_pressed(_numpads[i]))
            {
                if (string(i) == string_char_at(dialnum, string_length(num) + 1))
                {
                    num += string(i);
                    var btn_snd = sfx_play(ms12_snd_button);
                    var myid = i;
                    if (myid == 0)
                    {
                        myid = 10;
                    }
                    audio_sound_pitch(btn_snd, 1 + ((myid - 1) / 10));
                }
                else
                {
                    num = "";
                    shake = 2;
                    sfx_play(ms12_snd_error);
                }
            }
        }
    }
    if (num != "")
    {
        if (num == dialnum)
        {
            game_win();
            won = true;
        }
    }
    if (!won)
    {
        winphonesubimg = 0;
    }
    else
    {
        ringtime -= (2 * get_game_speed());
        if (ringtime < 65 && !ringsound_played)
        {
            ringsound_played = true;
            sfx_play(ms12_snd_ring);
        }
        if (ringtime <= -40)
        {
            if (!helloclip)
            {
                helloclip = true;
                sfx_play(ms12_snd_hello, false, 1, 0, clamp(get_game_speed(), 1, 1.5));
            }
        }
    }
}

function ms12_metascript_draw_before()
{
    draw_clear(c_teal);
    draw_sprite(ms12_spr_bg, 0, 0, 0);
    draw_sprite(dialspr, 0, dialnumx, dialnumy);
    randx = random_range(-shake, shake);
    randy = random_range(-shake, shake);
    shake = lerp(shake, 0, 0.05);
    if (shake >= 0.2 && num == "")
    {
        phonesubimg = 2;
    }
    else
    {
        phonesubimg = 0;
    }
    if (won)
    {
        phonesubimg = 1;
    }
    draw_sprite(ms12_spr_phone, 0, phonex + randx, phoney + randy);
    draw_sprite(ms12_spr_phone_screen, phonesubimg, phonex + randx, phoney + randy);
    for (var i = 0; i < string_length(num); i++)
    {
        var n = real(string_char_at(num, i + 1));
        var subimg = n - 1;
        if (n == 0)
        {
            subimg = 10;
        }
        draw_sprite(ms12_spr_numbers, subimg, numstartx + (numwidth * i) + randx, numstarty + randy);
    }
}

function ms12_metascript_draw_after()
{
    draw_sprite(ms12_spr_cursor, mousespr, imouse.x, imouse.y);
    if (won)
    {
        shader_set_wavy_spriteframe(ms12_spr_bg_win, 1, get_current_frame(), 0.1, 400, 3, 0, 0, 0);
        draw_sprite(ms12_spr_bg_win, 1, 240, wonscreen_y);
        shader_reset();
        draw_sprite(ms12_spr_bg_win, 0, 240, wonscreen_y);
        var phonex = 240;
        var phoney = wonscreen_y;
        num = "";
        if (ringtime > 0 && ringtime < 70)
        {
            phonea = sin(ringtime) * 5;
            winphonesubimg = 0;
        }
        else if (ringtime <= -40)
        {
            winphonesubimg = winphonesubimgtoshow;
        }
        if (ringtime <= -50)
        {
            game_win();
        }
        gpu_set_blendmode_multiply();
        draw_sprite_ext(ms12_spr_won_phone_shad, 0, phonex - 2, phoney + 2, 1, 1, phonea, c_white, 1);
        gpu_set_blendmode(bm_normal);
        draw_sprite_ext(ms12_spr_won_phone, winphonesubimg, phonex, phoney, 1, 1, phonea, c_white, 1);
        if (ringtime <= 90)
        {
            a = lerp(a, 1, 0.08);
        }
    }
}

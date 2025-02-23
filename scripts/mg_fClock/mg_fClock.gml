function mg_fClock() : minigame_constructor() constructor
{
    name = "Clock";
    prompt = "SET TIME!";
    time_limit = 16;
    timer_script = timer_tutorial;
    music = mf0_mus;
    music_bpm = 128;
    gimmick_blacklist = [gimmick_popup, gimmick_flip];
    control_style = build_control_style(["cclick"]);
    metascript_init = mf0_metascript_init;
    metascript_tick_before = mf0_metascript_tick_before;
    metascript_draw_before = mf0_metascript_draw_before;
    metascript_draw_after = mf0_metascript_draw_after;
}

function mf0_metascript_init()
{
    difficulty = 0;
    surf = -1;
    time = 0;
    handstate = 0;
    number_blend = 16777215;
    clockhour = 1;
    clockmin = 0;
    houryy = 0;
    minyy = 0;
    showmouse = true;
    wintimerdelay = 30;
    wintimer = wintimerdelay;
    phonehour = irandom_range(1, 12);
    phonemin = irandom_range(1, 5) * 10;
    if (difficulty >= 1)
    {
        phonemin = irandom_range(1, 5) * 5;
    }
}

function mf0_metascript_tick_before()
{
    var input = get_input();
    houryy = lerp(houryy, 0, 0.2);
    minyy = lerp(minyy, 0, 0.2);
    time++;
    number_blend = merge_color(number_blend, c_white, 0.05);
    if (get_win_state() != 0)
    {
        exit;
    }
    if (input.mouse.click_press)
    {
        sfx_play(mf0_snd_click1);
        handstate = 1;
        clockhour++;
        if (clockhour > 12)
        {
            clockhour = 1;
        }
        houryy = 3;
    }
    if (mouse_check_button_pressed(mb_right))
    {
        sfx_play(mf0_snd_click2);
        handstate = 2;
        clockmin += 5;
        if (difficulty == 0)
        {
            clockmin += 5;
        }
        if (clockmin > 55)
        {
            clockmin = 0;
        }
        minyy = 3;
    }
    if (!input.mouse.click && !mouse_check_button(mb_right))
    {
        handstate = 0;
    }
    if (clockhour != 0 && clockmin != 0)
    {
        showmouse = false;
    }
    if (clockhour == phonehour && clockmin == phonemin)
    {
        obj_minigame_controller.current_process_mg.win_on_timeover = true;
        wintimer--;
        if (wintimer <= 0)
        {
            if (get_win_state() == 0)
            {
                sfx_play(mf0_snd_win);
                number_blend = 32768;
            }
            game_win();
        }
    }
    else
    {
        wintimer = wintimerdelay;
        obj_minigame_controller.current_process_mg.win_on_timeover = false;
    }
}

function mf0_metascript_draw_before()
{
    draw_sprite(mf0_spr_roombg, 0, 240, 135);
    if (!surface_exists(surf))
    {
        surf = surface_create(480, 270);
    }
    surface_set_target(surf);
    draw_clear_alpha(c_white, 0);
    shader_set_wavy(mf0_spr_hardlightmask, time, 0.01, 10, 20, 0.01, 10, 20);
    draw_sprite(mf0_spr_hardlightmask, 0, 240, 135);
    shader_reset();
    gpu_set_colorwriteenable(1, 1, 1, 0);
    draw_sprite_tiled(mf0_spr_hardmix, 0, 240 + (time / 5), 135);
    gpu_set_colorwriteenable(1, 1, 1, 1);
    surface_reset_target();
    blendmode_set_hardlight();
    shader_set_wavy(mf0_spr_hardlightmask, time, 0.01, 10, 20, 0.01, 10, 20);
    draw_sprite(mf0_spr_hardlight, 0, 240, 135);
    blendmode_reset();
    blendmode_set_hardmix();
    shader_set(mf0_sh_mask);
    draw_surface(surf, 0, 0);
    shader_reset();
    blendmode_reset();
    draw_sprite(mf0_spr_table, 0, 240, 135);
}

function mf0_metascript_draw_after()
{
    draw_sprite(mf0_spr_clock, 0, 240, 135);
    draw_sprite(mf0_spr_phone, 0, 240, 135);
    draw_sprite(mf0_spr_hand, handstate, 240, 135);
    draw_sprite_ext(mf0_spr_clock_colon, 0, 240, 135, 1, 1, 0, number_blend, 1);
    draw_sprite_ext(mf0_spr_alarm_hour, clockhour, 240, 135 + houryy, 1, 1, 0, number_blend, 1);
    draw_sprite_ext(mf0_spr_alarm_min, clockmin / 5, 240, 135 + minyy, 1, 1, 0, number_blend, 1);
    draw_sprite(mf0_spr_phone_min, phonemin / 5, 240, 135);
    draw_sprite(mf0_spr_phone_hour, phonehour - 1, 240, 135);
    if (showmouse)
    {
        draw_sprite(mf0_spr_mouse, time / 10, 240, 135);
    }
}

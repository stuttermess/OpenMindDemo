function mg_template() : minigame_constructor() constructor
{
    name = "Template";
    prompt = "CLICK!";
    use_prompt = true;
    use_timer = true;
    timer_script = timer_sparkle;
    time_limit = 8;
    show_timer_at = 8;
    music = ms5_mus;
    music_bpm = 128;
    music_loops = false;
    music_ignore_bpm = false;
    control_style = build_control_style(["cursor"]);
    gimmick_blacklist = [];
    screen_w = 480;
    screen_h = 270;
    metascript_init = mg_template_metascript_init;
    metascript_tick_before = mg_template_metascript_tick_before;
    metascript_tick_after = metascript_blank;
    metascript_draw_before = mg_template_metascript_draw_before;
    metascript_draw_after = metascript_blank;
    metascript_cleanup = metascript_blank;
    define_object("guy", 
    {
        init: mg_templatescr_guy_init,
        tick: mg_templatescr_guy_tick
    }, 
    {
        sprite_index: spr_none,
        image_xscale: 2,
        image_yscale: 2
    });
}

function mg_template_metascript_init()
{
    create_object("guy", 
    {
        x: 50,
        y: 50
    });
}

function mg_template_metascript_tick_before()
{
    var input = get_input();
    if (input.mouse.click_press)
    {
        game_win();
    }
}

function mg_template_metascript_draw_before()
{
    draw_sprite(ms10_spr_bg, 0, 240, 135);
}

function mg_templatescr_guy_init()
{
    xoff = irandom_range(-5, 5);
    yoff = irandom_range(-5, 5);
}

function mg_templatescr_guy_tick()
{
    var input = get_input();
    x = input.mouse.x + xoff;
    y = input.mouse.y + yoff;
    image_angle += 9;
    image_index += 0.1;
}

function story_pause_menu_constructor() : menu_constructor() constructor
{
    active = false;
    quit_mode = 0;
    can_click_buttons = true;
    esc_held_start = false;
    
    open = function()
    {
        active = true;
        var quitspr = spr_lubi_btn2;
        if (quit_mode == 0)
        {
            quitspr = spr_lubi_btn2a;
        }
        buttons[2].set_sprite(quitspr);
        esc_held_start = keyboard_check_pressed(vk_escape);
    };
    
    close = function()
    {
        active = false;
    };
    
    options_menu = new options_menu_constructor();
    options_open = false;
    
    options_menu.on_exit = function()
    {
        options_open = false;
        cursor_hover = -1;
    };
    
    var sprs = [spr_lubi_btn0, spr_lubi_btn1, spr_lubi_btn2];
    for (var i = 0; i < array_length(sprs); i++)
    {
        buttons[i] = new button();
        with (buttons[i])
        {
            set_sprite(sprs[i]);
            image_speed = 0;
            image_index = 0;
            
            onhover = function()
            {
                image_index = 1;
            };
            
            onunhover = function()
            {
                image_index = 0;
            };
        }
    }
    
    buttons[0].onclick = function()
    {
        active = false;
        on_resume_click();
        buttons[0]._hovered = false;
        cursor_hover = -1;
        buttons[0].onunhover();
    };
    
    buttons[1].onclick = function()
    {
        var _options_enabled = true;
        if (version_controller.build_type == 3)
        {
            _options_enabled = eventdemo_controller.options_enabled;
        }
        if (_options_enabled)
        {
            options_open = true;
            buttons[1]._hovered = false;
            cursor_hover = -1;
            buttons[1].onunhover();
        }
    };
    
    buttons[2].click_sound = snd_menu_back;
    
    buttons[2].onclick = function()
    {
        if (quit_mode == 1)
        {
            storymode_save();
        }
        can_click_buttons = false;
        on_quit_click();
    };
    
    on_resume_click = function()
    {
    };
    
    on_quit_click = function()
    {
        if (instance_exists(obj_cutscene_sound_loop))
        {
            for (var i = 0; i < instance_number(obj_cutscene_sound_loop); i++)
            {
                with (instance_find(obj_cutscene_sound_loop, i))
                {
                    out_time = 1000;
                    stop();
                }
            }
        }
        start_transition_perlin(on_quit);
    };
    
    standard_on_quit = function()
    {
        with (all)
        {
            switch (object_index)
            {
                case master:
                case transition_controller:
                case eventdemo_controller:
                case eventdemo_network:
                case version_controller:
                    break;
                default:
                    instance_destroy();
                    break;
            }
        }
        if (version_controller.build_type == 3)
        {
            master._restart_game();
        }
        else
        {
            instance_create_depth(0, 0, 0, obj_mainmenu_controller);
            audio_sound_gain(mus_mainmenu, 0, 0);
            audio_sound_gain(mus_mainmenu, 1, 1000);
        }
    };
    
    on_quit = standard_on_quit;
    
    tick = function()
    {
        if (!active)
        {
            exit;
        }
        if (options_open)
        {
            options_menu._tick();
            cursor_hover = options_menu.cursor_hover;
            if (keyboard_check_pressed(vk_escape))
            {
                options_menu.btnback.on_click();
            }
            exit;
        }
        if (can_click_buttons)
        {
            _tick();
            if (!esc_held_start && keyboard_check_pressed(vk_escape))
            {
                buttons[0].onclick();
            }
        }
        if (!keyboard_check(vk_escape))
        {
            esc_held_start = false;
        }
    };
    
    draw = function()
    {
		if (!active)
        {
            exit;
        }
        draw_set_color(#7C8CBE);
        draw_set_alpha(1);
        blendmode_set_multiply();
        draw_rectangle(-1, -1, 481, 271, false);
        blendmode_reset();
        draw_set_color(c_white);
        draw_set_alpha(1);
        if (options_open)
        {
            options_menu._draw();
            exit;
        }
		_draw();
    };
}

function get_input()
{
    var enabled = true;
    if (instance_exists(obj_minigame_controller))
    {
        with (obj_minigame_controller)
        {
            if (current_process_mg != -1)
            {
                if (!minigame_initialized || !minigame_started)
                {
                    enabled = false;
                }
            }
        }
    }
    var _use_any = ds_list_find_index(master.input_keys_check, "any") > -1;
    var _anykey = 0;
    var _anykey_press = 0;
    var _anykey_release = 0;
    var _input = 
    {
        key: {},
        mouse: {}
    };
    with (_input.key)
    {
        var keys = [];
        for (var i = 0; i < ds_list_size(master.input_keys_check); i++)
        {
            var keyname = ds_list_find_value(master.input_keys_check, i);
            switch (keyname)
            {
                case "up":
                    keys[i] = [38, 87];
                    break;
                case "left":
                    keys[i] = [37, 65];
                    break;
                case "down":
                    keys[i] = [40, 83];
                    break;
                case "right":
                    keys[i] = [39, 68];
                    break;
                case "space":
                    keys[i] = [32, 13];
                    break;
                case "any":
                    keys[i] = [];
                    break;
                default:
                    keys[i] = [];
                    if (string_length(keyname) == 1 && string_pos(keyname, "QWERTYUIOPASDFGHJKLZXCVBNM0123456789"))
                    {
                        keys[i] = [ord(keyname)];
                    }
                    break;
            }
            var _key = 0;
            var _key_press = 0;
            var _key_release = 0;
            for (var j = 0; j < array_length(keys[i]); j++)
            {
                if (enabled && !is_keyboard_used_debug_overlay())
                {
                    _key = _key || keyboard_check(keys[i][j]);
                    _key_press = _key_press || keyboard_check_pressed(keys[i][j]);
                    _key_release = _key_release || keyboard_check_released(keys[i][j]);
                }
                else
                {
                    _key = false;
                    _key_press = false;
                    _key_release = false;
                    j = array_length(keys[i]);
                }
            }
            if (_use_any)
            {
                _anykey = _anykey || _key;
                _anykey_press = _anykey_press || _key_press;
                _anykey_release = _anykey_release || _key_release;
            }
            variable_struct_set(self, keyname, _key);
            variable_struct_set(self, keyname + "_press", _key_press);
            variable_struct_set(self, keyname + "_release", _key_release);
        }
        if (_use_any)
        {
            any = _anykey;
            any_press = _anykey_press;
            any_release = _anykey_release;
        }
    }
    with (_input.mouse)
    {
        x = mouse_x;
        y = mouse_y;
        if (enabled && !is_mouse_over_debug_overlay())
        {
            click = mouse_check_button(mb_left);
            click_press = mouse_check_button_pressed(mb_left);
            click_release = mouse_check_button_released(mb_left);
        }
        else
        {
            click = false;
            click_press = false;
            click_release = false;
        }
        if (instance_exists(obj_minigame_controller) && obj_minigame_controller.current_process_mg != -1)
        {
            var mouse_pos_mod = obj_minigame_controller.current_process_mg.screen_h / 270;
            x *= mouse_pos_mod;
            y *= mouse_pos_mod;
        }
    }
    return _input;
}

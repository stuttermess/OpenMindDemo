function gimmick_flip() : gimmick_constructor() constructor
{
    amount = 0;
    rotation = 0;
    zoom = 1;
    start_beat = 0;
    current_beat = 0;
    startrot = 0;
    endrot = 180;
    finish_this = false;
    minigame_tickdown = true;
    minigames_length = 1;
    
    get_start_beat = function()
    {
        if ((obj_minigame_controller.current_beat % 1) > 0.1)
        {
            start_beat = ceil(obj_minigame_controller.current_beat);
        }
        else
        {
            start_beat = floor(obj_minigame_controller.current_beat);
        }
    };
    
    _init = function()
    {
        get_start_beat();
    };
    
    _tick_before = function()
    {
        if (blacklisted_by_minigame)
        {
            _finish();
            exit;
        }
        current_beat = obj_minigame_controller.current_beat - start_beat;
        var rotprog = clamp(current_beat / 2, 0, 1) * (1 - get_blacklist_weight());
        rotation = lerp(startrot, endrot, lerp_easeInOutBack(rotprog));
        zoom = lerp(1, 2.5, abs(dsin(rotation)));
        if (endrot == 360 && rotprog >= 1 && finish_this)
        {
            _finish();
        }
        var amgs = obj_minigame_controller.active_mgs;
        if (array_length(amgs) > 0)
        {
            if (amgs[0].time <= 0 && !minigame_tickdown)
            {
                minigames_length--;
                minigame_tickdown = true;
                if (minigames_length <= 0 && !finish_this)
                {
                    startrot = 180;
                    endrot = 360;
                    get_start_beat();
                    finish_this = true;
                }
            }
        }
        else
        {
            minigame_tickdown = false;
        }
    };
    
    _draw_before = function()
    {
        var x_origin = 240;
        var y_origin = 135;
        var matrix_translate_origin = matrix_build(-x_origin, -y_origin, 0, 0, 0, 0, 1, 1, 1);
        var matrix_rotate_and_scale = matrix_build(0, 0, 0, 0, 0, rotation, zoom, zoom, zoom);
        var matrix_translate_back = matrix_build(x_origin, y_origin, 0, 0, 0, 0, 1, 1, 1);
        var matrix_new_origin = matrix_multiply(matrix_get(2), matrix_translate_origin);
        matrix_new_origin = matrix_multiply(matrix_new_origin, matrix_rotate_and_scale);
        matrix_new_origin = matrix_multiply(matrix_new_origin, matrix_translate_back);
        matrix_set(2, matrix_new_origin);
    };
    
    _draw_after = function()
    {
        var x_origin = 240;
        var y_origin = 135;
        matrix_set(2, matrix_build_identity());
    };
}

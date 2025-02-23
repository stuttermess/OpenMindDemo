function charselect_shuffle() : charselect_character_constructor() constructor
{
    leaderboard_id = "shuffle_endless";
    local_leaderboard_id = "shuffle";
    letterbox_color = 8388736;
    char_sprite = -1;
    allowed_modes = [1];
    character_script = gamechar_shuffle;
    figment_sprites = [spr_charselect_shuffle_figments0, spr_charselect_shuffle_figments1, spr_charselect_shuffle_figments2, spr_charselect_shuffle_figments3, spr_charselect_shuffle_figments3];
    figment_amounts = [4, 5, 8, 8, 12];
    figment_dists = [13, 38, 78, 140, 210];
    ring_speeds = [7, 8, 11, 15, 17];
    figment_frames = [];
    for (var i = 0; i < array_length(figment_sprites); i++)
    {
        var _frames_pool = [];
        var _rots_pool = [];
        repeat (sprite_get_number(figment_sprites[i]))
        {
            array_push(_frames_pool, array_length(_frames_pool));
        }
        figment_frames[i] = [];
        repeat (min(figment_amounts[i], sprite_get_number(figment_sprites[i])))
        {
            var _ind = irandom(array_length(_frames_pool) - 1);
            var _frame = _frames_pool[_ind];
            array_delete(_frames_pool, _ind, 1);
            array_push(figment_frames[i], _frame);
        }
    }
    
    draw_background = function()
    {
        var cx = 170;
        var cy = 135;
        shader_set_wavy(spr_charselect_shuffle_bg, time / 60, 1, 10, 10, 1, 7, 5);
        draw_sprite_ext(spr_charselect_shuffle_bg, 0, cx, cy, 1.1, 1.1, 0, c_white, 1);
        shader_reset();
        draw_sprite_tiled(spr_charselect_shuffle_stars, 0, cx, cy + (time * 0.5));
        ring_tilt_x = 0;
        ring_tilt_y = 0;
        cx -= (ring_tilt_x * 0.5);
        cy -= (ring_tilt_y * 0.5);
        for (var r = 0; r < array_length(figment_dists); r++)
        {
            var _len = figment_dists[r];
            for (var _fig = 0; _fig < figment_amounts[r]; _fig++)
            {
                var _sprite = figment_sprites[r];
                var _frame = figment_frames[r][_fig];
                var _dir = (time / 60) * ring_speeds[r];
                _dir += ((_fig / figment_amounts[r]) * 360);
                var _fx = cx + lengthdir_x(_len, _dir);
                var _fy = cy + lengthdir_y(_len, _dir);
                draw_sprite_ext(_sprite, _frame, _fx, _fy, 1, 1, 1, c_white, 1);
            }
            cx += ring_tilt_x;
            cy += ring_tilt_y;
        }
    };
    
    _draw_character = function(arg0, arg1, arg2)
    {
    };
    
    name = "Shuffle";
    name_sprite = spr_charselect_shuffle_name;
    minigame_count = 18;
    
    on_game_end = function()
    {
        with (obj_minigame_controller)
        {
            char.end_endless_mode();
        }
    };
}

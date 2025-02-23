game_object = -1;
minigame = obj_minigame_controller.current_process_mg;
array_push(minigame.colliders, id);
image_alpha = 0;
image_blend = c_blue;
depth = -100;

_update = function()
{
    var g = game_object;
    x = g.x;
    y = g.y;
    sprite_index = g.sprite_index;
    image_index = g.image_index;
    image_angle = g.image_angle;
    image_xscale = g.image_xscale;
    image_yscale = g.image_yscale;
};

update_object = function()
{
    var g = game_object;
    g.x = x;
    g.y = y;
    g.image_angle = image_angle;
};

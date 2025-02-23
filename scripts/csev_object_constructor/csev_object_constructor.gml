function csev_object_constructor() : csev_base_constructor() constructor
{
    _event_type = 2;
    _cutscene_controller = -1;
    x = 0;
    y = 0;
    depth = 0;
    object_id = -1;
    var_struct = {};
    instance = -1;
    
    _init = function()
    {
        instance = instance_create_depth(x, y, depth, object_id, var_struct);
        variable_instance_set(instance, "controller", self);
    };
    
    _tick = function()
    {
    };
    
    _draw = function()
    {
    };
    
    next_event = function()
    {
        _cutscene_controller.next_event();
    };
}

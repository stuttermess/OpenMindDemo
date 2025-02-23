messages = ["Would you like to adjust some settings before playing?", "All done?"];
msg = messages[0];
options_open = false;
options_menu = new options_menu_constructor();

options_menu.on_exit = function()
{
    with (obj_firstopen_controller)
    {
        instance_destroy();
    }
};

btns = [
{
    text: "Yes",
    
    onclick: function()
    {
        with (obj_firstopen_controller)
        {
            options_open = true;
        }
    },
    
    x: 240,
    y: 165,
    coords: [0, 0, 0, 0]
}, 
{
    text: "No",
    
    onclick: function()
    {
        with (obj_firstopen_controller)
        {
            visible = false;
            alarm[0] = 120;
        }
    },
    
    x: 240,
    y: 200,
    coords: [0, 0, 0, 0]
}];

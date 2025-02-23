function build_control_style(arg0)
{
    if (argument_count > 1)
    {
        var arr = [];
        for (var i = 0; i < argument_count; i++)
        {
            array_push(arr, argument[i]);
        }
        arg0 = arr;
    }
    if (!is_array(arg0))
    {
        arg0 = [arg0];
    }
    var _default_controls = 
    {
        arrows: 
        {
            any: false,
            up: false,
            down: false,
            left: false,
            right: false
        },
        spacebar: false,
        cursor: 
        {
            any: false,
            move: false,
            click: false,
            rclick: false
        },
        keyboard: false,
        special: false
    };
    var _controls = struct_copy(_default_controls);
    var contcount = array_length(arg0);
    for (var i = 0; i < contcount; i++)
    {
        var _valid = false;
        switch (arg0[i])
        {
            case "dup":
            case "ddown":
            case "dleft":
            case "dright":
            case "arrows":
                _controls.arrows.any = true;
                _valid = true;
                break;
            case "cmove":
            case "cclick":
            case "crclick":
            case "cursor":
            case "mouse":
                _controls.cursor.any = true;
                _valid = true;
                break;
            case "keyboard":
                _controls.keyboard = true;
                _valid = true;
                break;
        }
        switch (arg0[i])
        {
            case "arrows":
                _controls.arrows.up = true;
                _controls.arrows.down = true;
                _controls.arrows.left = true;
                _controls.arrows.right = true;
                break;
            case "dup":
                _controls.arrows.up = true;
                break;
            case "ddown":
                _controls.arrows.down = true;
                break;
            case "dleft":
                _controls.arrows.left = true;
                break;
            case "dright":
                _controls.arrows.right = true;
                break;
            case "spacebar":
                _controls.spacebar = true;
                break;
            case "cmove":
                _controls.cursor.move = true;
                break;
            case "cclick":
                _controls.cursor.click = true;
                break;
            case "crclick":
                _controls.cursor.rclick = true;
                break;
            default:
                if (!_valid)
                {
                    _controls.special = arg0[i];
                }
                break;
        }
    }
    return _controls;
}

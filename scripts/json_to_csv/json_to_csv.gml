function json_to_csv(arg0, arg1)
{
    var _tokens = [];
    var _char = 1;
    var _string_assemble_mode = false;
    var _assembled_string = "";
    var escape_char = false;
    var _object = -1;
    var _csv_lines = [];
    while (_char <= string_length(arg0))
    {
        var tokensamt = array_length(_tokens);
        var _charval = string_char_at(arg0, _char);
        if (_string_assemble_mode)
        {
            switch (_charval)
            {
                case "\\":
                    escape_char = !escape_char;
                    if (!escape_char)
                    {
                        _assembled_string += _charval;
                    }
                    break;
                case "\"":
                    if (escape_char)
                    {
                        _assembled_string += _charval;
                    }
                    else
                    {
                        _string_assemble_mode = false;
                        array_push(_tokens, _assembled_string);
                        _assembled_string = "";
                    }
                    escape_char = false;
                    break;
                case "n":
                    if (escape_char)
                    {
                        _assembled_string += ("\\" + _charval);
                    }
                    else
                    {
                        _assembled_string += _charval;
                    }
                    escape_char = false;
                    break;
                case "t":
                    if (escape_char)
                    {
                        _assembled_string += ("\\" + _charval);
                    }
                    else
                    {
                        _assembled_string += _charval;
                    }
                    escape_char = false;
                    break;
                default:
                    _assembled_string += _charval;
                    escape_char = false;
                    break;
            }
        }
        else
        {
            switch (_charval)
            {
                case "{":
                case "}":
                case "[":
                case "]":
                case ":":
                case ",":
                    array_push(_tokens, _charval);
                    break;
                case "\"":
                    _string_assemble_mode = true;
                    _assembled_string = "";
                    break;
            }
        }
        if (array_length(_tokens) > tokensamt)
        {
            var _top = array_length(_tokens) - 1;
            var _token = _tokens[_top];
            switch (_token)
            {
                case "[":
                case "{":
                    var __type;
                    if (_token == "{")
                    {
                        __type = 1;
                    }
                    if (_token == "[")
                    {
                        __type = 2;
                    }
                    if (_object == -1)
                    {
                        _object = new __json2csv_object_constructor(__type, "", -1);
                        _object.suffix = "";
                    }
                    else
                    {
                        var _sep = "";
                        if (_object.parent != -1)
                        {
                            _sep = _object.suffix;
                        }
                        var _pathname = _object.path + _sep + _tokens[_top - 2];
                        if (_object.array_pos >= 0)
                        {
                            _pathname = _object.path + _sep + string(_object.array_pos);
                        }
                        var _newobj = new __json2csv_object_constructor(__type, _pathname, _object);
                        _object = _newobj;
                    }
                    if (__type == 2)
                    {
                        _object.array_pos++;
                    }
                    break;
                case ",":
                    with (_object)
                    {
                        if (type == 2)
                        {
                            array_pos++;
                        }
                    }
                    break;
                case "}":
                case "]":
                    _object.array_pos = -1;
                    _object = _object.parent;
                    array_push(_csv_lines, 
                    {
                        key: "",
                        value: ""
                    });
                    break;
                default:
                    if (_object.array_pos >= 0)
                    {
                        var _val = _token;
                        var _name = _object.path + _object.suffix + string(_object.array_pos);
                        array_push(_csv_lines, 
                        {
                            key: _name,
                            value: _val
                        });
                    }
                    else if (_tokens[_top - 1] == ":")
                    {
                        var _val = _token;
                        var _name = _object.path + _object.suffix + _tokens[_top - 2];
                        array_push(_csv_lines, 
                        {
                            key: _name,
                            value: _val
                        });
                    }
                    else
                    {
                    }
                    break;
            }
        }
        _char++;
    }
    var _csv_file = file_text_open_write(arg1);
    for (var i = 0; i < array_length(_csv_lines); i++)
    {
        var _key = _csv_lines[i].key;
        var _val = _csv_lines[i].value;
        _val = string_replace_all(_val, "\"", "\"\"");
        _val = string_replace_all(_val, "\n", "\\n");
        if (string_pos(",", _val) > 0)
        {
            _val = "\"" + _val + "\"";
        }
        var _csv_str = _key + "," + _val;
        if ((i + 1) < array_length(_csv_lines))
        {
            _csv_str += "\n";
        }
        file_text_write_string(_csv_file, _csv_str);
    }
    file_text_close(_csv_file);
}

function __json2csv_object_constructor(arg0 = 0, arg1 = "", arg2 = -1) constructor
{
    type = arg0;
    suffix = "";
    switch (type)
    {
        case 1:
            suffix = "/";
            break;
        case 2:
            suffix = ".";
            break;
    }
    parent = arg2;
    path = arg1;
    array_pos = -1;
}

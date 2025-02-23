build_type = 2;
version_string = "v1.0.2.4";

get_version_string = function()
{
    var _str = version_string;
    var _build_type_str = "";
    switch (build_type)
    {
        case 0:
            break;
        case 1:
            _build_type_str = "DEVELOPER";
            break;
        case 2:
            _build_type_str = "Demo ";
            break;
        case 3:
            _build_type_str = "Event ";
            break;
    }
    return _build_type_str + _str;
};

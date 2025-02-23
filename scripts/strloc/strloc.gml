function strloc(arg0)
{
    var lang = master.lang;
    var val;
    try
    {
        var path_arr = string_to_struct_path(arg0, "/", ".").path;
        val = get_value_at_struct_path(lang, path_arr);
    }
    catch (lalala)
    {
        return "";
    }
    if (!is_string(val) && !is_array(val))
    {
        val = arg0;
    }
    return val;
}

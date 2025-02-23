function get_value_at_struct_path(arg0, arg1)
{
    if (!is_array(arg1))
    {
        arg1 = string_to_struct_path(arg1).path;
    }
    var val = undefined;
    var struct_check = arg0;
    var path_arr = arg1;
    for (var i = 0; i < (array_length(arg1) + 1); i++)
    {
        if (is_struct(struct_check))
        {
            if (struct_exists(struct_check, path_arr[i]))
            {
                struct_check = struct_get(struct_check, path_arr[i]);
            }
        }
        else if (is_array(struct_check))
        {
            if (array_length(path_arr) > i)
            {
                struct_check = struct_check[real(path_arr[i])];
            }
            else
            {
                val = struct_check;
            }
        }
        else
        {
            val = struct_check;
        }
    }
    return val;
}

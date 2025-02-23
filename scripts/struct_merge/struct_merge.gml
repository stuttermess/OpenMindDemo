function struct_merge(arg0, arg1, arg2 = true, arg3 = true, arg4 = true)
{
    var new_struct = struct_copy(arg0);
    var merge_struct_names = variable_struct_get_names(arg1);
    for (var i = 0; i < array_length(merge_struct_names); i++)
    {
        var var_name = merge_struct_names[i];
        var var_value = variable_struct_get(arg1, var_name);
        var keep_original = false;
        if (arg4)
        {
            var original_value = variable_struct_get(new_struct, var_name);
            if (typeof(var_value) != typeof(original_value))
            {
                keep_original = true;
            }
        }
        if (!keep_original)
        {
            if (is_struct(var_value))
            {
                if (arg2 && variable_struct_exists(new_struct, var_name) && ((variable_struct_exists(arg0, var_name) && is_struct(variable_struct_get(arg0, var_name))) || !variable_struct_exists(arg0, var_name)))
                {
                    variable_struct_set(new_struct, var_name, struct_merge(variable_struct_get(new_struct, var_name), var_value, true, arg3, arg4));
                }
                else
                {
                    variable_struct_set(new_struct, var_name, struct_copy(var_value));
                }
            }
            else if (arg3 || struct_exists(new_struct, var_name))
            {
                variable_struct_set(new_struct, var_name, var_value);
            }
        }
    }
    return new_struct;
}

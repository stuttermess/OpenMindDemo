function struct_copy(arg0)
{
    var new_struct = {};
    var merge_struct_names = variable_struct_get_names(arg0);
    for (var i = 0; i < array_length(merge_struct_names); i++)
    {
        var var_name = merge_struct_names[i];
        var var_value = variable_struct_get(arg0, var_name);
        if (is_struct(var_value))
        {
            var_value = struct_copy(var_value);
        }
        if (is_array(var_value))
        {
            var arr = [];
            array_copy(arr, 0, var_value, 0, array_length(var_value));
            var_value = arr;
        }
        variable_struct_set(new_struct, var_name, var_value);
    }
    return new_struct;
}

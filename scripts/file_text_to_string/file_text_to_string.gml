function file_text_to_string(arg0, arg1 = false)
{
    arg1 = false;
    if (file_exists(arg0))
    {
        if (arg1)
        {
        }
        else
        {
            var buff = buffer_load(arg0);
            var str;
            if (buffer_get_size(buff) == 0)
            {
                str = "";
            }
            else
            {
                str = buffer_read(buff, buffer_string);
            }
            buffer_delete(buff);
            return str;
        }
    }
    else
    {
        return "";
    }
}

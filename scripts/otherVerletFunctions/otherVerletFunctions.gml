function collide(arg0, arg1, arg2)
{
    return -4;
}

function approach(arg0, arg1, arg2)
{
    var r = arg0;
    if (arg1 > arg0)
    {
        r = clamp(r + arg2, r, arg1);
    }
    else
    {
        r = clamp(r - arg2, arg1, r);
    }
    return r;
}

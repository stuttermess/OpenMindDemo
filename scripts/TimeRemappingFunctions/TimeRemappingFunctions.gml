function lerp_easeOut(arg0)
{
    return sqrt(1 - power(arg0 - 1, 2));
}

function lerp_easeOutSine(arg0)
{
    return sin((arg0 * pi) / 2);
}

function lerp_easeOutQuint(arg0)
{
    return 1 - power(1 - arg0, 5);
}

function lerp_easeOutCubic(arg0)
{
    return 1 - power(1 - arg0, 3);
}

function lerp_easeOutQuart(arg0)
{
    return 1 - power(1 - arg0, 4);
}

function lerp_easeOutQuad(arg0)
{
    return 1 - ((1 - arg0) * (1 - arg0));
}

function lerp_easeOutCirc(arg0)
{
    return sqrt(1 - power(arg0 - 1, 2));
}

function lerp_easeOutElastic(arg0)
{
    var c4 = 2.0943951023931953;
    return (power(2, -10 * arg0) * sin(((arg0 * 10) - 0.75) * c4)) + 1;
}

function lerp_easeIn(arg0)
{
    return arg0 * arg0 * arg0 * arg0;
}

function lerp_easeInOut(arg0)
{
    if (arg0 < 0.5)
    {
        return 16 * arg0 * arg0 * arg0 * arg0 * arg0;
    }
    else
    {
        return 1 - (power((-2 * arg0) + 2, 5) / 2);
    }
}

function lerp_easeInOutSine(arg0)
{
    return -(cos(pi * arg0) - 1) / 2;
}

function lerp_easeInOutCubic(arg0)
{
    if (arg0 < 0.5)
    {
        return 4 * arg0 * arg0 * arg0;
    }
    else
    {
        return 1 - (power((-2 * arg0) + 2, 3) / 2);
    }
}

function lerp_easeOutBounce(arg0)
{
    var n1 = 7.5625;
    var d1 = 2.75;
    if (arg0 < (1 / d1))
    {
        return n1 * arg0 * arg0;
    }
    else if (arg0 < (2 / d1))
    {
        arg0 -= (1.5 / d1);
        return (n1 * arg0 * arg0) + 0.75;
    }
    else if (arg0 < (2.5 / d1))
    {
        arg0 -= (2.25 / d1);
        return (n1 * arg0 * arg0) + 0.9375;
    }
    else
    {
        arg0 -= (2.625 / d1);
        return (n1 * arg0 * arg0) + 0.984375;
    }
}

function lerp_easeInBack(arg0)
{
    var c1 = 1.70158;
    var c3 = c1 + 1;
    return (c3 * arg0 * arg0 * arg0) - (c1 * arg0 * arg0);
}

function lerp_easeOutBack(arg0)
{
    return 1 + (2.70158 * power(arg0 - 1, 3)) + (1.70158 * power(arg0 - 1, 2));
}

function lerp_easeInOutBack(arg0)
{
    var c1 = 1.70158;
    var c2 = c1 * 1.525;
    var _ret = 0;
    if (arg0 < 0.5)
    {
        _ret = (power(2 * arg0, 2) * (((c2 + 1) * 2 * arg0) - c2)) / 2;
    }
    else
    {
        _ret = ((power((2 * arg0) - 2, 2) * (((c2 + 1) * ((arg0 * 2) - 2)) + c2)) + 2) / 2;
    }
    return _ret;
}

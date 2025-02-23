if ((time % 10) == 0)
{
    xmod = irandom_range(-2, 2);
    ymod = irandom_range(-2, 2);
}
var _tt = image_alpha;
var _dxs = abs(lerp(0, 1, lerp_easeInOutBack(_tt)));
var _dys = lerp(1.3, 1, lerp_easeInOutBack(_tt)) * clamp(_tt / 0.25, 0, 1);
image_xscale = _dxs;
image_yscale = _dys;
time++;

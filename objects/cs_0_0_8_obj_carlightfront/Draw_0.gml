var bmon = true;
if (bmon)
{
    blendmode_set_addglow();
}
draw_self();
if (bmon)
{
    blendmode_reset();
}

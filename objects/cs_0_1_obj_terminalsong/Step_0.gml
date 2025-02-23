if (!instance_exists(cutscene))
{
    instance_destroy();
}
if (t > 0)
{
    t--;
    if (t == 0)
    {
        instance_destroy();
    }
}

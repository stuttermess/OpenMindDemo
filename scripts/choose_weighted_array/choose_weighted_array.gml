function choose_weighted_array(arg0)
{
    var item_n = 0;
    var items_count = array_length(arg0);
    var items = array_create(items_count);
    var cmf = array_create(items_count);
    var total = 0;
    var i = 0;
    repeat (items_count)
    {
        items[item_n] = item_n;
        total += arg0[item_n];
        cmf[item_n] = total;
        item_n++;
    }
    var rand = random(total);
    for (var j = 0; j < items_count; j++)
    {
        if (rand < cmf[j])
        {
            return items[j];
        }
    }
    return items[items_count - 1];
}

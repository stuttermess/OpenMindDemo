function start_transition(arg0, arg1 = -1)
{
    var inst = instance_create_depth(0, 0, 0, transition_controller);
    inst.intro_script = arg0;
    inst.outro_script = arg1;
    inst.start();
    return inst;
}

function start_transition_perlin(arg0, arg1 = true)
{
    var _outro = transition_perlin;
    if (!arg1)
    {
        _outro = -1;
    }
    var _tr = start_transition(transition_perlin, _outro);
    if (arg1)
    {
        _tr.outro.reverse = true;
    }
    _tr.on_intro_end = arg0;
    return _tr;
}

function lb0_diagops_abbie()
{
    var _options = [];
    var _folder = "0/lobby/abbie/";
    var _all_options = ["bear", "tournament", "plushies", "experience", "bye"];
    for (var i = 0; i < array_length(_all_options); i++)
    {
        var _op = _all_options[i];
        var _flag = get_story_flag("_0.abbie." + _op, 0);
        if (_op == "bye")
        {
            _flag = 1;
        }
        var _q_str = "dialogue/" + _folder + "questions/" + _op;
        var _q_str_loc = strloc(_q_str);
        if (_flag == 1)
        {
            array_push(_options, [_q_str_loc, 1, _folder + _op]);
        }
    }
    return _options;
}

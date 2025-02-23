function draw_local_highscores(arg0, arg1, arg2, arg3)
{
    var _scores_array = struct_get(master.endless_scores, arg2);
    _scores_array = struct_get(_scores_array, arg3);
    draw_quick_score_list(arg0, arg1, _scores_array);
}

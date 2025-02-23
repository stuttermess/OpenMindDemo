function local_endless_scores_load(arg0 = master.current_profile)
{
    var scores_filepath = game_save_id + arg0 + "/highscor.es";
    var _load_buf = buffer_load(scores_filepath);
    var _scores = local_endless_scores_from_buffer(_load_buf);
    if (buffer_exists(_load_buf))
    {
        buffer_delete(_load_buf);
    }
    return _scores;
}

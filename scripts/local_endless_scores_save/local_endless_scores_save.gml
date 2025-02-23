function local_endless_scores_save(arg0 = master.current_profile)
{
    var scores_filepath = game_save_id + arg0 + "/highscor.es";
    var _scores_save_buffer = local_endless_scores_to_buffer(master.endless_scores);
    buffer_save(_scores_save_buffer, scores_filepath);
    buffer_delete(_scores_save_buffer);
}

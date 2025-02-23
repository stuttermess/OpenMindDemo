function gamechar_future() : gamechar_constructor() constructor
{
    name = "Future";
    available_minigames = [mg_fClock, mg_fYume, mg_fTug, mg_fStrum];
    game_end_round = array_length(available_minigames);
}

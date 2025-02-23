function cs_0_4_mindselect() : cutscene_constructor() constructor
{
    events[0] = new csev_sequence_constructor();
    events[0].sequence_id = sqcs_0_4_bossend;
    events[1] = new csev_sequence_constructor();
    events[1].sequence_id = sqcs_0_4_from_mindselect;
}

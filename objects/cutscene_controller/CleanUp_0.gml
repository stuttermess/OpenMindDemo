if (cutscene != -1 && cutscene.current_event != -1 && cutscene.current_event._event_type == 0)
{
    with (cutscene.current_event)
    {
        layer_sequence_destroy(sequence);
        layer_destroy(sequence_layer);
    }
}

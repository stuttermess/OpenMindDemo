function game_set_pause(arg0)
{
    with (obj_minigame_controller)
    {
        if (game_active)
        {
            if (arg0 == paused)
            {
                return undefined;
            }
            paused = arg0;
            if (paused)
            {
                audio_pause_sound(tempo_track);
                if (is_array(game_music))
                {
                    for (var i = 0; i < array_length(game_music); i++)
                    {
                        audio_pause_sound(game_music[i]);
                    }
                }
                else
                {
                    audio_pause_sound(game_music);
                }
                for (var i = 0; i < array_length(jingles); i++)
                {
                    audio_pause_sound(jingles[i].sound_inst);
                }
                for (var i = 0; i < array_length(sfx_pause_array); i++)
                {
                    audio_pause_sound(sfx_pause_array[i]);
                }
                if (array_length(active_mgs) > 0)
                {
                    audio_pause_sound(active_mgs[0].bgm);
                }
                array_push(play_stats.pauses, 
                {
                    paused_at: play_stats.playtime_seconds,
                    length: 0
                });
                pause_menu.open();
                video_pause();
            }
            else
            {
                audio_resume_sound(tempo_track);
                if (is_array(game_music))
                {
                    for (var i = 0; i < array_length(game_music); i++)
                    {
                        audio_resume_sound(game_music[i]);
                    }
                }
                else
                {
                    audio_resume_sound(game_music);
                }
                for (var i = 0; i < array_length(jingles); i++)
                {
                    audio_resume_sound(jingles[i].sound_inst);
                }
                for (var i = 0; i < array_length(sfx_pause_array); i++)
                {
                    audio_resume_sound(sfx_pause_array[i]);
                }
                if (array_length(active_mgs) > 0)
                {
                    audio_resume_sound(active_mgs[0].bgm);
                }
                video_resume();
            }
        }
    }
}

function game_get_pause()
{
    with (obj_minigame_controller)
    {
        return paused;
    }
}

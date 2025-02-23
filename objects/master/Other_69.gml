var _type = ds_map_find_value(async_load, "event_type");
switch (_type)
{
    case "avatar_image_loaded":
        if (ds_map_find_value(async_load, "success"))
        {
            var _uid = ds_map_find_value(async_load, "user_id");
            var _img = ds_map_find_value(async_load, "image");
            save_steam_avatar(_img, _uid);
        }
        break;
    case "leaderboard_upload":
        var _lb_ID = ds_map_find_value(async_load, "post_id");
        var _lb_name = ds_map_find_value(async_load, "lb_name");
        var _lb_done = ds_map_find_value(async_load, "success");
        var _lb_score = ds_map_find_value(async_load, "score");
        var _lb_updated = ds_map_find_value(async_load, "updated");
        show_debug_message("leaderboard post ID:" + string(_lb_ID) + " to lb:" + string(_lb_name) + " with score:" + string(_lb_score) + " updated=" + string(_lb_updated));
        if (_lb_done)
        {
            show_debug_message("- Succeeded");
        }
        else
        {
            show_debug_message("- Failed");
        }
        break;
    case "leaderboard_download":
        var _req_ID = ds_map_find_value(async_load, "post_id");
        var lb_name = ds_map_find_value(async_load, "lb_name");
        show_debug_message(ds_map_find_value(async_load, "entries"));
        var _response = json_parse(ds_map_find_value(async_load, "entries"));
        var lb_entries = _response.entries;
        var lb_struct;
        if (struct_exists(leaderboards, lb_name))
        {
            lb_struct = struct_get(leaderboards, lb_name);
        }
        else
        {
            lb_struct = new leaderboard_constructor(lb_name);
            struct_set(leaderboards, lb_name, lb_struct);
        }
        lb_struct.list = lb_entries;
        var firstrank = infinity;
        var lastrank = -infinity;
        for (var i = 0; i < array_length(lb_entries); i++)
        {
            var _entry = lb_entries[i];
            if (i > 0 && abs(_entry.rank - lb_entries[i - 1].rank) > 1)
            {
                _entry.rank = lb_entries[i - 1].rank + 1;
            }
            firstrank = min(firstrank, _entry.rank);
            lastrank = min(lastrank, _entry.rank);
            var _uid = _entry.userID;
            var img = steam_get_user_avatar(_uid, 0);
            if (img > 0)
            {
                show_debug_message("Avatar for ID " + string(_uid) + " auto saved.");
                save_steam_avatar(img, _uid);
            }
            else if (img < 0)
            {
                show_debug_message("Avatar for ID " + string(_uid) + " queued to save.");
            }
            else
            {
                show_debug_message("Avatar for ID " + string(_uid) + " unable to save.");
            }
        }
        var doreset = true;
        if (leaderboard_request_struct != -1)
        {
            with (leaderboard_request_struct)
            {
                self_on_page = false;
                loading_scores = false;
                var steamid = steam_get_user_steam_id();
                if (tabs[tab] == "global")
                {
                    if (getting_list_around_self)
                    {
                        if (array_length(lb_entries) == 0)
                        {
                            master.leaderboard_request = -1;
                            doreset = false;
                            first_rank = 1;
                            last_rank = (first_rank + per_page) - 1;
                            request_list();
                            global_has_next_page = false;
                        }
                        else
                        {
                            var myindex = -1;
                            for (var i = 0; i < array_length(lb_entries) && myindex == -1; i++)
                            {
                                var _entry = lb_entries[i];
                                if (_entry.userID == steamid)
                                {
                                    myindex = i;
                                }
                            }
                            if (myindex == -1)
                            {
                                show_message("what");
                            }
                            else
                            {
                                var myentry = lb_entries[myindex];
                                var myrank = myentry.rank;
                                var mypage = floor((myrank - 1) / per_page) + 1;
                                var _firstrank = ((mypage - 1) * per_page) + 1;
                                var _lastrank = (_firstrank + per_page) - 1;
                                var ind_start_rank = lb_entries[0].rank;
                                var ind_end_rank = lb_entries[array_length(lb_entries) - 1].rank;
                                array_delete(lb_entries, 0, _firstrank - ind_start_rank);
                                array_delete(lb_entries, array_length(lb_entries) - (ind_end_rank - _lastrank), ind_end_rank - _lastrank);
                                global_has_next_page = bool(abs(ind_end_rank - _lastrank));
                                first_rank = lb_entries[0].rank;
                            }
                            self_on_page = true;
                            get_list_around_self();
                        }
                    }
                    else
                    {
                        global_has_next_page = array_length(lb_entries) > per_page;
                    }
                    if (global_has_next_page)
                    {
                        array_delete(lb_entries, per_page, array_length(lb_entries) - per_page);
                    }
                    getting_list_around_self = false;
                }
                if (array_length(lb_entries) > 0)
                {
                    last_rank = lb_entries[array_length(lb_entries) - 1].rank;
                    for (var i = 0; i < array_length(lb_entries) && !self_on_page; i++)
                    {
                        self_on_page = lb_entries[i].userID == steamid;
                    }
                }
            }
        }
        if (doreset)
        {
            leaderboard_request = -1;
            leaderboard_request_struct = -1;
        }
        break;
}

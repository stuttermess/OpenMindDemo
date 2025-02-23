function leaderboard_constructor(arg0) constructor
{
    name = arg0;
    list = [];
}

function leaderboard_menu_constructor(arg0, arg1 = "", arg2 = "default") constructor
{
    leaderboard_name = arg0;
    local_leaderboard_name = arg1;
    local_leaderboard_preset = arg2;
    tab = 2;
    if (!os_is_network_connected(false) || !steam_initialised())
    {
        tab = 0;
    }
    tabs = ["local", "global", "friends"];
    str_loading_scores = strloc("menus/leaderboard/text_loading_scores");
    str_no_connection = strloc("menus/leaderboard/text_no_connection");
    str_local_no_scores = strloc("menus/leaderboard/text_local_no_scores");
    str_drm_free = strloc("menus/leaderboard/text_drm_free");
    online_enabled = steam_initialised();
    loading_scores = false;
    getting_list_around_self = false;
    leaderboard_display_name = "";
    close_str = strloc("menus/leaderboard/close_button");
    close_btn = [0, 0, 0, 0];
    
    close_func = function()
    {
    };
    
    self_on_page = false;
    global_has_next_page = false;
    
    request_list = function(arg0 = tabs[tab])
    {
        if (master.leaderboard_request == -1)
        {
            if (online_enabled && os_is_network_connected(false))
            {
                switch (tabs[tab])
                {
                    case "friends":
                        friends_save_scroll = scroll;
                        break;
                    case "global":
                        global_save_first = first_rank;
                        global_save_last = last_rank;
                        global_save_scroll = scroll;
                        break;
                }
                switch (arg0)
                {
                    case "friends":
                        master.leaderboard_request = steam_download_friends_scores(leaderboard_name);
                        scroll = friends_save_scroll;
                        break;
                    case "global":
                        first_rank = global_save_first;
                        last_rank = global_save_last;
                        scroll = global_save_scroll;
                        master.leaderboard_request = steam_download_scores(leaderboard_name, first_rank, last_rank + 1);
                        break;
                }
                master.leaderboard_tab = arg0;
                master.leaderboard_request_struct = self;
                get_leaderboard().list = [];
                loading_scores = true;
            }
            tab = array_get_index(tabs, arg0);
            free_steam_avatars();
            return true;
        }
        return false;
    };
    
    get_list_top = function()
    {
        if (master.leaderboard_request == -1 && online_enabled)
        {
            switch (tabs[tab])
            {
                case "global":
                    if (first_rank == 1)
                    {
                        scrollbar.scroll = 0;
                    }
                    else
                    {
                        first_rank = 1;
                        last_rank = (first_rank + per_page) - 1;
                        request_list();
                    }
                    break;
                case "friends":
                    scrollbar.scroll = 0;
                    break;
            }
            return true;
        }
        return false;
    };
    
    get_list_around_self = function()
    {
        if (master.leaderboard_request == -1 && online_enabled)
        {
            var justscroll = false;
            switch (tabs[tab])
            {
                case "global":
                    if (self_on_page)
                    {
                        justscroll = true;
                    }
                    else
                    {
                        master.leaderboard_request = steam_download_scores_around_user(leaderboard_name, -per_page, per_page);
                        master.leaderboard_request_struct = self;
                        getting_list_around_self = true;
                        get_leaderboard().list = [];
                        loading_scores = true;
                        free_steam_avatars();
                    }
                    break;
                case "friends":
                    justscroll = true;
                    break;
            }
            if (justscroll)
            {
                var _list = get_leaderboard().list;
                var _scrolljump = -1;
                var _steamid = steam_get_user_steam_id();
                for (var i = 0; i < array_length(_list) && _scrolljump == -1; i++)
                {
                    var _entry = _list[i];
                    if (_entry.userID == _steamid)
                    {
                        _scrolljump = i;
                    }
                }
                if (_scrolljump != -1)
                {
                    scrollbar.scroll = _scrolljump;
                }
            }
            return true;
        }
        return false;
    };
    
    per_page = 25;
    first_rank = 1;
    last_rank = (first_rank + per_page) - 1;
    global_save_first = first_rank;
    global_save_last = last_rank;
    global_save_scroll = 0;
    friends_save_scroll = 0;
    prev_list_length = 0;
    list = [];
    scroll = 0;
    max_scroll = per_page - 1;
    width = 218;
    height = 265;
    x = 240 - (width / 2);
    y = 135 - (height / 2);
    margin_x = 5;
    margin_y = 5;
    top_space = 16;
    bottom_space = 29;
    list_x = margin_x;
    list_y = margin_y;
    list_sf_x = 0;
    list_sf_y = 0;
    list_sf_width = 1;
    list_sf_height = 1;
    list_container_x = margin_x;
    list_container_y = margin_y;
    list_container_width = 1;
    list_container_height = 1;
    list_content_height = 1;
    use_scrollbar = false;
    tab_btns = [];
    page_btns = [[], []];
    char_btns = [[], []];
    rank_btns = [[], []];
    hover = false;
    closed = false;
    score_entry_height = 36;
    onscreen_entries = 0;
    scrollbar = new scrollbar_constructor();
    scrollbar.bar_height = 30;
    scrollbar.container_x = 0;
    scrollbar.container_y = 0;
    scrollbar.container_height = -1;
    scrollbar.container_width = 14;
    scrollbar.bar_sprite = spr_leaderboard_scrollbar;
    scrollbar.container_sprite = spr_leaderboard_scrollbar_container;
    text_rendered = false;
    list_text_sf = -1;
    list_sf = -1;
    text_render_info = [];
    
    render_text = function()
    {
        verify_surface();
        var _halign = draw_get_halign();
        var _valign = draw_get_valign();
        surface_set_target(list_text_sf);
        draw_clear_alpha(c_white, 0);
        for (var i = 0; i < array_length(text_render_info); i++)
        {
            var _t = text_render_info[i];
            draw_set_halign(_t.halign);
            draw_set_valign(_t.valign);
            if (_t.mask == -1)
            {
                draw_text_special(_t.x, _t.y, _t.str, _t.effects);
            }
            else
            {
            }
        }
        surface_reset_target();
        draw_set_halign(_halign);
        draw_set_valign(_valign);
        text_render_info = [];
        text_rendered = true;
    };
    
    queue_render_text = function(arg0, arg1, arg2, arg3 = {}, arg4 = -1)
    {
        if (!text_rendered)
        {
            var _halign = draw_get_halign();
            var _valign = draw_get_valign();
            array_push(text_render_info, 
            {
                x: arg0,
                y: arg1,
                str: arg2,
                effects: arg3,
                mask: arg4,
                halign: _halign,
                valign: _valign
            });
        }
    };
    
    change_page = function(arg0)
    {
        if (tabs[tab] == "global")
        {
            arg0 = sign(arg0);
            var _diff = 0;
            _diff += (per_page * ((arg0 == 1) * global_has_next_page));
            _diff -= (per_page * ((arg0 == -1) * (first_rank > 1)));
            if (_diff != 0)
            {
                var _pagenum = floor((first_rank - 1) / per_page) + 1;
                first_rank = ((_pagenum - 1) * per_page) + 1;
                first_rank += _diff;
                first_rank = max(first_rank, 1);
                last_rank = (first_rank + per_page) - 1;
                request_list();
            }
        }
    };
    
    _tick = function()
    {
        if (closed)
        {
            exit;
        }
        hover = false;
        var _btn = close_btn;
        if (array_length(_btn) >= 4)
        {
            if (point_in_rectangle(mouse_x, mouse_y, _btn[0], _btn[1], _btn[2], _btn[3]))
            {
                hover = true;
                if (get_input_click())
                {
                    sfx_play(snd_menu_back);
                    closed = true;
                    close_func();
                    exit;
                }
            }
        }
        for (var i = 0; i < array_length(tab_btns) && !loading_scores; i++)
        {
            _btn = tab_btns[i];
            if (array_length(_btn) >= 4)
            {
                if (point_in_rectangle(mouse_x, mouse_y, _btn[0], _btn[1], _btn[2], _btn[3]) && tab != i)
                {
                    hover = true;
                    if (get_input_click())
                    {
                        sfx_play(snd_menu_click_minor);
                        switch (tabs[i])
                        {
                            case "global":
                            case "friends":
                                request_list(tabs[i]);
                                break;
                            case "local":
                                tab = 0;
                                free_steam_avatars();
                                break;
                        }
                    }
                }
            }
        }
        for (var i = 0; i < array_length(page_btns) && !loading_scores; i++)
        {
            _btn = page_btns[i];
            if (array_length(_btn) >= 4)
            {
                if (point_in_rectangle(mouse_x, mouse_y, _btn[0], _btn[1], _btn[2], _btn[3]))
                {
                    hover = true;
                    if (get_input_click())
                    {
                        change_page((i * 2) - 1);
                        sfx_play(snd_menu_click_minor);
                    }
                }
            }
        }
        if (instance_exists(obj_charselect_menu) && !loading_scores)
        {
            for (var i = 0; i < array_length(char_btns); i++)
            {
                _btn = char_btns[i];
                if (array_length(_btn) >= 4)
                {
                    if (point_in_rectangle(mouse_x, mouse_y, _btn[0], _btn[1], _btn[2], _btn[3]))
                    {
                        hover = true;
                        if (get_input_click())
                        {
                            sfx_play(snd_menu_click_minor);
                            var _dir = -1;
                            if (i == 0)
                            {
                                _dir = 1;
                            }
                            var switched;
                            with (obj_charselect_menu)
                            {
                                var startcharnum = character_num;
                                switched = false;
                                i = character_num + 1;
                                while (i != startcharnum && character_num == startcharnum)
                                {
                                    i = i % array_length(characters);
                                    var testchar = new characters[i]();
                                    if (testchar.leaderboard_id != -1)
                                    {
                                        switch_selected_character(i);
                                        do_transition_anim(_dir);
                                        switched = true;
                                    }
                                    i++;
                                }
                            }
                            if (switched)
                            {
                                leaderboard_name = obj_charselect_menu.character.get_steam_leaderboard_name();
                                local_leaderboard_name = obj_charselect_menu.character.local_leaderboard_id;
                                first_rank = 1;
                                last_rank = (first_rank + per_page) - 1;
                                global_save_first = first_rank;
                                global_save_last = last_rank;
                                global_save_scroll = 0;
                                friends_save_scroll = 0;
                                prev_list_length = 0;
                                if (tabs[tab] != "local")
                                {
                                    request_list();
                                }
                                surface_free(list_text_sf);
                                surface_free(list_sf);
                            }
                        }
                    }
                }
            }
        }
        for (var i = 0; i < array_length(rank_btns) && !loading_scores; i++)
        {
            _btn = rank_btns[i];
            if (array_length(_btn) >= 4)
            {
                if (point_in_rectangle(mouse_x, mouse_y, _btn[0], _btn[1], _btn[2], _btn[3]))
                {
                    hover = true;
                    if (get_input_click())
                    {
                        sfx_play(snd_menu_click_minor);
                        if (i == 0)
                        {
                            get_list_around_self();
                        }
                        else
                        {
                            get_list_top();
                        }
                    }
                }
            }
        }
        list = get_leaderboard().list;
        if (array_length(list) != prev_list_length)
        {
            prev_list_length = array_length(list);
            text_rendered = false;
            text_render_info = [];
        }
        list_x = margin_x;
        list_y = margin_y + top_space;
        list_container_x = list_x;
        list_container_y = list_y;
        if (!loading_scores && array_length(list) > 0)
        {
            max_scroll = array_length(list);
        }
        scrollbar.x = x;
        scrollbar.y = y;
        scrollbar.container_x = round(width - margin_x - scrollbar.container_width);
        scrollbar.max_scroll = max_scroll;
        list_container_width = width - (margin_x * 2);
        list_container_height = height - (margin_y * 2) - (list_y - margin_y) - bottom_space;
        list_sf_width = scrollbar.container_x - list_x;
        list_sf_height = height - (margin_y * 2) - (list_y - margin_y) - bottom_space;
        list_sf_width = max(list_sf_width, 1);
        list_sf_height = max(list_sf_height, 1);
        scrollbar.container_height = list_container_height - 4;
        scrollbar.container_y = (list_container_y + (list_container_height / 2)) - (scrollbar.container_height / 2);
        scrollbar.scrollbar_offset = -1;
        var row_height = score_entry_height;
        var _entries_amount = min(array_length(list), max_scroll);
        var total_height = _entries_amount * row_height;
        onscreen_entries = list_sf_height / row_height;
        var _entries_per_row = onscreen_entries;
        use_scrollbar = total_height > list_sf_height;
        if (use_scrollbar)
        {
            scrollbar.tick();
            scroll = scrollbar.scroll;
            list_sf_width += 1;
        }
        else
        {
            scrollbar.scroll = 0;
            list_sf_width += scrollbar.container_width;
        }
        list_content_height = score_entry_height * max(array_length(list), 1);
        verify_surface();
    };
    
    _draw = function()
    {
        verify_surface();
        var frame_spr_width = sprite_get_width(spr_leaderboard_frame);
        var frame_spr_height = sprite_get_height(spr_leaderboard_frame);
        var frame_spr_xscale = width / frame_spr_width;
        var frame_spr_yscale = height / frame_spr_height;
        draw_sprite_ext(spr_leaderboard_frame, 0, x, y, frame_spr_xscale, frame_spr_yscale, 0, c_white, 1);
        var _fnt = draw_get_font();
        tab_btns = [];
        var btx = (x + margin_x) - 1;
        var bty = (y + margin_y) - 1;
        for (var i = 0; i < array_length(tabs); i++)
        {
            var bt_spr = asset_get_index("spr_leaderboard_tabbtn_" + tabs[i]);
            var btw = sprite_get_width(bt_spr);
            var bth = sprite_get_height(bt_spr);
            tab_btns[i] = [btx, bty, (btx + btw) - 1, (bty + bth) - 1];
            draw_sprite(bt_spr, tab == i, btx, bty);
            btx += (btw + 2);
        }
        var _sc = spr_leaderboard_scores_container;
        var _sc_x = (x + list_container_x) - 1;
        var _sc_y = (y + list_container_y) - 1;
        var _sc_xscale = (list_container_width + 2) / sprite_get_width(_sc);
        var _sc_yscale = (list_container_height + 2) / sprite_get_height(_sc);
        draw_sprite_ext(_sc, 0, _sc_x, _sc_y, _sc_xscale, _sc_yscale, 0, c_white, 1);
        switch (tabs[tab])
        {
            case "global":
            case "friends":
                if (online_enabled)
                {
                    if (loading_scores || !os_is_network_connected(false))
                    {
                        var _str = str_loading_scores;
                        if (!os_is_network_connected(false))
                        {
                            _str = str_no_connection;
                        }
                        draw_set_halign(fa_center);
                        draw_set_valign(fa_middle);
                        draw_set_color(c_black);
                        draw_text(x + (width / 2), y + (height / 2), string_to_wrapped(_str, width * 0.5, "\n"));
                        draw_set_halign(fa_left);
                        draw_set_valign(fa_top);
                        draw_set_color(c_white);
                        use_scrollbar = false;
                    }
                    else
                    {
                        surface_set_target(list_sf);
                        draw_clear_alpha(c_white, 0);
                        draw_set_color(c_black);
                        var row_height = score_entry_height;
                        var _entries_amount = min(array_length(list), max_scroll);
                        var total_height = _entries_amount * row_height;
                        var _entries_per_row = onscreen_entries;
                        var scroll_base_y = lerp(1, -(total_height - (row_height * _entries_per_row)) - 1, scroll / max_scroll);
                        draw_set_valign(fa_middle);
                        var _first_rank = 0;
                        var _rank_offset;
                        if (_entries_amount > 0)
                        {
                            _first_rank = list[0].rank;
                            _rank_offset = 0;
                            if (tabs[tab] == "friends")
                            {
                                _rank_offset = -(_first_rank - 1);
                            }
                        }
                        for (var i = 0; i < array_length(list); i++)
                        {
                            var _entry = list[i];
                            var _name = _entry.name;
                            var _score = _entry.score;
                            var _rank = _entry.rank + _rank_offset;
                            var _uid = _entry.userID;
                            var rank_col = 0;
                            var rank_outcol = 16777215;
                            var name_col = 0;
                            var name_outcol = 16777215;
                            var score_col = 0;
                            var score_outcol = 16777215;
                            var is_me = false;
                            if (_uid == steam_get_user_steam_id())
                            {
                                is_me = true;
                                rank_col = 16777215;
                                rank_outcol = 0;
                                name_col = 16777215;
                                name_outcol = 0;
                                score_col = 16777215;
                                score_outcol = 0;
                            }
                            var _spr = struct_get(master.steam_avatars, _uid);
                            var dy = round(scroll_base_y + (row_height / 2) + (row_height * i));
                            if (dy > -row_height)
                            {
                                var dx = 0;
                                var _score_container_sprite = spr_leaderboard_score_container;
                                var _scs_x = dx;
                                var _scs_y = dy - (row_height / 2);
                                var _scs_w = list_sf_width;
                                var _scs_h = score_entry_height;
                                var _scs_xs = _scs_w / sprite_get_width(_score_container_sprite);
                                var _scs_ys = _scs_h / sprite_get_height(_score_container_sprite);
                                var _scs_frame = 0;
                                if (_rank <= 3)
                                {
                                    _scs_frame = _rank;
                                }
                                draw_sprite_ext(spr_leaderboard_score_container, _scs_frame, _scs_x, _scs_y, _scs_xs, _scs_ys, 0, c_white, 1);
                                dx += 2;
                                var _sp_txt_args = 
                                {
                                    splitfill: 
                                    {
                                        top_color: 5324101,
                                        bottom_color: 0
                                    },
                                    shadow: 
                                    {
                                        color: 16766176
                                    }
                                };
                                switch (_rank)
                                {
                                    case 1:
                                        _sp_txt_args.shadow.color = 11992063;
                                        break;
                                    case 2:
                                        _sp_txt_args.shadow.color = 16774122;
                                        break;
                                    case 3:
                                        break;
                                }
                                if (is_me)
                                {
                                    with (_sp_txt_args)
                                    {
                                        splitfill = 
                                        {
                                            top_color: 16777215,
                                            bottom_color: 13216208
                                        };
                                        outline = 
                                        {
                                            width: 1,
                                            color: 0
                                        };
                                    }
                                }
                                var rankstr = "#" + string(_rank);
                                draw_set_color(rank_col);
                                queue_render_text(dx, dy - scroll_base_y, rankstr, _sp_txt_args);
                                dx += 4;
                                dx += (string_length(rankstr) * 7);
                                if (is_undefined(_spr))
                                {
                                    dx += 26;
                                }
                                else
                                {
                                    var _avatar_size = sprite_get_width(_spr);
                                    if (!is_undefined(_spr))
                                    {
                                        dx += (_avatar_size / 2);
                                        draw_sprite(_spr, 0, dx, dy);
                                        draw_set_color(c_black);
                                        draw_rectangle(dx - (_avatar_size / 2), round(dy - (_avatar_size / 2)), (dx + (_avatar_size / 2)) - 1, round((dy + (_avatar_size / 2)) - 1), true);
                                        draw_set_color(c_white);
                                        dx += (_avatar_size / 2);
                                    }
                                }
                                var namesep = 5;
                                dx += (namesep + 1);
                                var name_xback = 3;
                                if (!text_rendered)
                                {
                                    var max_width = max(1, list_sf_width - dx - string_width(string(_score)) - namesep - 3);
                                    if (string_width(_name) > max_width)
                                    {
                                        _name += "...";
                                        while (string_width(_name) > max_width)
                                        {
                                            _name = string_delete(_name, string_length(_name) - 3, 1);
                                        }
                                    }
                                    queue_render_text(dx, dy - scroll_base_y, _name, _sp_txt_args);
                                }
                                draw_set_halign(fa_right);
                                draw_set_color(score_col);
                                queue_render_text(list_sf_width - 3, dy - scroll_base_y, string(_score), _sp_txt_args);
                                draw_set_halign(fa_left);
                            }
                        }
                        draw_set_color(c_black);
                        draw_set_valign(fa_top);
                        draw_set_halign(fa_left);
                        if (!text_rendered)
                        {
                            render_text();
                        }
                        draw_surface(list_text_sf, 0, round(scroll_base_y));
                        surface_reset_target();
                        draw_surface(list_sf, x + list_x, y + list_y);
                        draw_set_color(c_white);
                        if (use_scrollbar)
                        {
                            draw_set_color(c_black);
                            scrollbar.draw();
                            draw_set_color(c_white);
                        }
                    }
                    draw_set_font(fnt_dialogue);
                    if (tabs[tab] == "global")
                    {
                        var page_str = strloc("menus/leaderboard/page_number");
                        var page_num = floor((first_rank - 1) / per_page) + 1;
                        page_str = string_replace(page_str, "#", string(page_num));
                        draw_text_special(x + 6, (y + height) - 30, page_str, 
                        {
                            shadow: 
                            {
                                color: 0
                            }
                        });
                        page_btns = [[-1, -1, -1, -1], [-1, -1, -1, -1]];
                        var pgbtns_y = (y + height) - 16;
                        draw_sprite(spr_leaderboard_pagebtn_prev, lerp(1, 0, page_num > 1), x + 5, pgbtns_y);
                        if (page_num > 1)
                        {
                            page_btns[0] = [x + 5, pgbtns_y, x + 5 + sprite_get_width(spr_leaderboard_pagebtn_prev), pgbtns_y + sprite_get_height(spr_leaderboard_pagebtn_prev)];
                        }
                        draw_sprite(spr_leaderboard_pagebtn_next, lerp(1, 0, global_has_next_page), x + 5 + 26, pgbtns_y);
                        if (global_has_next_page)
                        {
                            page_btns[1] = [x + 5 + 26, pgbtns_y, x + 5 + 26 + sprite_get_width(spr_leaderboard_pagebtn_next), pgbtns_y + sprite_get_height(spr_leaderboard_pagebtn_next)];
                        }
                    }
                    else
                    {
                        page_btns = [[-1, -1, -1, -1], [-1, -1, -1, -1]];
                    }
                    draw_set_font(fnt_pixel);
                }
                else
                {
                    draw_set_halign(fa_center);
                    draw_set_valign(fa_middle);
                    draw_text(x + (width / 2), y + (height / 2), string_to_wrapped(str_drm_free, width * 0.5, "\n"));
                    draw_set_halign(fa_left);
                    draw_set_valign(fa_top);
                }
                break;
            case "local":
                use_scrollbar = false;
                var _scores = struct_get(master.endless_scores, local_leaderboard_name);
                if (!is_undefined(_scores))
                {
                    _scores = struct_get(_scores, local_leaderboard_preset);
                }
                if (is_undefined(_scores) || (is_array(_scores) && array_length(_scores) == 0))
                {
                    var _str = string_to_wrapped(str_local_no_scores, width * 0.75, "\n");
                    draw_set_halign(fa_center);
                    draw_set_valign(fa_middle);
                    draw_text(x + (width / 2), y + (height / 2), _str);
                    draw_set_halign(fa_left);
                    draw_set_valign(fa_top);
                }
                else
                {
                    draw_local_highscores(x + (width / 2), y + (height / 2), local_leaderboard_name, local_leaderboard_preset);
                }
                break;
        }
        rank_btns = [[-1, -1, -1, -1], [-1, -1, -1, -1]];
        if (tabs[tab] != "local")
        {
            var dx = (x + width) - 27;
            var dy = (y + height) - 31;
            draw_sprite(spr_leaderboard_selfbtn, 0, dx, dy);
            rank_btns[0] = [dx, dy, (dx + sprite_get_width(spr_leaderboard_selfbtn)) - 1, (dy + sprite_get_height(spr_leaderboard_selfbtn)) - 1];
            dy += 15;
            draw_sprite(spr_leaderboard_topbtn, 0, dx, dy);
            rank_btns[1] = [dx, dy, (dx + sprite_get_width(spr_leaderboard_topbtn)) - 1, (dy + sprite_get_height(spr_leaderboard_topbtn)) - 1];
        }
        char_btns = [[-1, -1, -1, -1], [-1, -1, -1, -1]];
        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        var char_x = ceil(x + (width / 2));
        var char_y = ceil((y + height) - 19);
        var _charname = leaderboard_display_name;
        draw_text_special(char_x, char_y, _charname, 
        {
            shadow: {}
        });
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        if (instance_exists(obj_charselect_menu))
        {
            var _wid = string_width(_charname);
            _wid = 50;
            var btnx = ceil(char_x + (_wid / 2) + 2);
            var btny = ceil(char_y);
            var arspr = spr_leaderboard_chararrow;
            draw_sprite_ext(arspr, 0, btnx, btny, 1, 1, 0, c_white, 1);
            char_btns[0] = [btnx, btny - sprite_get_yoffset(arspr), btnx + sprite_get_width(arspr), (btny - sprite_get_yoffset(arspr)) + sprite_get_height(arspr)];
            btnx = floor(char_x - (_wid / 2) - 3);
            draw_sprite_ext(arspr, 0, btnx, btny, -1, 1, 0, c_white, 1);
            char_btns[1] = [btnx - sprite_get_width(arspr), btny - sprite_get_yoffset(arspr), btnx, (btny - sprite_get_yoffset(arspr)) + sprite_get_height(arspr)];
        }
        var cbtx = (x + width) - margin_x - 14;
        var cbty = (y + margin_y) - 2;
        var cbth = sprite_get_height(spr_leaderboard_closebtn);
        var cbtw = sprite_get_width(spr_leaderboard_closebtn);
        close_btn = [cbtx, cbty, cbtx + cbtw, cbty + cbth];
        draw_sprite(spr_leaderboard_closebtn, 0, cbtx, cbty);
        draw_set_font(_fnt);
    };
    
    verify_surface = function()
    {
        if (!surface_exists(list_sf))
        {
            list_sf = surface_create(list_sf_width, list_sf_height);
        }
        if (surface_get_width(list_sf) != list_sf_width || surface_get_height(list_sf) != list_sf_height)
        {
            surface_resize(list_sf, list_sf_width, list_sf_height);
        }
        if (!surface_exists(list_text_sf))
        {
            list_text_sf = surface_create(list_sf_width, list_content_height);
            text_rendered = false;
        }
        if (surface_get_width(list_text_sf) != list_sf_width || surface_get_height(list_text_sf) != list_content_height)
        {
            surface_resize(list_text_sf, list_sf_width, list_content_height);
            text_rendered = false;
        }
    };
    
    get_leaderboard = function()
    {
        var _struct = -1;
        if (struct_exists(master.leaderboards, leaderboard_name))
        {
            _struct = struct_get(master.leaderboards, leaderboard_name);
        }
        else
        {
            _struct = new leaderboard_constructor(leaderboard_name);
            struct_set(master.leaderboards, leaderboard_name, _struct);
        }
        steam_create_leaderboard(leaderboard_name, lb_sort_descending, lb_disp_numeric);
        return _struct;
    };
    
    set_scrollbar_pos = function(arg0)
    {
        var sb_y = scrollbar_container_y + lerp(scrollbar_height / 2, scrollbar_container_height - (scrollbar_height / 2), arg0 / max_scroll);
        scrollbar_y = sb_y;
        sbc[0] = x + scrollbar_container_x + 2;
        sbc[1] = ((y + sb_y) - (scrollbar_height / 2)) + 1 + 2;
        sbc[2] = (x + scrollbar_container_x + scrollbar_container_width) - 2;
        sbc[3] = (y + sb_y + (scrollbar_height / 2)) - 2;
    };
    
    free_steam_avatars = function()
    {
        with (master)
        {
            var _avatars = struct_get_names(steam_avatars);
            for (var i = 0; i < array_length(_avatars); i++)
            {
                sprite_delete(struct_get(steam_avatars, _avatars[i]));
                struct_remove(steam_avatars, _avatars[i]);
            }
        }
    };
    
    free = function()
    {
        if (surface_exists(list_sf))
        {
            surface_free(list_sf);
        }
        if (surface_exists(list_text_sf))
        {
            surface_free(list_text_sf);
        }
        free_steam_avatars();
    };
}

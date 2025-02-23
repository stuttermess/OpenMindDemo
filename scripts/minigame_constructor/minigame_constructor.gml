function minigame_constructor() constructor
{
	var _prev_current_process_mg = -1;
	
	if (instance_exists(obj_minigame_controller))
	{
		_prev_current_process_mg = obj_minigame_controller.current_process_mg;
		obj_minigame_controller.current_process_mg = self;
	}
	
	name = "";
	prompt = "";
	prompt_y_offset = 0;
	use_prompt = true;
	use_timer = true;
	timer_script = -1;
	time_limit = 8;
	show_timer_at = 8;
	early_finish = true;
	efin_skip_amount = 4;
	measure_length = 4;
	snap_efin_to_measure = true;
	win_on_timeover = false;
	music = -1;
	music_bpm = 128;
	music_loops = false;
	music_ignore_bpm = false;
	control_style = 0;
	screen_w = 480;
	screen_h = 270;
	gimmick_blacklist = [];
	max_difficulty = 2;
	
	choose_difficulty = function()
	{
		var _times_played = get_minigame_times_played();
		
		switch (_times_played)
		{
			default:
				var _highest_difficulty = get_minigame_highest_difficulty_seen();
				var _diff = 0;
				var lowest_diff = 0;
				var highest_diff = min(_highest_difficulty + 1, _times_played, max_difficulty);
				var _diffs = [];
				var _weights = [];
				
				for (var i = 0; i <= (highest_diff - lowest_diff); i++)
				{
					var __diff = i + lowest_diff;
					var __weight = (__diff * 0.5) + (1000 / (get_minigame_times_difficulty_seen(__diff) + 1));
					array_push(_diffs, __diff);
					array_push(_weights, __weight);
				}
				
				_diff = _diffs[choose_weighted_array(_weights)];
				show_debug_message("difficulties: " + string(_diffs));
				show_debug_message("weights: " + string(_weights));
				show_debug_message("Difficulty: " + string(_diff));
				return _diff;
				break;
		}
	};
	
	metascript_init = metascript_blank;
	metascript_start = metascript_blank;
	metascript_tick_before = metascript_blank;
	metascript_tick_after = metascript_blank;
	metascript_draw_before = metascript_blank;
	metascript_draw_after = metascript_blank;
	metascript_cleanup = metascript_blank;
	
	after_queued = function()
	{
	};
	
	beat_start = 0;
	beat_current = 0;
	beat_end = 0;
	bgm = -1;
	_controller = -1;
	difficulty = 0;
	time = time_limit;
	meta_obj = -1;
	defined_objects = {};
	object_scripts = {};
	
	_init = function()
	{
		beatskip = 0;
		frames_active = 0;
		time = time_limit;
		beat_end = beat_start + time_limit;
		objs_arr = [];
		objs = {};
		objs_draw_order = [];
		colliders = [];
		objids = 0;
		success_state = 0;
		colliders = [];
		instance_destroy(obj_collider);
		
		for (var i = 0; i < array_length(gimmick_blacklist); i++)
		{
			if (is_string(gimmick_blacklist[i]) && script_exists(gimmick_blacklist[i]))
				gimmick_blacklist[i] = script_get_name(gimmick_blacklist[i]);
		}
		
		var minigame_interoperate_structs = obj_minigame_controller.minigame_interoperate_structs;
		var minigame_script = instanceof(self);
		
		if (!struct_exists(minigame_interoperate_structs, minigame_script))
			struct_set(minigame_interoperate_structs, minigame_script, {});
		
		difficulty = choose_difficulty();
		
		if (difficulty < 0)
			difficulty = _controller.choose_minigame_difficulty();
		
		define_object("meta", 
		{
			init: metascript_init,
			start: metascript_start,
			tick_before: metascript_tick_before,
			tick_after: metascript_tick_after,
			draw_before: metascript_draw_before,
			draw_after: metascript_draw_after,
			cleanup: metascript_cleanup
		});
		meta_obj = create_object("meta", {}, false);
		
		with (meta_obj)
			perform_event("init");
		
		cam2d_create();
	};
	
	_start = function()
	{
		if (music != -1 && audio_exists(music) && obj_minigame_controller.use_minigame_music)
		{
			var muspitch;
			
			if (music_ignore_bpm)
				muspitch = 1;
			else
				muspitch = (obj_minigame_controller.base_bpm * obj_minigame_controller.music_pitch) / music_bpm;
			
			var _offset = 0;
			bgm = audio_play_sound_on(master.emit_mus, music, music_loops, 10, 1, _offset, muspitch);
		}
		
		with (meta_obj)
			perform_event("start");
		
		var must_update_draw_order = false;
		
		for (var i = 0; i < array_length(objs_arr); i++)
		{
			var thisobj = objs_arr[i];
			
			if (thisobj != -1)
			{
				with (thisobj)
				{
					var depthbefore = thisobj.depth;
					perform_event("start");
					
					if (thisobj.depth != depthbefore)
						must_update_draw_order = true;
				}
			}
		}
		
		if (must_update_draw_order)
			update_draw_order();
	};
	
	_tick = function()
	{
		if (early_finish && success_state != 0)
		{
			if (beatskip == 0 && time > efin_skip_amount)
				beatskip = ceil(time) - efin_skip_amount;
		}
		
		if (use_timer)
			beat_end = (beat_start + time_limit) - beatskip;
		
		if (time <= 0 && (use_timer || success_state != 0) && obj_minigame_controller.inbetween_timer <= 0)
		{
			if (success_state == 0)
			{
				if (win_on_timeover)
					game_win(true);
				else
					game_lose(true);
			}
			
			var suc = success_state;
			var cnt = _controller;
			var win_game = false;
			var lose_game = false;
			
			if (cnt._lives <= 0)
				lose_game = true;
			else if (!obj_minigame_controller.endless_mode && ((cnt._round + 1) >= cnt.game_end_round && suc == 1))
				win_game = true;
			
			cnt.end_game = win_game || lose_game;
			var end_game = cnt.end_game;
			
			if (((cnt.next_round_on_lose && ((cnt.round_was_boss && suc == 1) || !cnt.round_was_boss)) || suc == 1) && cnt._lives > 0)
				cnt._round += 1;
			
			cnt.round_was_boss = false;
			
			with (obj_minigame_controller)
			{
				if (end_game)
				{
					cnt._end_game();
					combo_mode = false;
				}
				
				if (instance_exists(obj_minigame_controller))
				{
					gimmick_event("_on_minigame_over");
					return_to_inbetween(suc);
				}
			}
			
			if (bgm != -1)
			{
				audio_stop_sound(bgm);
				bgm = -1;
			}
			
			exit;
		}
		
		var _input = get_input();
		
		with (meta_obj)
			perform_event("tick_before");
		
		var must_update_draw_order = false;
		
		for (var i = 0; i < array_length(objs_arr); i++)
		{
			var thisobj = objs_arr[i];
			
			if (thisobj != -1)
			{
				with (thisobj)
				{
					if (sprite_exists(sprite_index))
					{
						switch (sprite_get_speed_type(sprite_index))
						{
							case 0:
								image_index += ((sprite_get_speed(sprite_index) / room_speed) * image_speed);
								break;
							case 1:
								image_index += (sprite_get_speed(sprite_index) * image_speed);
								break;
						}
						
						image_index %= sprite_get_number(sprite_index);
					}
					
					var depthbefore = thisobj.depth;
					perform_event("tick");
					
					if (thisobj.depth != depthbefore)
						must_update_draw_order = true;
				}
			}
		}
		
		if (must_update_draw_order)
			update_draw_order();
		
		with (meta_obj)
			perform_event("tick_after");
		
		if (use_timer)
			time = time_limit - (beat_current - beat_start) - beatskip;
		else if (success_state == 0)
			time = efin_skip_amount + 1;
		else
			time = efin_skip_amount - (beat_current - beat_end);
		
		frames_active++;
	};
	
	_draw = function()
	{
		cam2d_drawstart();
		
		with (meta_obj)
			perform_event("draw_before");
		
		for (var i = 0; i < array_length(objs_draw_order); i++)
		{
			var thisobjid = objs_draw_order[i];
			var thisobj = variable_struct_get(objs, thisobjid);
			
			if (is_struct(thisobj))
			{
				with (thisobj)
				{
					if (visible)
						perform_event("draw");
				}
			}
		}
		
		with (meta_obj)
			perform_event("draw_after");
		
		cam2d_drawend();
	};
	
	_cleanup = function()
	{
		with (meta_obj)
			perform_event("cleanup");
		
		for (var i = 0; i < array_length(objs_arr); i++)
		{
			var thisobj = objs_arr[i];
			
			if (thisobj != -1)
			{
				with (thisobj)
					perform_event("cleanup");
			}
		}
		
		colliders = [];
		instance_destroy(obj_collider);
		video_close();
		
		if (bgm != -1)
		{
			audio_stop_sound(bgm);
			bgm = -1;
		}
	};
	
	if (_prev_current_process_mg != -1)
		obj_minigame_controller.current_process_mg = _prev_current_process_mg;
}

function metascript_blank()
{
}

function _draw_self()
{
	if (sprite_exists(sprite_index))
		draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, image_alpha);
}

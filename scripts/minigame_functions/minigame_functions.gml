function get_meta_object()
{
	with (obj_minigame_controller.current_process_mg)
		return meta_obj;
}

function get_win_state()
{
	with (obj_minigame_controller.current_process_mg)
		return success_state;
}

function get_game_speed()
{
	with (obj_minigame_controller)
		return music_pitch;
}

function get_game_difficulty()
{
	if (!instance_exists(obj_minigame_controller))
		return 0;
	
	if (is_struct(obj_minigame_controller.current_process_mg))
	{
		with (obj_minigame_controller.current_process_mg)
			return difficulty;
	}
}

function get_minigame_interoperate_struct(argument0 = -1)
{
	if (argument0 == -1)
	{
		if (is_struct(self))
			argument0 = self;
		else if (obj_minigame_controller.current_process_mg != -1)
			argument0 = obj_minigame_controller.current_process_mg;
		else
			return undefined;
	}
	
	if (is_struct(argument0))
		argument0 = instanceof(argument0);
	
	if (script_exists(argument0))
		argument0 = script_get_name(argument0);
	
	var minigame_interoperate_structs = obj_minigame_controller.minigame_interoperate_structs;
	return struct_get(minigame_interoperate_structs, argument0);
}

function get_minigame_times_played(argument0 = -1)
{
	var _played = 0;
	
	if (argument0 == -1 && is_struct(self))
		argument0 = obj_minigame_controller.current_process_mg;
	
	if (is_struct(argument0))
		argument0 = instanceof(argument0);
	
	var scriptname = -1;
	
	if (is_string(argument0) && asset_get_index(argument0) != -1)
		scriptname = argument0;
	else if (script_exists(argument0))
		scriptname = script_get_name(argument0);
	
	if (scriptname == -1)
		return 0;
	
	var _played_mgs = obj_minigame_controller.play_stats.played_minigames;
	
	if (struct_exists(_played_mgs, scriptname))
		_played = struct_get(_played_mgs, scriptname);
	
	return _played;
}

function get_minigame_highest_difficulty_seen(argument0 = -1)
{
	var _highest_difficulty = 0;
	
	if (argument0 == -1 && is_struct(self))
		argument0 = obj_minigame_controller.current_process_mg;
	
	if (is_struct(argument0))
		argument0 = instanceof(argument0);
	
	var scriptname = -1;
	
	if (is_string(argument0) && asset_get_index(argument0) != -1)
		scriptname = argument0;
	else if (script_exists(argument0))
		scriptname = script_get_name(argument0);
	
	if (scriptname == -1)
		return 0;
	
	var _mg_difficulties = obj_minigame_controller.minigame_highest_difficulties;
	
	if (struct_exists(_mg_difficulties, scriptname))
		_highest_difficulty = struct_get(_mg_difficulties, scriptname);
	
	return _highest_difficulty;
}

function get_minigame_times_difficulty_seen(argument0, argument1 = -1)
{
	var _highest_difficulty = 0;
	
	if (argument1 == -1 && is_struct(self))
		argument1 = obj_minigame_controller.current_process_mg;
	
	if (is_struct(argument1))
		argument1 = instanceof(argument1);
	
	var scriptname = -1;
	
	if (is_string(argument1) && asset_get_index(argument1) != -1)
		scriptname = argument1;
	else if (script_exists(argument1))
		scriptname = script_get_name(argument1);
	
	if (scriptname == -1)
		return 0;
	
	var _times_seen = 0;
	var _mg_difficulties = obj_minigame_controller.minigame_difficulties_times_seen;
	
	if (struct_exists(_mg_difficulties, scriptname))
	{
		var _difficulties_seen = struct_get(_mg_difficulties, scriptname);
		
		if (struct_exists(_difficulties_seen, argument0))
		{
			_times_seen = struct_get(_difficulties_seen, argument0);
		}
		else
		{
			struct_set(_difficulties_seen, argument0, 0);
			_times_seen = 0;
		}
	}
	else
	{
		struct_set(_mg_difficulties, scriptname, {});
	}
	
	return _times_seen;
}

function get_game_lives()
{
	with (obj_minigame_controller)
		return char._lives;
}

function get_current_frame()
{
	with (obj_minigame_controller.current_process_mg)
		return frames_active;
}

function get_time_limit()
{
	with (obj_minigame_controller.current_process_mg)
		return time_limit;
}

function get_time()
{
	with (obj_minigame_controller.current_process_mg)
		return time;
}

function get_key_ghosting_compensation()
{
	return master.settings.key_ghosting_compensation;
}

function get_screen_width()
{
	if (instance_exists(obj_minigame_controller))
	{
		if (obj_minigame_controller.current_process_mg == -1)
		{
			return 480;
		}
		else
		{
			with (obj_minigame_controller.current_process_mg)
				return screen_w;
		}
	}
	else
	{
		return 480;
	}
}

function get_screen_height()
{
	if (instance_exists(obj_minigame_controller))
	{
		if (obj_minigame_controller.current_process_mg == -1)
		{
			return 270;
		}
		else
		{
			with (obj_minigame_controller.current_process_mg)
				return screen_h;
		}
	}
	else
	{
		return 270;
	}
}

function define_object(argument0, argument1 = {}, argument2 = {})
{
	if (struct_exists(defined_objects, argument0))
		exit;
	
	var _scripts;
	
	if (argument0 == "meta")
	{
		_scripts = 
		{
			init: metascript_blank,
			start: metascript_blank,
			tick_before: metascript_blank,
			tick_after: metascript_blank,
			draw_before: metascript_blank,
			draw_after: metascript_blank,
			cleanup: metascript_blank
		};
	}
	else
	{
		_scripts = 
		{
			init: metascript_blank,
			start: metascript_blank,
			tick: metascript_blank,
			draw: _draw_self,
			cleanup: metascript_blank
		};
	}
	
	var scriptnames = struct_get_names(_scripts);
	
	for (var i = 0; i < array_length(scriptnames); i++)
	{
		var _scriptname = scriptnames[i];
		
		if (struct_exists(argument1, _scriptname))
			struct_set(_scripts, _scriptname, struct_get(argument1, _scriptname));
	}
	
	var newobj = new mgobject();
	var varnames = struct_get_names(argument2);
	
	for (var i = 0; i < array_length(varnames); i++)
	{
		var _varname = varnames[i];
		var _varvalue = struct_get(argument2, _varname);
		struct_set(newobj, _varname, _varvalue);
	}
	
	struct_set(newobj, "object_name", argument0);
	struct_set(defined_objects, argument0, newobj);
	struct_set(object_scripts, argument0, _scripts);
}

function perform_event(argument0, argument1 = object_name)
{
	var event_script;
	
	with (obj_minigame_controller)
	{
		if (!is_struct(current_process_mg))
		{
			event_script = undefined;
		}
		else
		{
			var object_events = struct_get(current_process_mg.object_scripts, argument1);
			event_script = struct_get(object_events, argument0);
		}
	}
	
	if (is_undefined(event_script))
	{
	}
	else
	{
		return event_script();
	}
}

function set_object_collision(argument0, argument1)
{
}

function create_collision_instance()
{
	var _inst = instance_create_depth(x, y, depth, obj_collider);
	_inst.game_object = self;
	_inst._update();
	return _inst;
}

function destroy_collision_instance(argument0)
{
	instance_destroy(argument0);
}

function update_collision(argument0)
{
	argument0._update();
}

function move_and_slide(argument0, argument1, argument2)
{
	var insts = [];
	
	with (argument0)
	{
		_update();
		insts = move_and_collide(argument1, argument2, -3);
		update_object();
	}
	
	for (var i = 0; i < array_length(insts); i++)
		insts[i] = insts[i].game_object;
}

function game_win(argument0 = false)
{
	with (obj_minigame_controller.current_process_mg)
	{
		if (success_state == 0 && (time > 0 || argument0))
		{
			beat_end = beat_current;
			success_state = 1;
			var snd = obj_minigame_controller.char.choose_win_sound();
			
			if (snd != -1)
			{
				var _pitch = 1;
				var _snd_bpm = obj_minigame_controller.char.win_lose_sound_bpm;
				
				if (_snd_bpm > 0)
				{
					var _game_bpm = obj_minigame_controller.base_bpm * get_game_speed();
					_pitch = _game_bpm / _snd_bpm;
				}
				
				obj_minigame_controller.sfx_add_to_mg_end = false;
				var _snd = sfx_play(snd, false, 1, 0, _pitch);
				obj_minigame_controller.sfx_add_to_mg_end = true;
			}
		}
	}
}

function game_lose(argument0 = false)
{
	with (obj_minigame_controller.current_process_mg)
	{
		if (success_state == 0 && (time > 0 || argument0))
		{
			beat_end = beat_current;
			success_state = -1;
			var snd = obj_minigame_controller.char.choose_lose_sound();
			
			if (snd != -1)
			{
				var _pitch = 1;
				var _snd_bpm = obj_minigame_controller.char.win_lose_sound_bpm;
				
				if (_snd_bpm > 0)
				{
					var _game_bpm = obj_minigame_controller.base_bpm * get_game_speed();
					_pitch = _game_bpm / _snd_bpm;
				}
				
				obj_minigame_controller.sfx_add_to_mg_end = false;
				var _snd = sfx_play(snd, false, 1, 0, _pitch);
				obj_minigame_controller.sfx_add_to_mg_end = true;
			}
			
			_controller._lives--;
			var mgname = name + " (" + prompt + ") " + script_get_name(metascript_init);
			var gmspd = get_game_speed();
			var loss = 
			{
				minigame: mgname,
				time: obj_minigame_controller.play_stats.playtime_seconds,
				_round: _controller._round,
				game_speed: gmspd
			};
			array_push(obj_minigame_controller.play_stats.lost_minigames, loss);
		}
	}
}

function create_object(argument0, argument1 = {}, argument2 = true)
{
	with (obj_minigame_controller.current_process_mg)
	{
		if (!struct_exists(self, "defined_objects"))
			defined_objects = {};
		
		bbbbbbbbbbb = struct_get(defined_objects, argument0);
		var newobjb = json_parse(json_stringify(bbbbbbbbbbb));
		array_push(objs_arr, newobjb);
		var chosen_objid = objids;
		objids++;
		variable_struct_set(objs, chosen_objid, newobjb);
		newobjb.game = self;
		
		if (argument2)
		{
			with (newobjb)
				perform_event("init");
		}
		
		var vars = variable_struct_get_names(argument1);
		
		for (var i = 0; i < array_length(vars); i++)
		{
			var thisvar = vars[i];
			variable_struct_set(newobjb, thisvar, variable_struct_get(argument1, thisvar));
		}
		
		newobjb._id = chosen_objid;
		variable_struct_set(newobjb, "id", chosen_objid);
		array_insert(objs_draw_order, 0, chosen_objid);
		update_draw_order();
		return newobjb;
	}
}

function destroy_object(argument0 = self)
{
	if (argument0.object_name == "meta")
		exit;
	
	with (obj_minigame_controller.current_process_mg)
	{
		var objid = 0;
		
		if (is_struct(argument0))
			objid = argument0._id;
		else if (is_real(argument0))
			objid = argument0;
		
		if (objid <= (array_length(objs_arr) - 1) && objs_arr[objid] != -1)
		{
			var inst = objs_arr[objid];
			
			with (inst)
				perform_event("cleanup");
			
			objs_arr[objid] = -1;
			variable_struct_remove(objs, objid);
			array_delete(objs_draw_order, array_get_index(objs_draw_order, objid), 1);
			update_draw_order();
		}
	}
}

function inst_from_id(argument0)
{
	with (obj_minigame_controller.current_process_mg)
		return variable_struct_get(objs, argument0);
}

function update_draw_order()
{
	with (obj_minigame_controller.current_process_mg)
	{
		var _depthsortfunc = function(argument0, argument1)
		{
			var ob1 = variable_struct_get(objs, argument0);
			var ob2 = variable_struct_get(objs, argument1);
			
			if (is_undefined(ob1) || is_undefined(ob2))
				return 0;
			
			return ob2.depth - ob1.depth;
		};
		
		array_sort(objs_draw_order, _depthsortfunc);
	}
}

function display_prompt()
{
	obj_minigame_controller.prompt_time = 0;
}

function gimmick_is_active(argument0)
{
	if (instance_exists(obj_minigame_controller))
	{
		with (obj_minigame_controller)
		{
			argument0 = script_get_name(argument0);
			
			for (var i = 0; i < array_length(gimmicks); i++)
			{
				if (instanceof(gimmicks[i]) == argument0)
					return i + 1;
			}
		}
	}
	
	return false;
}

function draw_minigame_surface(argument0, argument1, argument2 = 1, argument3 = 1, argument4 = 0)
{
	if (instance_exists(obj_minigame_controller))
	{
		with (obj_minigame_controller)
		{
			if (!surface_exists(mg_container_surface))
				exit;
			
			if (is_undefined(argument0))
			{
				var mgsf_scale = 1;
				
				if (inbetween_timer <= minigame_intro_length)
				{
					mgsf_scale = lerp(0, 1, clamp((minigame_intro_length - inbetween_timer) / minigame_intro_length, 0, 1));
				}
				else if (array_length(active_mgs) > 0)
				{
					if (active_mgs[0].time < 0)
						mgsf_scale = lerp(1, 0, clamp(active_mgs[0].time / -minigame_outro_length, 0, 1));
					else if (obj_minigame_controller.inbetween_type != 3)
						mgsf_scale = 1;
				}
				else
				{
					mgsf_scale = 0;
				}
				
				argument2 = mgsf_scale;
				argument3 = mgsf_scale;
				argument4 = 0;
				argument0 = 240;
				argument1 = 135;
			}
			
			argument0 += (lengthdir_x(-240 * argument2, argument4) + lengthdir_x(-135 * argument3, -90 + argument4));
			argument1 += (lengthdir_y(-240 * argument2, argument4) + lengthdir_y(-135 * argument3, -90 + argument4));
			gpu_set_blendenable(false);
			draw_surface_ext(mg_container_surface, argument0, argument1, argument2, argument3, argument4, c_white, 1);
			gpu_set_blendenable(true);
		}
	}
}

function smf_model_preload_obj(argument0)
{
	if (instance_exists(obj_minigame_controller))
	{
		with (obj_minigame_controller)
		{
			if (preloading)
				struct_set(preloads.smf_obj, argument0, -1);
		}
	}
}

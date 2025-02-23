function verletSystem(argument0, argument1) constructor
{
	verletGroups = ds_list_create();
	forceFields = ds_list_create();
	frict = 0;
	grav = 0;
	
	if (argument0 != undefined)
		frict = argument0;
	
	if (argument1 != undefined)
		grav = argument1;
	
	active = true;
	visible = true;
	
	simulate = function()
	{
		if (active)
		{
			var verletGroupAmount = ds_list_size(verletGroups);
			
			for (var i = 0; i < verletGroupAmount; i++)
			{
				var currentGroup = ds_list_find_value(verletGroups, i);
				
				if (currentGroup.active)
					currentGroup.simulate(frict, grav);
			}
		}
	};
	
	addForceField = function(argument0, argument1, argument2, argument3, argument4, argument5, argument6)
	{
		ds_list_add(forceFields, new forceField(argument0, argument1, argument2, argument3, argument4, argument5, argument6));
	};
	
	draw = function()
	{
		if (visible)
		{
			var verletGroupAmount = ds_list_size(verletGroups);
			
			for (var i = 0; i < verletGroupAmount; i++)
			{
				var currentGroup = ds_list_find_value(verletGroups, i);
				
				if (currentGroup.visible)
					currentGroup.draw();
			}
		}
	};
	
	drawDebug = function()
	{
		var verletGroupAmount = ds_list_size(verletGroups);
		
		for (var i = 0; i < verletGroupAmount; i++)
		{
			var currentGroup = ds_list_find_value(verletGroups, i);
			
			if (currentGroup.visible)
				currentGroup.drawWireframe();
		}
		
		var forceFieldAmount = ds_list_size(forceFields);
		
		for (var i = 0; i < forceFieldAmount; i++)
		{
			var currentForceField = ds_list_find_value(forceFields, i);
			draw_rectangle(currentForceField.x1, currentForceField.y1, currentForceField.x2, currentForceField.y2, true);
			var cx = currentForceField.x1 + ((currentForceField.x2 - currentForceField.x1) * 0.5);
			var cy = currentForceField.y1 + ((currentForceField.y2 - currentForceField.y1) * 0.5);
			var len = 10;
			var s = 4;
			draw_arrow(cx + lengthdir_x(len, currentForceField.dir + 180), cy + lengthdir_y(len, currentForceField.dir + 180), cx + lengthdir_x(len, currentForceField.dir), cy + lengthdir_y(len, currentForceField.dir), s);
		}
	};
	
	cleanup = function()
	{
		if (!ds_list_empty(verletGroups))
		{
			repeat (ds_list_size(verletGroups))
			{
				var currentGroup = ds_list_find_value(verletGroups, 0);
				
				if (verletGroupExists(currentGroup))
				{
					currentGroup.cleanup();
					ds_list_set(verletGroups, 0, undefined);
				}
				
				ds_list_delete(verletGroups, 0);
			}
		}
		
		if (ds_exists(verletGroups, ds_type_list))
			ds_list_destroy(verletGroups);
		
		if (ds_exists(forceFields, ds_type_list))
			ds_list_destroy(forceFields);
	};
}

function verletSystemExists(argument0)
{
	return is_struct(argument0);
}

function verletGroup() constructor
{
	active = true;
	visible = true;
	type = undefined;
	stiffness = 1;
	maxTension = 10;
	aliveCounter = 0;
	spawnRipDelaySeconds = 2;
	system = -4;
	vertexList = ds_list_create();
	stickList = ds_list_create();
	attachmentList = ds_list_create();
	
	vertexAdd = function(argument0, argument1, argument2, argument3)
	{
		ds_list_add(vertexList, new vertex(argument0, argument1, argument2, argument3));
	};
	
	vertexChangeData = function(argument0, argument1, argument2, argument3, argument4)
	{
		if (argument0 == -4)
			argument0 = 0;
		else if (argument0 == -3)
			argument0 = ds_list_size(vertexList) - 1;
		
		var thisVertex = ds_list_find_value(vertexList, argument0);
		
		if (argument1 != undefined)
			thisVertex.x = argument1;
		
		if (argument2 != undefined)
			thisVertex.y = argument2;
		
		if (argument3 != undefined)
			thisVertex.radius = argument3;
		
		if (argument4 != undefined)
			thisVertex.fixed = argument4;
	};
	
	vertexAttachObject = function(argument0, argument1, argument2, argument3, argument4)
	{
		if (argument0 == -4)
			argument0 = 0;
		else if (argument0 == -3)
			argument0 = ds_list_size(vertexList) - 1;
		
		if (argument3 == undefined)
			argument3 = 0;
		
		if (argument4 == undefined)
			argument4 = 0;
		
		ds_list_add(attachmentList, new attachment(argument0, argument1, argument2, 0, argument3, argument4));
	};
	
	vertexAttachTo = function(argument0, argument1, argument2, argument3)
	{
		if (argument0 == -4)
			argument0 = 0;
		else if (argument0 == -3)
			argument0 = ds_list_size(vertexList) - 1;
		
		if (argument2 == undefined)
			argument2 = 0;
		
		if (argument3 == undefined)
			argument3 = 0;
		
		ds_list_add(attachmentList, new attachment(argument0, argument1, 0, 1, argument2, argument3));
	};
	
	stickAdd = function(argument0, argument1, argument2)
	{
		ds_list_add(stickList, new stick(argument0, argument1, argument2));
	};
	
	simulate = function(argument0, argument1)
	{
		var vertexAmount = ds_list_size(vertexList);
		
		for (var i = 0; i < vertexAmount; i++)
		{
			var currentVertex = ds_list_find_value(vertexList, i);
			
			if (!currentVertex.fixed)
			{
				var vx = (currentVertex.x - currentVertex.xLast) * argument0;
				var vy = (currentVertex.y - currentVertex.yLast) * argument0;
				currentVertex.xLast = currentVertex.x;
				currentVertex.yLast = currentVertex.y;
				currentVertex.x += vx;
				currentVertex.y += vy;
				
				if (!collide(currentVertex.x, currentVertex.y, currentVertex.radius))
					currentVertex.y += argument1 * currentVertex.weight;
			}
		}
		
		var attachmentAmount = ds_list_size(attachmentList);
		
		for (var i = 0; i < attachmentAmount; i++)
		{
			var currentAttachment = ds_list_find_value(attachmentList, i);
			
			if (currentAttachment.hierarchy == 0)
			{
				if (currentAttachment.type != UnknownEnum.Value_1)
				{
					currentAttachment.object.x = ds_list_find_value(vertexList, currentAttachment.index).x + currentAttachment.xoff;
					currentAttachment.object.y = ds_list_find_value(vertexList, currentAttachment.index).y + currentAttachment.yoff;
				}
				
				if (currentAttachment.type != UnknownEnum.Value_0)
				{
					if (currentAttachment.index == 0)
						currentAttachment.object.image_angle = 0;
					else
						currentAttachment.object.image_angle = point_direction(ds_list_find_value(vertexList, currentAttachment.index - 1).x, ds_list_find_value(vertexList, currentAttachment.index - 1).y, ds_list_find_value(vertexList, currentAttachment.index).x, ds_list_find_value(vertexList, currentAttachment.index).y);
				}
			}
			else
			{
				ds_list_find_value(vertexList, currentAttachment.index).x = currentAttachment.object.x + currentAttachment.xoff;
				ds_list_find_value(vertexList, currentAttachment.index).y = currentAttachment.object.y + currentAttachment.yoff;
			}
		}
		
		if (system != -4)
		{
			var forceFieldAmount = ds_list_size(system.forceFields);
			vertexAmount = ds_list_size(vertexList);
			
			for (var i = 0; i < forceFieldAmount; i++)
			{
				var currentForceField = ds_list_find_value(system.forceFields, i);
				var dir = currentForceField.dir + 180;
				var str = currentForceField.str;
				
				if (currentForceField.useNoise)
					str *= (sin(2 * current_time) + sin(pi * current_time));
				
				for (var j = 0; j < vertexAmount; j++)
				{
					var currentVertex = ds_list_find_value(vertexList, j);
					
					if (point_in_rectangle(currentVertex.x, currentVertex.y, currentForceField.x1, currentForceField.y1, currentForceField.x2, currentForceField.y2))
					{
						currentVertex.xLast += lengthdir_x(str, dir);
						currentVertex.yLast += lengthdir_y(str, dir);
					}
				}
			}
		}
		
		repeat (stiffness)
		{
			var stickAmount = ds_list_size(stickList);
			
			for (var i = 0; i < stickAmount; i++)
			{
				var currentStick = ds_list_find_value(stickList, i);
				var dx = currentStick.v1.x - currentStick.v2.x;
				var dy = currentStick.v1.y - currentStick.v2.y;
				var dist = sqrt((dx * dx) + (dy * dy));
				var difference = currentStick.length - dist;
				var percent = (difference / dist) * 0.5;
				var offsetX = dx * percent;
				var offsetY = dy * percent;
				
				if (aliveCounter >= (room_speed * spawnRipDelaySeconds) && maxTension < 10 && abs(percent) > maxTension && !currentStick.v1.fixed && !currentStick.v2.fixed)
				{
					ds_list_delete(stickList, i);
					i--;
					stickAmount--;
				}
				else if (currentStick.v1.fixed)
				{
					if (!currentStick.v2.fixed)
					{
						currentStick.v2.x -= offsetX * 2;
						currentStick.v2.y -= offsetY * 2;
					}
				}
				else if (currentStick.v2.fixed)
				{
					currentStick.v1.x += offsetX * 2;
					currentStick.v1.y += offsetY * 2;
				}
				else
				{
					currentStick.v1.x += offsetX;
					currentStick.v1.y += offsetY;
					currentStick.v2.x -= offsetX;
					currentStick.v2.y -= offsetY;
				}
			}
			
			vertexAmount = ds_list_size(vertexList);
			
			for (var i = 0; i < vertexAmount; i++)
			{
				var currentVertex = ds_list_find_value(vertexList, i);
				
				if (!currentVertex.fixed)
				{
					var vx = (currentVertex.x - currentVertex.xLast) * argument0;
					var vy = (currentVertex.y - currentVertex.yLast) * argument0;
					var inst = collide(currentVertex.x, currentVertex.y, currentVertex.radius);
					
					if (inst != -4)
					{
						var dir;
						
						if (inst.type == UnknownEnum.Value_0)
						{
							dir = 0;
							
							if (currentVertex.yLast < inst.bbox_top)
								dir = 90;
							else if (currentVertex.yLast > inst.bbox_bottom)
								dir = 270;
							else if (currentVertex.xLast < inst.bbox_left)
								dir = 180;
							else if (currentVertex.xLast > inst.bbox_right)
								dir = 0;
						}
						else
						{
							dir = point_direction(inst.x, inst.y, currentVertex.x, currentVertex.y);
						}
						
						while (collide(currentVertex.x, currentVertex.y, currentVertex.radius))
						{
							currentVertex.x += lengthdir_x(1, dir);
							currentVertex.y += lengthdir_y(1, dir);
						}
						
						var prec = 0.1;
						
						while (!collide(currentVertex.x + lengthdir_x(prec, dir + 180), currentVertex.y + lengthdir_y(prec, dir + 180), currentVertex.radius))
						{
							currentVertex.x += lengthdir_x(prec, dir + 180);
							currentVertex.y += lengthdir_y(prec, dir + 180);
						}
						
						currentVertex.xLast = currentVertex.x;
						currentVertex.yLast = currentVertex.y;
					}
				}
			}
		}
		
		if (aliveCounter <= (room_speed * spawnRipDelaySeconds))
			aliveCounter++;
	};
	
	drawWireframe = function()
	{
		var vertexAmount = ds_list_size(vertexList);
		var stickAmount = ds_list_size(stickList);
		draw_set_color(c_gray);
		
		for (var i = 0; i < stickAmount; i++)
		{
			var currentStick = ds_list_find_value(stickList, i);
			draw_line_width(currentStick.v1.x, currentStick.v1.y, currentStick.v2.x, currentStick.v2.y, 1);
		}
		
		draw_set_color(c_white);
		
		for (var i = 0; i < vertexAmount; i++)
		{
			var currentVertex = ds_list_find_value(vertexList, i);
			draw_circle(currentVertex.x, currentVertex.y, 1, false);
		}
	};
	
	draw = drawWireframe;
	
	cleanup = function()
	{
		if (system != -4 && verletSystemExists(system))
		{
			var verletGroupAmount = ds_list_size(system.verletGroups);
			
			for (var i = 0; i < verletGroupAmount; i++)
			{
				if (ds_list_find_value(system.verletGroups, i) == self)
				{
					ds_list_delete(system.verletGroups, i);
					break;
				}
			}
		}
		
		if (ds_exists(vertexList, ds_type_list))
			ds_list_destroy(vertexList);
		
		if (ds_exists(stickList, ds_type_list))
			ds_list_destroy(stickList);
		
		if (ds_exists(attachmentList, ds_type_list))
			ds_list_destroy(attachmentList);
	};
}

function verletGroupExists(argument0)
{
	return is_struct(argument0);
}

function verletGroupCreateRope(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8)
{
	var newGroup = new verletGroup();
	newGroup.color = argument3;
	newGroup.width = argument4;
	newGroup.stiffness = argument7;
	newGroup.maxTension = argument8;
	
	with (newGroup)
	{
		for (var i = 0; i < (argument6 + 1); i++)
			vertexAdd(argument1, argument2 + (i * argument5), 1, argument4 / 2);
		
		for (var i = 1; i < (argument6 + 1); i++)
			stickAdd(ds_list_find_value(vertexList, i - 1), ds_list_find_value(vertexList, i), argument5);
		
		draw = function()
		{
			var stickAmount = ds_list_size(stickList);
			var wHalf = width * 0.5;
			draw_set_color(color);
			draw_primitive_begin(pr_trianglestrip);
			var currentStick, stickDir;
			
			for (var i = 0; i < stickAmount; i++)
			{
				currentStick = ds_list_find_value(stickList, i);
				stickDir = point_direction(currentStick.v1.x, currentStick.v1.y, currentStick.v2.x, currentStick.v2.y);
				draw_vertex(currentStick.v1.x + lengthdir_x(wHalf, stickDir - 90), currentStick.v1.y + lengthdir_y(wHalf, stickDir - 90));
				draw_vertex(currentStick.v1.x + lengthdir_x(wHalf, stickDir + 90), currentStick.v1.y + lengthdir_y(wHalf, stickDir + 90));
			}
			
			draw_vertex(currentStick.v2.x + lengthdir_x(wHalf, stickDir - 90), currentStick.v2.y + lengthdir_y(wHalf, stickDir - 90));
			draw_vertex(currentStick.v2.x + lengthdir_x(wHalf, stickDir + 90), currentStick.v2.y + lengthdir_y(wHalf, stickDir + 90));
			draw_primitive_end();
			draw_set_color(c_white);
		};
	}
	
	newGroup.vertexChangeData(-4, undefined, undefined, undefined, true);
	
	if (argument0 != undefined)
	{
		if (verletSystemExists(argument0))
		{
			newGroup.system = argument0;
			ds_list_add(argument0.verletGroups, newGroup);
		}
	}
	
	return newGroup;
}

function verletGroupCreateRopeTextured(argument0, argument1, argument2, argument3, argument4, argument5, argument6)
{
	var newGroup = new verletGroup();
	newGroup.sprite = argument3;
	newGroup.stiffness = argument5;
	newGroup.maxTension = argument6;
	
	with (newGroup)
	{
		var segmentLength = sprite_get_height(argument3) - sprite_get_yoffset(argument3);
		
		for (var i = 0; i < (argument4 + 1); i++)
			vertexAdd(argument1, argument2 + (i * segmentLength), 1, sprite_get_width(argument3) / 2);
		
		for (var i = 1; i < (argument4 + 1); i++)
			stickAdd(ds_list_find_value(vertexList, i - 1), ds_list_find_value(vertexList, i), segmentLength);
		
		draw = function()
		{
			var stickAmount = ds_list_size(stickList);
			var texture = sprite_get_texture(sprite, 0);
			var swHalf = sprite_get_width(sprite) * 0.5;
			var yoff = sprite_get_yoffset(sprite);
			
			for (var i = 0; i < stickAmount; i++)
			{
				var currentStick = ds_list_find_value(stickList, i);
				var stickDir = point_direction(currentStick.v1.x, currentStick.v1.y, currentStick.v2.x, currentStick.v2.y);
				draw_primitive_begin_texture(pr_trianglestrip, texture);
				draw_vertex_texture(currentStick.v1.x + lengthdir_x(swHalf, stickDir - 90) + lengthdir_x(yoff, stickDir + 180), currentStick.v1.y + lengthdir_y(swHalf, stickDir - 90) + lengthdir_y(yoff, stickDir + 180), 0, 0);
				draw_vertex_texture(currentStick.v1.x + lengthdir_x(swHalf, stickDir + 90) + lengthdir_x(yoff, stickDir + 180), currentStick.v1.y + lengthdir_y(swHalf, stickDir + 90) + lengthdir_y(yoff, stickDir + 180), 1, 0);
				draw_vertex_texture(currentStick.v2.x + lengthdir_x(swHalf, stickDir - 90), currentStick.v2.y + lengthdir_y(swHalf, stickDir - 90), 0, 1);
				draw_vertex_texture(currentStick.v2.x + lengthdir_x(swHalf, stickDir + 90), currentStick.v2.y + lengthdir_y(swHalf, stickDir + 90), 1, 1);
				draw_primitive_end();
			}
		};
	}
	
	newGroup.vertexChangeData(-4, undefined, undefined, undefined, true);
	
	if (argument0 != undefined)
	{
		if (verletSystemExists(argument0))
		{
			newGroup.system = argument0;
			ds_list_add(argument0.verletGroups, newGroup);
		}
	}
	
	return newGroup;
}

function verletGroupCreateBox(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7)
{
	var newGroup = new verletGroup();
	newGroup.color = argument5;
	newGroup.stiffness = argument6;
	newGroup.maxTension = argument7;
	
	with (newGroup)
	{
		vertexAdd(argument1, argument2, 1, 1);
		vertexAdd(argument1 + argument3, argument2, 1, 1);
		vertexAdd(argument1, argument2 + argument4, 1, 1);
		vertexAdd(argument1 + argument3, argument2 + argument4, 1, 1);
		stickAdd(ds_list_find_value(vertexList, 0), ds_list_find_value(vertexList, 1), argument3);
		stickAdd(ds_list_find_value(vertexList, 2), ds_list_find_value(vertexList, 3), argument3);
		stickAdd(ds_list_find_value(vertexList, 0), ds_list_find_value(vertexList, 2), argument4);
		stickAdd(ds_list_find_value(vertexList, 1), ds_list_find_value(vertexList, 3), argument4);
		stickAdd(ds_list_find_value(vertexList, 0), ds_list_find_value(vertexList, 3), sqrt(sqr(argument3) + sqr(argument4)));
		
		draw = function()
		{
			draw_set_color(color);
			draw_primitive_begin(pr_trianglestrip);
			var v1 = ds_list_find_value(vertexList, 0);
			var v2 = ds_list_find_value(vertexList, 1);
			var v3 = ds_list_find_value(vertexList, 2);
			var v4 = ds_list_find_value(vertexList, 3);
			draw_vertex(v1.x, v1.y);
			draw_vertex(v2.x, v2.y);
			draw_vertex(v3.x, v3.y);
			draw_vertex(v4.x, v4.y);
			draw_primitive_end();
			draw_set_color(c_white);
		};
	}
	
	if (argument0 != undefined)
	{
		if (verletSystemExists(argument0))
		{
			newGroup.system = argument0;
			ds_list_add(argument0.verletGroups, newGroup);
		}
	}
	
	return newGroup;
}

function verletGroupCreateBoxTextured(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7)
{
	var newGroup = verletGroupCreateBox(argument0, argument1, argument2, argument3, argument4, 16777215, argument6, argument7);
	newGroup.sprite = argument5;
	
	with (newGroup)
	{
		draw = function()
		{
			var texture = sprite_get_texture(sprite, 0);
			draw_set_color(color);
			draw_primitive_begin_texture(pr_trianglestrip, texture);
			var v1 = ds_list_find_value(vertexList, 0);
			var v2 = ds_list_find_value(vertexList, 1);
			var v3 = ds_list_find_value(vertexList, 2);
			var v4 = ds_list_find_value(vertexList, 3);
			draw_vertex_texture(v1.x, v1.y, 0, 0);
			draw_vertex_texture(v2.x, v2.y, 1, 0);
			draw_vertex_texture(v3.x, v3.y, 0, 1);
			draw_vertex_texture(v4.x, v4.y, 1, 1);
			draw_primitive_end();
			draw_set_color(c_white);
		};
	}
	
	if (argument0 != undefined)
	{
		if (verletSystemExists(argument0))
		{
			newGroup.system = argument0;
			ds_list_add(argument0.verletGroups, newGroup);
		}
	}
	
	return newGroup;
}

function verletGroupCreateCloth(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8)
{
	var newGroup = new verletGroup();
	newGroup.color = argument6;
	newGroup.stiffness = argument7;
	newGroup.maxTension = argument8;
	newGroup.subDivisions = argument5;
	
	with (newGroup)
	{
		var segmentWidth = argument3 / (1 + argument5);
		var segmentHeight = argument4 / (1 + argument5);
		
		for (var i = 0; i < (2 + argument5); i++)
		{
			for (var j = 0; j < (2 + argument5); j++)
				vertexAdd(argument1 + (i * segmentWidth), argument2 + (j * segmentHeight), 1, 1);
		}
		
		for (var i = 0; i < (2 + argument5); i++)
		{
			for (var j = 0; j < (2 + argument5); j++)
			{
				if (i > 0)
					stickAdd(ds_list_find_value(vertexList, (i - 1) + (j * (2 + argument5))), ds_list_find_value(vertexList, i + (j * (2 + argument5))), segmentHeight);
				
				if (j > 0)
					stickAdd(ds_list_find_value(vertexList, i + ((j - 1) * (2 + argument5))), ds_list_find_value(vertexList, i + (j * (2 + argument5))), segmentWidth);
			}
		}
		
		draw = function()
		{
			draw_set_color(color);
			draw_primitive_begin(pr_trianglestrip);
			
			for (var i = 0; i < (1 + subDivisions); i++)
			{
				for (var j = 1; j < (2 + subDivisions); j++)
				{
					var v1 = ds_list_find_value(vertexList, ((i * (2 + subDivisions)) + j) - 1);
					var v2 = ds_list_find_value(vertexList, (((i + 1) * (2 + subDivisions)) + j) - 1);
					var v3 = ds_list_find_value(vertexList, (i * (2 + subDivisions)) + j);
					var v4 = ds_list_find_value(vertexList, ((i + 1) * (2 + subDivisions)) + j);
					draw_vertex(v1.x, v1.y);
					draw_vertex(v2.x, v2.y);
					draw_vertex(v3.x, v3.y);
					draw_vertex(v4.x, v4.y);
				}
			}
			
			draw_primitive_end();
			draw_set_color(c_white);
		};
	}
	
	for (var i = 0; i < (2 + argument5); i++)
		newGroup.vertexChangeData(i * (2 + argument5), undefined, undefined, undefined, true);
	
	if (argument0 != undefined)
	{
		if (verletSystemExists(argument0))
		{
			newGroup.system = argument0;
			ds_list_add(argument0.verletGroups, newGroup);
		}
	}
	
	return newGroup;
}

function verletGroupCreateClothTextured(argument0, argument1, argument2, argument3, argument4, argument5, argument6, argument7, argument8)
{
	var newGroup = verletGroupCreateCloth(argument0, argument1, argument2, argument3, argument4, argument5, 16777215, argument7, argument8);
	newGroup.sprite = argument6;
	
	with (newGroup)
	{
		draw = function()
		{
			var texture = sprite_get_texture(sprite, 0);
			
			for (var i = 0; i < (1 + subDivisions); i++)
			{
				draw_primitive_begin_texture(pr_trianglestrip, texture);
				
				for (var j = 1; j < (2 + subDivisions); j++)
				{
					var v1 = ds_list_find_value(vertexList, ((i * (2 + subDivisions)) + j) - 1);
					var v2 = ds_list_find_value(vertexList, (((i + 1) * (2 + subDivisions)) + j) - 1);
					var v3 = ds_list_find_value(vertexList, (i * (2 + subDivisions)) + j);
					var v4 = ds_list_find_value(vertexList, ((i + 1) * (2 + subDivisions)) + j);
					var m = 1 / (1 + subDivisions);
					draw_vertex_texture(v1.x, v1.y, i * m, (j - 1) * m);
					draw_vertex_texture(v2.x, v2.y, (i + 1) * m, (j - 1) * m);
					draw_vertex_texture(v3.x, v3.y, i * m, j * m);
					draw_vertex_texture(v4.x, v4.y, (i + 1) * m, j * m);
				}
				
				draw_primitive_end();
			}
			
			draw_set_color(c_white);
		};
	}
	
	return newGroup;
}

function vertex(argument0, argument1, argument2, argument3) constructor
{
	x = argument0;
	y = argument1;
	weight = argument2;
	xLast = x + random_range(-1, 1);
	yLast = y + random_range(-1, 1);
	radius = argument3;
	fixed = false;
}

function stick(argument0, argument1, argument2) constructor
{
	v1 = argument0;
	v2 = argument1;
	length = argument2;
	active = true;
}

function attachment(argument0, argument1, argument2, argument3, argument4, argument5) constructor
{
	index = argument0;
	object = argument1;
	type = argument2;
	hierarchy = argument3;
	xoff = argument4;
	yoff = argument5;
}

function forceField(argument0, argument1, argument2, argument3, argument4, argument5, argument6) constructor
{
	x1 = argument0;
	y1 = argument1;
	x2 = argument2;
	y2 = argument3;
	dir = argument4;
	str = argument5;
	useNoise = argument6;
}

function get_rotated_corners_obj(arg0, arg1, arg2)
{
    var spr = arg0.sprite_index;
    var xorigin = sprite_get_xoffset(spr);
    var yorigin = sprite_get_yoffset(spr);
    var bleft = sprite_get_bbox_left(spr);
    var bright = sprite_get_bbox_right(spr);
    var btop = sprite_get_bbox_top(spr);
    var bbottom = sprite_get_bbox_bottom(spr);
    var rotation_center_x = arg1 + xorigin;
    var rotation_center_y = arg2 + yorigin;
    var angle_rad = (arg0.image_angle * pi) / 180;
    var cos_angle = cos(angle_rad);
    var sin_angle = -sin(angle_rad);
    var corner1_x = (arg1 + (cos_angle * (bleft - xorigin) * arg0.image_xscale)) - (sin_angle * (btop - yorigin) * arg0.image_yscale) - 0.9;
    var corner1_y = (arg2 + (sin_angle * (bleft - xorigin) * arg0.image_xscale) + (cos_angle * (btop - yorigin) * arg0.image_yscale)) - 0.9;
    var corner2_x = (arg1 + (cos_angle * (bright - xorigin) * arg0.image_xscale)) - (sin_angle * (btop - yorigin) * arg0.image_yscale) - 0.9;
    var corner2_y = (arg2 + (sin_angle * (bright - xorigin) * arg0.image_xscale) + (cos_angle * (btop - yorigin) * arg0.image_yscale)) - 0.9;
    var corner3_x = (arg1 + (cos_angle * (bright - xorigin) * arg0.image_xscale)) - (sin_angle * (bbottom - yorigin) * arg0.image_yscale) - 0.9;
    var corner3_y = (arg2 + (sin_angle * (bright - xorigin) * arg0.image_xscale) + (cos_angle * (bbottom - yorigin) * arg0.image_yscale)) - 0.9;
    var corner4_x = (arg1 + (cos_angle * (bleft - xorigin) * arg0.image_xscale)) - (sin_angle * (bbottom - yorigin) * arg0.image_yscale) - 0.9;
    var corner4_y = (arg2 + (sin_angle * (bleft - xorigin) * arg0.image_xscale) + (cos_angle * (bbottom - yorigin) * arg0.image_yscale)) - 0.9;
    return [corner1_x, corner1_y, corner2_x, corner2_y, corner3_x, corner3_y, corner4_x, corner4_y];
}

function collide_obj_fast(arg0, arg1, arg2, arg3, arg4, arg5)
{
    var spr1 = arg0.sprite_index;
    var spr2 = arg3.sprite_index;
    var xorigin1 = sprite_get_xoffset(spr1);
    var yorigin1 = sprite_get_yoffset(spr1);
    var xorigin2 = sprite_get_xoffset(spr2);
    var yorigin2 = sprite_get_yoffset(spr2);
    var corner1_x = (arg1 - xorigin1) + sprite_get_bbox_left(spr1);
    var corner1_y = (arg2 - yorigin1) + sprite_get_bbox_top(spr1);
    var corner2_x = (arg1 - xorigin1) + sprite_get_bbox_right(spr1);
    var corner2_y = (arg2 - yorigin1) + sprite_get_bbox_bottom(spr1);
    var corner3_x = (arg4 - xorigin2) + sprite_get_bbox_left(spr2);
    var corner3_y = (arg5 - yorigin2) + sprite_get_bbox_top(spr2);
    var corner4_x = (arg4 - xorigin2) + sprite_get_bbox_right(spr2);
    var corner4_y = (arg5 - yorigin2) + sprite_get_bbox_bottom(spr2);
    if (rectangle_in_rectangle(corner1_x, corner1_y, corner2_x, corner2_y, corner3_x, corner3_y, corner4_x, corner4_y))
    {
        return true;
    }
    else
    {
        return false;
    }
}

function collide_obj(arg0, arg1, arg2, arg3, arg4, arg5)
{
    var corners_obj1 = get_rotated_corners_obj(arg0, arg1, arg2);
    var corners_obj2 = get_rotated_corners_obj(arg3, arg4, arg5);
    var obj1_inside_obj2 = true;
    var obj2_inside_obj1 = true;
    var bbox1 = bbox_from_corners(corners_obj1[0], corners_obj1[1], corners_obj1[2], corners_obj1[3], corners_obj1[4], corners_obj1[5], corners_obj1[6], corners_obj1[7]);
    var bbox2 = bbox_from_corners(corners_obj2[0], corners_obj2[1], corners_obj2[2], corners_obj2[3], corners_obj2[4], corners_obj2[5], corners_obj2[6], corners_obj2[7]);
    if (rectangle_in_rectangle(bbox1[0], bbox1[1], bbox1[2], bbox1[3], bbox2[0], bbox2[1], bbox2[2], bbox2[3]))
    {
        for (var i = 0; i < 4; i++)
        {
            if (!point_in_polygon(corners_obj1[i * 2], corners_obj1[(i * 2) + 1], corners_obj2))
            {
                obj1_inside_obj2 = false;
                break;
            }
        }
        for (var i = 0; i < 4; i++)
        {
            if (!point_in_polygon(corners_obj2[i * 2], corners_obj2[(i * 2) + 1], corners_obj1))
            {
                obj2_inside_obj1 = false;
                break;
            }
        }
        if (obj1_inside_obj2 || obj2_inside_obj1)
        {
            return true;
        }
        for (var i = 0; i < 4; i++)
        {
            var j = (i + 1) % 4;
            var line1_x1 = corners_obj1[i * 2];
            var line1_y1 = corners_obj1[(i * 2) + 1];
            var line1_x2 = corners_obj1[j * 2];
            var line1_y2 = corners_obj1[(j * 2) + 1];
            for (var k = 0; k < 4; k++)
            {
                var l = (k + 1) % 4;
                var line2_x1 = corners_obj2[k * 2];
                var line2_y1 = corners_obj2[(k * 2) + 1];
                var line2_x2 = corners_obj2[l * 2];
                var line2_y2 = corners_obj2[(l * 2) + 1];
                if (line_segments_intersect(line1_x1, line1_y1, line1_x2, line1_y2, line2_x1, line2_y1, line2_x2, line2_y2))
                {
                    return true;
                }
            }
        }
    }
    return false;
}

function bounding_box_in_polygon(arg0, arg1, arg2, arg3)
{
    var spritew = sprite_get_width(arg0);
    var spriteh = sprite_get_height(arg0);
    var x_offset = sprite_get_xoffset(arg0);
    var y_offset = sprite_get_yoffset(arg0);
    var top_left_x = arg1 - x_offset;
    var top_left_y = arg2 - y_offset;
    var corners = [[top_left_x, top_left_y], [top_left_x + spritew, top_left_y], [top_left_x + spritew, top_left_y + spriteh], [top_left_x, top_left_y + spriteh]];
    for (var i = 0; i < 4; i++)
    {
        if (scamp_point_in_polygon(corners[i][0], corners[i][1], arg3) || scamp_line_intersect_polygon(corners[i][0], corners[i][1], corners[(i + 1) % 4][0], corners[(i + 1) % 4][1], arg3))
        {
            return true;
        }
    }
    return false;
}

function scamp_point_in_polygon(arg0, arg1, arg2)
{
    var inside = false;
    var n = array_length(arg2);
    var p1x = arg2[n - 1][0];
    var p1y = arg2[n - 1][1];
    for (var i = 0; i < n; i++)
    {
        var p2x = arg2[i][0];
        var p2y = arg2[i][1];
        if (arg1 > min(p1y, p2y) && arg1 <= max(p1y, p2y) && arg0 <= max(p1x, p2x))
        {
            var xinters;
            if (p1y != p2y)
            {
                xinters = (((arg1 - p1y) * (p2x - p1x)) / (p2y - p1y)) + p1x;
            }
            if (p1x == p2x || arg0 <= xinters)
            {
                inside = !inside;
            }
        }
        p1x = p2x;
        p1y = p2y;
    }
    return inside;
}

function point_in_polygon(arg0, arg1, arg2)
{
    var num_corners = array_length(arg2) / 2;
    var inside = false;
    var i = 0;
    var j = num_corners - 1;
    i = 0;
    while (i < num_corners)
    {
        if ((arg2[(i * 2) + 1] > arg1) != (arg2[(j * 2) + 1] > arg1) && arg0 < ((((arg2[j * 2] - arg2[i * 2]) * (arg1 - arg2[(i * 2) + 1])) / (arg2[(j * 2) + 1] - arg2[(i * 2) + 1])) + arg2[i * 2]))
        {
            inside = !inside;
        }
        j = i++;
    }
    return inside;
}

function scamp_line_intersect_polygon(arg0, arg1, arg2, arg3, arg4)
{
    var n = array_length(arg4);
    for (var i = 0; i < n; i++)
    {
        var p1x = arg4[i][0];
        var p1y = arg4[i][1];
        var p2x = arg4[(i + 1) % n][0];
        var p2y = arg4[(i + 1) % n][1];
        if (line_segments_intersect(arg0, arg1, arg2, arg3, p1x, p1y, p2x, p2y))
        {
            return true;
        }
    }
    return false;
}

function line_intersect_polygon(arg0, arg1, arg2, arg3, arg4)
{
    var n = array_length(arg4);
    var p1x = arg4[n - 1][0];
    var p1y = arg4[n - 1][1];
    for (var i = 0; i < n; i++)
    {
        var p2x = arg4[i][0];
        var p2y = arg4[i][1];
        if (line_segments_intersect(arg0, arg1, arg2, arg3, p1x, p1y, p2x, p2y))
        {
            return true;
        }
        p1x = p2x;
        p1y = p2y;
    }
    return false;
}

function line_segments_intersect(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
{
    var denom = ((arg0 - arg2) * (arg5 - arg7)) - ((arg1 - arg3) * (arg4 - arg6));
    if (denom == 0)
    {
        return false;
    }
    var t = (((arg0 - arg4) * (arg5 - arg7)) - ((arg1 - arg5) * (arg4 - arg6))) / denom;
    var u = (((arg0 - arg4) * (arg1 - arg3)) - ((arg1 - arg5) * (arg0 - arg2))) / denom;
    return t >= 0 && t <= 1 && u >= 0 && u <= 1;
}

function draw_bounding_box(arg0, arg1, arg2, arg3)
{
    var spritew = sprite_get_width(arg0);
    var spriteh = sprite_get_height(arg0);
    var x_offset = sprite_get_xoffset(arg0);
    var y_offset = sprite_get_yoffset(arg0);
    var top_left_x = arg1 - x_offset;
    var top_left_y = arg2 - y_offset;
    var top_right_x = (arg1 - x_offset) + spritew;
    var top_right_y = arg2 - y_offset;
    var bottom_left_x = arg1 - x_offset;
    var bottom_left_y = (arg2 - y_offset) + spriteh;
    var bottom_right_x = (arg1 - x_offset) + spritew;
    var bottom_right_y = (arg2 - y_offset) + spriteh;
    draw_set_color(arg3);
    draw_line(top_left_x, top_left_y, top_right_x, top_right_y);
    draw_line(top_right_x, top_right_y, bottom_right_x, bottom_right_y);
    draw_line(bottom_right_x, bottom_right_y, bottom_left_x, bottom_left_y);
    draw_line(bottom_left_x, bottom_left_y, top_left_x, top_left_y);
}

function bbox_from_corners(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
{
    var min_x = min(arg0, arg2, arg4, arg6);
    var max_x = max(arg0, arg2, arg4, arg6);
    var min_y = min(arg1, arg3, arg5, arg7);
    var max_y = max(arg1, arg3, arg5, arg7);
    return [min_x, min_y, max_x, max_y];
}

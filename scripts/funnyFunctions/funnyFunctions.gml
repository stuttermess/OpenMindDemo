function spring(arg0, arg1, arg2, arg3, arg4)
{
    var _spd_to_add = (arg3 * (arg2 - arg0)) - (arg4 * arg1);
    arg1 += _spd_to_add;
    var result;
    result[0] = arg0 + arg1;
    result[1] = arg1;
    return result;
}

function draw_sprite_skew(arg0, arg1, arg2, arg3, arg4, arg5)
{
    draw_sprite_skew_ext(arg0, arg1, arg2, arg3, 1, 1, image_angle, image_blend, image_alpha, arg4, arg5);
}

function draw_sprite_skew_ext(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
{
    var cosAngle = cos(degtorad(arg6));
    var sinAngle = sin(degtorad(arg6));
    var sprTex = sprite_get_texture(arg0, arg1);
    var sprWidth = sprite_get_width(arg0);
    var sprHeight = sprite_get_height(arg0);
    var sprXOrig = sprite_get_xoffset(arg0);
    var sprYOrig = sprite_get_yoffset(arg0);
    draw_primitive_begin_texture(pr_trianglestrip, sprTex);
    var tempX = (-sprXOrig + ((sprYOrig / sprHeight) * arg9)) * arg4;
    var tempY = (-sprYOrig + ((sprXOrig / sprWidth) * -arg10)) * arg5;
    draw_vertex_texture_color((arg2 + (tempX * cosAngle)) - (tempY * sinAngle), arg3 + (tempX * sinAngle) + (tempY * cosAngle), 0, 0, arg7, arg8);
    tempX = ((sprWidth + ((sprYOrig / sprHeight) * arg9)) - sprXOrig) * arg4;
    tempY = (-sprYOrig + ((1 - (sprXOrig / sprWidth)) * arg10)) * arg5;
    draw_vertex_texture_color((arg2 + (tempX * cosAngle)) - (tempY * sinAngle), arg3 + (tempX * sinAngle) + (tempY * cosAngle), 1, 0, arg7, arg8);
    tempX = (-sprXOrig + ((1 - (sprYOrig / sprHeight)) * -arg9)) * arg4;
    tempY = ((sprHeight - sprYOrig) + ((sprXOrig / sprWidth) * -arg10)) * arg5;
    draw_vertex_texture_color((arg2 + (tempX * cosAngle)) - (tempY * sinAngle), arg3 + (tempX * sinAngle) + (tempY * cosAngle), 0, 1, arg7, arg8);
    tempX = ((sprWidth - sprXOrig) + ((1 - (sprYOrig / sprHeight)) * -arg9)) * arg4;
    tempY = ((sprHeight - sprYOrig) + ((1 - (sprXOrig / sprWidth)) * arg10)) * arg5;
    draw_vertex_texture_color((arg2 + (tempX * cosAngle)) - (tempY * sinAngle), arg3 + (tempX * sinAngle) + (tempY * cosAngle), 1, 1, arg7, arg8);
    draw_primitive_end();
}

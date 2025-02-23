function vertex_add_point()
{
    var i = 0;
    var vbuffer = argument[i];
    i++;
    var xx = argument[i];
    i++;
    var yy = argument[i];
    i++;
    var zz = argument[i];
    i++;
    var nx = argument[i];
    i++;
    var ny = argument[i];
    i++;
    var nz = argument[i];
    i++;
    var utex = argument[i];
    i++;
    var vtex = argument[i];
    i++;
    var colour = argument[i];
    i++;
    var alpha = argument[i];
    i++;
    vertex_position_3d(vbuffer, xx, yy, zz);
    vertex_normal(vbuffer, nx, ny, nz);
    vertex_texcoord(vbuffer, utex, vtex);
    vertex_colour(vbuffer, colour, alpha);
}

function load_obj(arg0, arg1)
{
    var obj_file = file_text_open_read(arg0);
    var mtl_file = file_text_open_read(arg1);
    var mtl_name = "None";
    var active_mtl = "None";
    var mtl_alpha = ds_map_create();
    var mtl_color = ds_map_create();
    ds_map_add(mtl_alpha, "None", 1);
    ds_map_add(mtl_color, "None", c_white);
    while (!file_text_eof(mtl_file))
    {
        var line = file_text_read_string(mtl_file);
        file_text_readln(mtl_file);
        var index = 0;
        var terms;
        terms[0] = "";
        terms[string_count(line, " ")] = "";
        for (var i = 1; i <= string_length(line); i++)
        {
            if (string_char_at(line, i) == " ")
            {
                index++;
                terms[index] = "";
            }
            else
            {
                terms[index] = terms[index] + string_char_at(line, i);
            }
        }
        switch (terms[0])
        {
            case "newmtl":
                mtl_name = terms[1];
                break;
            case "Kd":
                var red = real(terms[1]) * 255;
                var green = real(terms[2]) * 255;
                var blue = real(terms[3]) * 255;
                var color = make_color_rgb(red, green, blue);
                ds_map_set(mtl_color, mtl_name, color);
                break;
            case "d":
                var alpha = real(terms[1]);
                ds_map_set(mtl_alpha, mtl_name, alpha);
                break;
            default:
                break;
        }
    }
    var model = vertex_create_buffer();
    vertex_begin(model, master.obj_vertex_format);
    var vertex_x = ds_list_create();
    var vertex_y = ds_list_create();
    var vertex_z = ds_list_create();
    var vertex_nx = ds_list_create();
    var vertex_ny = ds_list_create();
    var vertex_nz = ds_list_create();
    var vertex_xtex = ds_list_create();
    var vertex_ytex = ds_list_create();
    while (!file_text_eof(obj_file))
    {
        var line = file_text_read_string(obj_file);
        file_text_readln(obj_file);
        var index = 0;
        var terms = array_create(string_count(line, " ") + 1, "");
        for (var i = 1; i <= string_length(line); i++)
        {
            if (string_char_at(line, i) == " ")
            {
                if (terms[index] != "")
                {
                    index++;
                    terms[index] = "";
                }
            }
            else
            {
                terms[index] += string_char_at(line, i);
            }
        }
        while (array_length(terms) > 1 && terms[array_length(terms) - 1] == "")
        {
            array_delete(terms, array_length(terms) - 1, 1);
        }
        switch (terms[0])
        {
            case "v":
                ds_list_add(vertex_x, real(terms[1]));
                ds_list_add(vertex_y, real(terms[2]));
                ds_list_add(vertex_z, real(terms[3]));
                break;
            case "vt":
                ds_list_add(vertex_xtex, real(terms[1]));
                ds_list_add(vertex_ytex, real(terms[2]));
                break;
            case "vn":
                ds_list_add(vertex_nx, real(terms[1]));
                ds_list_add(vertex_ny, real(terms[2]));
                ds_list_add(vertex_nz, real(terms[3]));
                break;
            case "f":
                var verts = [];
                for (var n = 1; n <= (array_length(terms) - 1); n++)
                {
                    index = 0;
                    var data = array_create(string_count(terms[n], "/") + 1, "");
                    for (var i = 1; i <= string_length(terms[n]); i++)
                    {
                        if (string_char_at(terms[n], i) == "/")
                        {
                            index++;
                            data[index] = "";
                        }
                        else
                        {
                            data[index] += string_char_at(terms[n], i);
                        }
                    }
                    verts[n - 1] = data;
                }
                for (var i = 1; i < (ceil(array_length(verts) / 3) + 1); i++)
                {
                    for (var j = 2; j >= 0; j--)
                    {
                        var vertnum = ((i * 2) + j) % array_length(verts);
                        var data = verts[vertnum];
                        for (var k = 0; k < 3; k++)
                        {
                            if (data[k] == "")
                            {
                                data[k] = "1";
                                switch (k)
                                {
                                    case 0:
                                        if (ds_list_size(vertex_x) == 0)
                                        {
                                            ds_list_set(vertex_x, 0, 0);
                                            ds_list_set(vertex_y, 0, 0);
                                            ds_list_set(vertex_z, 0, 0);
                                        }
                                        break;
                                    case 1:
                                        if (ds_list_size(vertex_xtex) == 0)
                                        {
                                            ds_list_set(vertex_xtex, 0, 0);
                                            ds_list_set(vertex_ytex, 0, 0);
                                        }
                                        break;
                                    case 2:
                                        if (ds_list_size(vertex_nx) == 0)
                                        {
                                            ds_list_set(vertex_nx, 0, 0);
                                            ds_list_set(vertex_ny, 0, 0);
                                            ds_list_set(vertex_nz, 0, 0);
                                        }
                                        break;
                                }
                            }
                        }
                        var xx = ds_list_find_value(vertex_x, real(data[0]) - 1);
                        var yy = ds_list_find_value(vertex_y, real(data[0]) - 1);
                        var zz = ds_list_find_value(vertex_z, real(data[0]) - 1);
                        var xtex = ds_list_find_value(vertex_xtex, real(data[1]) - 1);
                        var ytex = ds_list_find_value(vertex_ytex, real(data[1]) - 1);
                        var nx = ds_list_find_value(vertex_nx, real(data[2]) - 1);
                        var ny = ds_list_find_value(vertex_ny, real(data[2]) - 1);
                        var nz = ds_list_find_value(vertex_nz, real(data[2]) - 1);
                        var color = c_white;
                        var alpha = 1;
                        if (ds_map_exists(mtl_color, active_mtl))
                        {
                            color = ds_map_find_value(mtl_color, active_mtl);
                        }
                        if (ds_map_exists(mtl_alpha, active_mtl))
                        {
                            alpha = ds_map_find_value(mtl_alpha, active_mtl);
                        }
                        var t = yy;
                        yy = zz;
                        zz = t;
                        ytex = 1 - ytex;
                        vertex_position_3d(model, xx, yy, zz);
                        vertex_normal(model, nx, ny, nz);
                        vertex_color(model, color, alpha);
                        vertex_texcoord(model, xtex, ytex);
                    }
                }
                break;
            case "usemtl":
                active_mtl = terms[1];
                break;
            default:
                break;
        }
    }
    vertex_end(model);
    ds_list_destroy(vertex_x);
    ds_list_destroy(vertex_y);
    ds_list_destroy(vertex_z);
    ds_list_destroy(vertex_nx);
    ds_list_destroy(vertex_ny);
    ds_list_destroy(vertex_nz);
    ds_list_destroy(vertex_xtex);
    ds_list_destroy(vertex_ytex);
    ds_map_destroy(mtl_alpha);
    ds_map_destroy(mtl_color);
    file_text_close(obj_file);
    file_text_close(mtl_file);
    return model;
}

function draw_floor()
{
    vertex_submit(ground, pr_trianglelist, sprite_get_texture(spr_cubetex, 0));
}

function start3d(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8 = -1, arg9 = -1, arg10 = false, arg11 = 0, arg12 = 0, arg13 = 1, arg14 = -4)
{
    static surf = -1;
    
    master.viewport3d = arg0;
    if (arg14 == -4)
    {
        arg14 = -window_get_width() / window_get_height();
    }
    view_enabled = true;
    view_visible[arg0] = true;
    view_set_camera(arg0, camera_create());
    camera_set_proj_mat(view_camera[arg0], matrix_build_projection_perspective_fov(-arg7, arg14, 1, 32000));
    camera_set_view_mat(view_camera[arg0], matrix_build_lookat(arg1, arg2, arg3, arg4, arg5, arg6, arg11, arg12, arg13));
    if (arg8 == -1 || arg9 == -1)
    {
        arg8 = get_screen_width();
        arg9 = get_screen_height();
    }
    gpu_set_ztestenable(true);
    gpu_set_zwriteenable(true);
    if (arg10)
    {
        gpu_set_tex_mip_enable(1);
    }
    else
    {
        gpu_set_tex_mip_enable(0);
    }
    gpu_set_cullmode(2);
    gpu_set_texrepeat(true);
    if (surface_exists(surf))
    {
        if (surface_get_width(surf) != arg8 || surface_get_height(surf) != arg9)
        {
            surface_resize(surf, arg8, arg9);
        }
    }
    else
    {
        surf = surface_create(arg8, arg9);
    }
    surface_set_target(surf);
    draw_clear_alpha(c_black, 0);
    camera_apply(view_camera[arg0]);
    surface3d = surf;
}

function draw3dobject(_x, _y, _z, xrotation, yrotation, zrotation, _xscale, _yscale, _zscale, object3d, _shader = sh_smf_animate, customFunction = -1)
{
	shader_set(_shader);
    if (customFunction != -1)
        customFunction();
    matrix_set(2, matrix_build(_x, _y, _z, xrotation, yrotation, zrotation, _xscale, _yscale, _zscale));
	object3d._draw();
    matrix_set(2, matrix_build_identity());
    shader_reset();
}

function end3d(arg0 = 0, arg1 = 0, arg2 = 1)
{
    surface_reset_target();
    gpu_set_ztestenable(false);
    gpu_set_zwriteenable(false);
    gpu_set_tex_mip_enable(0);
    gpu_set_cullmode(0);
    gpu_set_texrepeat(false);
    if (camera_get_active() != view_camera[0])
    {
        view_visible[master.viewport3d] = false;
        view_enabled = false;
    }
    if (arg2 == 1)
    {
        draw_surface(surface3d, arg0, arg1);
    }
    else
    {
        draw_surface_ext(surface3d, arg0 + surface_get_width(surface3d), arg1, arg2, 1, 0, c_white, 1);
    }
}

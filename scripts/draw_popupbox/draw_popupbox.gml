function draw_popupbox(arg0, arg1, arg2 = 221, arg3 = 128)
{
    arg0 = floor(arg0);
    arg1 = floor(arg1);
    arg2 = floor(arg2);
    arg3 = floor(arg3);
    var _backspr = spr_popupbox1;
    var _backwid = arg2 / sprite_get_width(_backspr);
    var _backhei = arg3 / sprite_get_height(_backspr);
    draw_sprite_ext(_backspr, 0, arg0, arg1, _backwid, _backhei, 0, c_white, 1);
    blendmode_set_multiply();
    draw_sprite_ext(spr_popupbox2MULT, 0, arg0, arg1, _backwid, _backhei, 0, c_white, 1);
    blendmode_reset();
    var faces_x = arg0 + 1;
    var faces_y = arg1 + 1;
    var faces_w = arg2 / sprite_get_width(spr_popupbox3OVERLAY);
    var faces_h = arg3 / sprite_get_height(spr_popupbox3OVERLAY);
    blendmode_set_overlay();
    draw_sprite_ext(spr_popupbox3OVERLAY, 0, faces_x, faces_y, faces_w, faces_h, 0, c_white, 1);
    blendmode_reset();
}

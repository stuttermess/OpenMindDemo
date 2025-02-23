x += xmod;
y += ymod;
var _al = image_alpha;
image_alpha = 1;
draw_self();
image_alpha = _al;
x -= xmod;
y -= ymod;
if (image_alpha < 1)
{
    exit;
}
var _fnt = draw_get_font();
var _halign = draw_get_halign();
var _valign = draw_get_valign();
draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_text(x, y + (sprite_height / 2) + 5, artist_name);
draw_set_font(_fnt);
draw_set_halign(_halign);
draw_set_valign(_valign);

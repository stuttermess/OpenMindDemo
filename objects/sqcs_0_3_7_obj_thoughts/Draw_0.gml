active = true;
mwsc.draw(x, y);
if (!ended && mwsc.current_letter >= string_length(mwsc.text))
{
    var tx = x + (mwsc.textbox.text_space_width / 2) + 9 + 3;
    var ty = y + (mwsc.textbox.text_space_height / 2) + 5 + 3;
    draw_sprite(spr_cutscene_textbox_arrow, 0, tx, ty);
}
draw_sprite_ditherfaded(spr_480_clipmask, 0, 240, 135, ditherfade, 1, 1, 0, 0, 1);

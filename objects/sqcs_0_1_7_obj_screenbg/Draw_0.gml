if (!cutscene_controller.cutscene.current_event.user_paused && !drawn)
{
    t++;
    drawn = true;
}
var yy = y;
y -= ((t * 0.5) % sprite_height);
draw_self();
y += sprite_height;
draw_self();
y = yy;

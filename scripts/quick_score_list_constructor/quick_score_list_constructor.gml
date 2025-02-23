function quick_score_list_constructor() : menu_constructor() constructor
{
    local_only = false;
    score_amount = 3;
}

function draw_quick_score_list(arg0, arg1, arg2)
{
    draw_set_color(c_white);
    draw_set_valign(fa_middle);
    var _fnt = draw_get_font();
    draw_set_font(fnt_pinch);
    var _scores = arg2;
    var _width = 100;
    if (_scores != undefined)
    {
        for (var i = 0; i < 3; i++)
        {
            var drawx = arg0;
            var drawy = arg1 + (35 * (i - 1));
            var _score = 0;
            if (array_length(_scores) > i)
            {
                _score = _scores[i];
            }
            var _rank_x = drawx - (_width / 2);
            var _rank_str = "#" + string(i + 1);
            var _score_x = drawx + (_width / 2);
            var _score_str = string(_score);
            if (_score == 0)
            {
                _score_str = "--";
            }
            var _txt_style = 
            {
                splitfill: 
                {
                    top_color: 16777215,
                    bottom_color: 16777215,
                    outline_top_color: 0,
                    outline_bottom_color: 0,
                    y_threshold: 0.25
                },
                outline: 
                {
                    width: 2,
                    color: 0,
                    extra_layers_amount: 0,
                    layers: [
                    {
                        color: 16711680,
                        width: 1,
                        smooth: false
                    }]
                }
            };
            with (_txt_style.splitfill)
            {
                switch (i)
                {
                    case 0:
                        bottom_color = 913151;
                        outline_top_color = 4945;
                        break;
                    case 1:
                        bottom_color = 13412732;
                        outline_top_color = 6764592;
                        break;
                    case 2:
                        bottom_color = 5129884;
                        outline_top_color = 6764592;
                        break;
                }
            }
            var _scale = 1;
            draw_set_halign(fa_left);
            draw_text_special(_rank_x, drawy, _rank_str, _txt_style, _scale, _scale, 0);
            draw_set_halign(fa_right);
            draw_text_special(_score_x, drawy, _score_str, _txt_style, _scale, _scale, 0);
        }
    }
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(_fnt);
}

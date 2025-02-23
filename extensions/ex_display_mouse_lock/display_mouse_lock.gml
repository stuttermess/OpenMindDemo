#define display_mouse_bounds
/// @description  (): Returns the current mouse' lock bounds (if any).
if (display_mouse_bounds_raw(4)) {
	var r, i = 4;
	while (--i >= 0) r[i] = display_mouse_bounds_raw(i);
	return r;
} else return undefined;


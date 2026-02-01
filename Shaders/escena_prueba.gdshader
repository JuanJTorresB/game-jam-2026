shader_type canvas_item;

uniform float spotlight_x : hint_range(0.0, 1.0, 0.1);
uniform float spotlight_y : hint_range(0.0, 1.0, 0.1);
uniform float spotlight_w : hint_range(0.0, 1.0, 0.1);
uniform float spotlight_h : hint_range(0.0, 1.0, 0.1);

void vertex() {

	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	float dx = (UV.x - spotlight_x) / spotlight_w;
	float dy = (UV.y - spotlight_y) / spotlight_h;
	float d = sqrt((dx * dx) + (dy * dy));
	COLOR = vec4(0, 0, 0, (max(0, abs(d) - 0.1) / .1));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

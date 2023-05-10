extends Object

class_name SpriteUtils

static func flash(canvas_item : CanvasItem, cycles : int = 5, dark_frames : int = 4, light_frames : int = 4):
	var before = canvas_item.modulate
	var white = Color(100, 100, 100)
	var tree = canvas_item.get_tree()
	for _cycle in range(cycles):
		canvas_item.modulate = white
		for _frame in range(light_frames): yield(tree, "idle_frame")
		canvas_item.modulate = before
		for _frame in range(dark_frames): yield(tree, "idle_frame")
	canvas_item.modulate = before

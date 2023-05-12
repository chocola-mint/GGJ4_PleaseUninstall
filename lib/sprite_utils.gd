extends Object

class_name SpriteUtils

static func flash(canvas_item : CanvasItem, cycles : int = 5, dark_frames : int = 4, light_frames : int = 4) -> SceneTreeTween:
	var before = canvas_item.modulate
	var white = Color(100, 100, 100)
	var tree = canvas_item.get_tree()
	var tween = tree.create_tween().bind_node(canvas_item).set_loops(cycles)
	tween.tween_callback(canvas_item, "set_modulate", [white]).set_delay(light_frames * 1.0/60.0)
	tween.tween_callback(canvas_item, "set_modulate", [before]).set_delay(dark_frames * 1.0/60.0)
	return tween

#static func flash_self(canvas_item : CanvasItem, cycles : int = 5, dark_frames : int = 4, light_frames : int = 4) -> SceneTreeTween:
#	var before = canvas_item.self_modulate
#	var white = Color(100, 100, 100)
#	var tree = canvas_item.get_tree()
#	var tween = tree.create_tween().bind_node(canvas_item).set_loops(cycles)
#	tween.tween_callback(canvas_item, "set_self_modulate", [white]).set_delay(light_frames * 1.0/60.0)
#	tween.tween_callback(canvas_item, "set_self_modulate", [before]).set_delay(dark_frames * 1.0/60.0)
#	return tween

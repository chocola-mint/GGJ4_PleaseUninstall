extends Node2D

class_name Level

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal level_end

func start_level():
	_level_script()

func _level_script():
	pass

func _mark_level_end():
	emit_signal("level_end")

func _handle_wave(wave_scene : Resource):
	var wave : Wave = wave_scene.instance() as Wave
	add_child(wave)
	wave.start_wave()
	yield(wave, "wave_end")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

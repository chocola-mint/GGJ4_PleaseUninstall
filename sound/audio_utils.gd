extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Internal class used to play one shot.
# Will self-destruct when it's done playing.
class InstancedAudioPlayer extends AudioStreamPlayer2D:
	# Called when the node enters the scene tree for the first time.
	func _ready():
		var err = connect("finished", self, "_cleanup")
		assert(not err)
	func _cleanup():
		queue_free()
# Plays the given audio stream at the given global position 
# Default position is center of the screen
func play_one_shot(audio_stream : AudioStream, global_position = Vector2.ZERO):
	var instance = InstancedAudioPlayer.new()
	get_tree().root.add_child(instance)
	instance.global_position = global_position
	instance.stream = audio_stream
	instance.play()


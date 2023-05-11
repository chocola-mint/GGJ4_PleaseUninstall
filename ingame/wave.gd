extends Node2D

class_name Wave

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var __ : Enemy

signal wave_end

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# [VIRTUAL]
func start_wave():
	pass

func end_wave(kill_all : bool = false):
	if kill_all:
		var enemy : Enemy
		# Kill all enemies
		for node in get_tree().get_nodes_in_group("enemies"):
			if is_instance_valid(node):
				enemy = node as Enemy
				enemy.stats.kill()
		# Wait for them to despawn
		for node in get_tree().get_nodes_in_group("enemies"):
			if is_instance_valid(node):
				enemy = node as Enemy
				yield(node, "tree_exited")
	emit_signal("wave_end")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

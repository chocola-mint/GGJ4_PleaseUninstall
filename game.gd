extends Node

class_name Game

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player : Player = $"%Player"
onready var weapon_list_t0 = [
	preload("res://player/PincerShooter.tscn"),
	preload("res://player/PincerShooter_Var1.tscn"),
	preload("res://player/PincerShooter_Var2.tscn"),
	preload("res://player/PincerShooter_Var3.tscn"),
]
onready var level_list = [
	preload("res://ingame/Level1.tscn")
]
var current_level : Level

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.player = player
	player.add_weapon(weapon_list_t0[0])
	player.add_weapon(weapon_list_t0[1])
	player.add_weapon(weapon_list_t0[2])
	player.add_weapon(weapon_list_t0[3])
	var tween = get_tree().create_tween().bind_node(self).set_loops()
	tween.tween_callback(self, "_add_weapon", [weapon_list_t0]).set_delay(5.0)
	_start_level(0)
		
func _start_level(idx : int):
	current_level = level_list[idx].instance()
	add_child(current_level)
	current_level.start_level()
# Returns whether a weapon is added successfully.
# Basically, false when no weapon can be added.
func _add_weapon(list : Array):
	var filtered = []
	for weapon in list:
		if not player.has_weapon(weapon):
			filtered.append(weapon)
	if filtered.empty(): return false
	else:
		player.add_weapon(filtered[randi() % filtered.size()])
		return true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

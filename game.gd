extends Node

class_name Game

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player : Player = $"%Player" as Player
onready var weapon_list_t0 = [
	preload("res://player/PincerShooter.tscn"),
	preload("res://player/PincerShooter_Var1.tscn"),
	preload("res://player/PincerShooter_Var2.tscn"),
	preload("res://player/PincerShooter_Var3.tscn"),
]

# Called when the node enters the scene tree for the first time.
func _ready():
	while true:
		yield(get_tree().create_timer(1.5), "timeout")
		_add_weapon(weapon_list_t0)
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

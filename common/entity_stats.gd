extends Node

class_name EntityStats

export(float, 1, 10000) var health = 100.0

signal on_zero_health

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var max_health = health


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func inflict_damage(amount : float):
	if is_zero_health(): return
	health = clamp(health - amount, 0, max_health)
	if is_zero_health(): emit_signal("on_zero_health")

func heal(amount : float):
	health = clamp(health + amount, 0, max_health)

func get_health_view_int() : return int(ceil(health))

func get_health_ratio() : return health / max_health
	
func is_zero_health(): return is_zero_approx(health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

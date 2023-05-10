extends EntityStats

class_name PlayerStats

export(float, 0, 1) var power = 0.5
export(float, 0.001, 1) var power_regen_tick = 0.05
export(float, 0.001, 0.2) var power_regen_per_tick = 0.01

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var tree = get_tree()
var time = 0
var next_regen_power_time = power_regen_tick

func _ready():
	pass

func _process(delta):
	if time >= next_regen_power_time:
		power = min(power + power_regen_per_tick, 1.0)
		next_regen_power_time += power_regen_tick
	time += delta

func consume_power(amount: float):
	power = clamp(power - amount, 0.0, 1.0)

func is_low_power(): return power < 0.5

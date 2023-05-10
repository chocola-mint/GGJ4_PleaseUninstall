extends EntityStats

class_name PlayerStats

export(float, 0, 1) var power = 0.5
export(float, 0.001, 1) var power_regen_tick = 0.05
export(float, 0.001, 0.2) var power_regen_per_tick = 0.01

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	_regen_power()

func _regen_power():
	var tree = get_tree()
	while true:
		yield(tree.create_timer(power_regen_tick), "timeout")
		power = min(power + power_regen_per_tick, 1.0)

func consume_power(amount: float):
	power = clamp(power - amount, 0.0, 1.0)

func is_low_power(): return power < 0.5

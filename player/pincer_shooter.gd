extends Weapon
export(Resource) var missile_kit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _spawn_bullet():
	if Input.is_action_pressed("focus"):
		Bullets.spawn_bullet(missile_kit, {
			"target_node": GameManager.target,
			"transform": shoot_anchor.global_transform,
			"velocity": Vector2(bullet_speed * 0.45, 0),
			"lifetime": 10.0,
			"data": {
				"damage": 1.0
			}
		})
	else:
		Bullets.spawn_bullet(bullet_kit, {
			"transform": shoot_anchor.global_transform,
			"velocity": Vector2(bullet_speed, 0),
			"lifetime": 10.0,
			"data": {
				"damage": 1.0
			}
		})

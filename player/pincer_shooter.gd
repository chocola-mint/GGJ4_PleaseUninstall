extends Weapon
export(Resource) var missile_kit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	BulletPincerSub.uniform_speed = bullet_speed / 2
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _spawn_bullet():
	if Input.is_action_pressed("focus"):
		Meta.assign(
			BulletPincerSub.spawn(
				shoot_anchor.global_position, 
				Vector2.RIGHT), { Meta.damage: 1.0 })
	else:
		Meta.assign(
			BulletPincerMain.spawn(
				shoot_anchor.global_position + Vector2.UP * 5,
				Vector2.RIGHT,
				bullet_speed), { Meta.damage: 2.0 })
		Meta.assign(
			BulletPincerMain.spawn(
				shoot_anchor.global_position + Vector2.DOWN * 5,
				Vector2.RIGHT,
				bullet_speed), { Meta.damage: 2.0 })

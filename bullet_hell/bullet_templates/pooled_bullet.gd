extends Area2D
class_name PooledBullet

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var hitbox_shape : CollisionShape2D = $"%HitboxShape"
var is_alive = false
# Active if:
# - is alive
# - not alive, but kill tween is running
func is_active() -> bool:
	return visible
# Called when the node enters the scene tree for the first time.
func _ready():
	_go_inactive()
func wake_up():
	hitbox_shape.set_deferred("disabled", false)
func kill():
	if is_alive:
		is_alive = false
		hitbox_shape.set_deferred("disabled", true)
		var tween = create_tween()
		var __ = tween.tween_property(self, "modulate:a", 0.0, 0.5)
		__ = tween.tween_callback(self, "_go_inactive")
func _go_inactive():
	visible = false
	hitbox_shape.set_deferred("disabled", true)
	modulate.a = 1
func cull():
	is_alive = false
	_go_inactive()

func _on_area_entered(_area):
	kill()

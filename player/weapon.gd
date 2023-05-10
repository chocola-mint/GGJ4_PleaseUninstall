extends Node2D

class_name Weapon

export var fall_time = 1.5
export(Resource) var bullet_kit
export(float, 0, 1000) var bullet_speed = 500.0
export(float, 0, 3) var cooldown = 0.1
export(float, 0.0001, 0.5) var power_cost = 0.001
export(Vector2) var weapon_head_motion_amplitude = Vector2(5.0, 5.0)
export(Vector2) var weapon_head_motion_frequency = Vector2(-5.0, -5.0)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var weapon_head = $"%WeaponHead" as Node2D
onready var weapon_head_initial_position = weapon_head.position
onready var shoot_anchor = $"%ShootAnchor" as Node2D
onready var last_shoot_time = 0
onready var time = 0
onready var hitbox_shape = $"%HitboxShape" as CollisionShape2D
var _is_ready = false


# Called when the node enters the scene tree for the first time.
func _ready():
	_show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	weapon_head.position = weapon_head_initial_position + Vector2(
		cos(time * weapon_head_motion_frequency.x) * weapon_head_motion_amplitude.x,
		sin(time * weapon_head_motion_frequency.y) * weapon_head_motion_amplitude.y
	)

func _show():
	hitbox_shape.set_deferred("disabled", true)
	var tween = create_tween()
	var final_modulate = modulate
	var flash = Color(209 / 255.0 * 50, 253 / 255.0 * 80, 255 / 255.0 * 400, 0.5)
	modulate = Color(1.0, 1.0, 1.0, 0.0)
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "modulate", flash, 0.5)
	
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate", final_modulate, 0.25)
	tween.tween_callback(self, "_set_ready")

func _set_ready():
	_is_ready = true
	hitbox_shape.set_deferred("disabled", false)

func shoot():
	if time - last_shoot_time > cooldown and _is_ready:
		last_shoot_time = time
		Bullets.spawn_bullet(bullet_kit, {
			"transform": shoot_anchor.global_transform,
			"velocity": Vector2(bullet_speed, 0),
			"lifetime": 10.0,
			"data": {
				"damage": 1.0
			}
		})

var _uninstalling = false
func uninstall():
	if _uninstalling: return
	_uninstalling = true
	hitbox_shape.queue_free()
	var viewport_rect = get_viewport_rect()
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "position:y", 
		position.y + (viewport_rect.position.y + viewport_rect.size.y), 
		fall_time)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(self, "position:x", position.x - viewport_rect.size.x * 0.2, fall_time)
	tween.tween_callback(self, "queue_free") # Cleanup
	yield(SpriteUtils.flash(self, 2, 8, 8), "completed")
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "modulate", Color(0, 0, 0, 0), 1.0)


func _on_Hitbox_area_entered(_area):
	uninstall()

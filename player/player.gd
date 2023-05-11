extends Node2D

class_name Player

export(float, 0, 200) var move_speed = 60.0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var stats : PlayerStats = $"%Stats"
onready var body : KinematicBody2D = $"%Body"
onready var weapons = $"%Weapons"
onready var hurtbox_shape : CollisionShape2D = $"%HurtboxShape"
onready var hurtbox_highlight = $"%HurtboxHighlight"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("shoot"):
		shoot()
	hurtbox_highlight.set_highlight(Input.is_action_pressed("focus"))
	_cleanup_tick()
var enable_cleanup : bool = false
func _cleanup_tick():
	if enable_cleanup:
		if not hurt_invul_active:
			queue_free()

func _physics_process(_delta):
	move(Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")))

func add_weapon(weapon_scene : PackedScene):
	weapons.add_child(weapon_scene.instance())

func has_weapon(weapon_scene : PackedScene):
	for child in weapons.get_children():
		if weapon_scene.resource_path == child.filename:
			return true
	return false

func shoot():
	var children = weapons.get_children()
	for child in children:
		var weapon : Weapon = child as Weapon
		if weapon:
			if stats.is_low_power() and rand_range(0.0, 1.0) > stats.power:
				if weapon.can_shoot():
					stats.consume_power(weapon.power_cost * len(children))
			else:
				if weapon.shoot():
					stats.consume_power(weapon.power_cost * len(children))

func move(vec: Vector2):
#	var is_move_x = abs(vec.x) > 0.001
#	var is_move_y = abs(vec.y) > 0.001
#	if is_move_x: vec.x = sign(vec.x)
#	if is_move_y: vec.y = sign(vec.y)
#	if is_move_x and is_move_y: vec *= 0.707
	var _velocity = body.move_and_slide(_get_move_speed() * vec)
	var viewport_size = get_viewport_rect().size / 2
	body.global_position.x = clamp(body.global_position.x, -viewport_size.x, viewport_size.x)
	body.global_position.y = clamp(body.global_position.y, -viewport_size.y, viewport_size.y)
	pass

func _get_move_speed():
	if Input.is_action_pressed("focus"): return move_speed / 2.0
	else: return move_speed

func _on_area_shape_entered(area_id, _area, area_shape, _local_shape):
	if not Bullets.is_bullet_existing(area_id, area_shape):
		# The colliding area is not a bullet, returning.
		return
	# Get a BulletID from the area_shape passed in by the engine.
	var bullet_id = Bullets.get_bullet_from_shape(area_id, area_shape)
	# Get bullet properties, transform, velocity, lifetime etc.
#	var bullet_transform : Transform2D = Bullets.get_bullet_property(bullet_id, "transform")
	# custom data: damage
#	var bullet_damage : float = Bullets.get_bullet_property(bullet_id, "data").damage
	var bullet_damage = 1
	# You can also retrieve the BulletKit that generated the bullet and get/set its properties.
#	var kit_collision_shape = Bullets.get_kit_from_bullet(bullet_id).collision_shape
	# Remove the bullet, call_deferred is necessary because the Physics2DServer is in its flushing state during callbacks.
	Bullets.call_deferred("release_bullet", bullet_id)
	handle_hurt(bullet_damage)

var hurt_invul_active = false
func handle_hurt(damage : float):
	if hurt_invul_active or damage <= 0: return
	hurt_invul_active = true
	stats.inflict_damage(damage)
	var _tween = SpriteUtils.flash(self, 1).tween_callback(self, 
	"_turn_off_hurt_invul")
func _turn_off_hurt_invul(): hurt_invul_active = false


func _on_zero_health():
	hurtbox_shape.queue_free()
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "modulate", Color(modulate.r, modulate.g, modulate.b, 0), 0.7)
	enable_cleanup = true

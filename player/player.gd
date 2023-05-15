extends Node2D

class_name Player

export(float, 0, 200) var move_speed = 120.0
export(Curve) var weapon_count_cost_multiplier : Curve
export(int, 1, 10) var weapon_count_cost_limit = 4

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var stats : PlayerStats = $"%Stats"
onready var body : KinematicBody2D = $"%Body"
onready var animated_sprite : AnimatedSprite = $"%AnimatedSprite"
onready var weapons : Node2D = $"%Weapons"
onready var hurtbox_shape : CollisionShape2D = $"%HurtboxShape"
onready var hurtbox_highlight : Sprite = $"%HurtboxHighlight"
onready var trail_particles : CPUParticles2D = $"%TrailParticles"

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
			pass # TODO: Respawn?

func _physics_process(_delta):
	if stats.health > 0:
		move(Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")))

func add_weapon(weapon_scene : PackedScene, check : bool = false):
	if check: if has_weapon(weapon_scene): return
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
			if stats.is_low_power() and rand_range(0.0, 1.0) > pow(stats.power, 1.0):
				if weapon.shoot_dud():
					stats.consume_power(weapon.power_cost * _compute_power_cost(weapon, weapons.get_child_count()))
			else:
				if weapon.shoot():
					stats.consume_power(weapon.power_cost * _compute_power_cost(weapon, weapons.get_child_count()))

func _compute_power_cost(weapon : Weapon, weapon_count : float):
	return weapon.power_cost * weapon_count_cost_multiplier.interpolate(clamp(weapon_count / weapon_count_cost_limit, 0.0, 1.0))

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

func _on_area_shape_entered(_area_id, area : Area2D, _area_shape, _local_shape):
	var bullet_damage : float = area.get_meta(Meta.damage, -1.0)
	if bullet_damage >= 0:
		handle_hurt(bullet_damage)

var hurt_invul_active = false
func handle_hurt(damage : float):
	if hurt_invul_active or damage <= 0: return
	hurt_invul_active = true
	AudioUtils.play_one_shot(preload("res://sound/player_hit.wav"), global_position)
	stats.inflict_damage(damage)
	var _tween = SpriteUtils.flash(animated_sprite, 4)
	_tween = create_tween().tween_callback(self, 
	"_turn_off_hurt_invul").set_delay(0.5)
func _turn_off_hurt_invul(): hurt_invul_active = false

func uninstall_all_weapons(delay : float = 0.0):
	for child in weapons.get_children():
		var weapon : Weapon = child as Weapon
		if delay > 0.0:
			var tween = weapon.create_tween()
			tween.tween_callback(weapon, "uninstall").set_delay(weapon.get_index() * delay)
		else: weapon.uninstall()

func _on_zero_health():
	# SFX
	AudioUtils.play_one_shot(preload("res://sound/Death  New.wav"), global_position)
	
	# Particles
	for i in range(0, 3):
		var copy : CPUParticles2D = $"%DeathParticles".duplicate()
		add_child(copy)
		copy.global_position = body.global_position
		copy.amount += int(round(5.0 * pow(i, 1.5)))
# warning-ignore:return_value_discarded
		copy.create_tween().tween_callback(copy, "restart").set_delay(pow(i, 1.5) * 0.2)
	
	# Hurtbox
	hurtbox_shape.set_deferred("disabled", true)
	hurtbox_highlight.visible = false
	
	# Disable trail particles
	trail_particles.emitting = false
	
	# Weapons
	uninstall_all_weapons(0.1)
	
	# Fade
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(self, "modulate", Color(1.0, 0.0, 0.0, 0), 2.0)
	animated_sprite.play("knockout")
	tween.tween_callback(self, "_set_enable_cleanup", [true])
	# Shake
	tween = create_tween()
	tween.set_loops(16)
	tween.tween_callback(self, "set_position", [Vector2.UP]).set_delay(0.02)
	tween.tween_callback(self, "set_position", [Vector2.DOWN]).set_delay(0.02)
	tween.tween_callback(self, "set_position", [Vector2.LEFT]).set_delay(0.02)
	tween.tween_callback(self, "set_position", [Vector2.RIGHT]).set_delay(0.02)
	tween.tween_callback(self, "set_position", [Vector2.ZERO]).set_delay(0.02)
	# Fall
	tween = create_tween()
	tween.tween_callback(self, "_pass").set_delay(0.4)
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", Vector2(-80, 300), 2.0)
	# Game over overlay after fall
	tween.tween_callback(self, "emit_signal", ["game_over"])
	

func _set_enable_cleanup(val : bool): enable_cleanup = val
func _pass(): pass

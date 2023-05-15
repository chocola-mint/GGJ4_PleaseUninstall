extends Node2D

class_name Enemy

export(int, 0, 100000) var score_yield = 500

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var stats : EntityStats = $"%Stats"
onready var death_particles : CPUParticles2D = $"%DeathParticles"
onready var body : KinematicBody2D = $"%Body"
onready var hitbox_shape : CollisionShape2D = $"%HitboxShape"
onready var hurtbox_shape : CollisionShape2D = $"%HurtboxShape"
onready var bullet_spawner : BulletsSpawner = $"%BulletsSpawner"
var score_yield_on_hit = 10
var prev_pos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	prev_pos = global_position
	add_to_group("enemies")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	_cleanup_tick()
	if global_position.x - prev_pos.x > 0:
		$"Body/AnimatedSprite".scale = Vector2(-1, 1)
	elif global_position.x - prev_pos.x < 0: $"Body/AnimatedSprite".scale = Vector2(1, 1)
	prev_pos = global_position

onready var enable_cleanup : bool = false
func _cleanup_tick():
	if enable_cleanup:
		if not (death_particles.emitting):
			queue_free()

func _on_area_shape_entered(_area_id, area : Area2D, _area_shape, _local_shape):
	var bullet_damage : float = area.get_meta(Meta.damage, -1.0)
	if bullet_damage >= 0:
		handle_hurt(bullet_damage)
#	if not Bullets.is_bullet_existing(area_id, area_shape):
#		# The colliding area is not a bullet, returning.
#		return
#	# Get a BulletID from the area_shape passed in by the engine.
#	var bullet_id = Bullets.get_bullet_from_shape(area_id, area_shape)
#	# Get bullet properties, transform, velocity, lifetime etc.
##	var bullet_transform : Transform2D = Bullets.get_bullet_property(bullet_id, "transform")
#	# custom data: damage
#	var data = Bullets.get_bullet_property(bullet_id, "data")
#	var bullet_damage : float = 1
#	if data: bullet_damage = data.damage
#	# You can also retrieve the BulletKit that generated the bullet and get/set its properties.
##	var kit_collision_shape = Bullets.get_kit_from_bullet(bullet_id).collision_shape
#	# Remove the bullet, call_deferred is necessary because the Physics2DServer is in its flushing state during callbacks.
#	Bullets.call_deferred("release_bullet", bullet_id)
#	handle_hurt(bullet_damage)

var _flash_tween : SceneTreeTween = null
func handle_hurt(damage : float):
	AudioUtils.play_one_shot(preload("res://sound/enemy_hit.wav"), global_position)
	GameManager.score += score_yield_on_hit 
	stats.inflict_damage(damage)
	if stats.is_zero_health():
		GameManager.score += score_yield
	if _flash_tween and _flash_tween.is_running(): return
	_flash_tween = SpriteUtils.flash(self, 1)

func _on_zero_health():
	death_particles.restart()
	hitbox_shape.queue_free()
	hurtbox_shape.queue_free()
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "modulate", Color(modulate.r, modulate.g, modulate.b, 0), 0.7)
	enable_cleanup = true
	
func _on_tree_exiting():
	remove_from_group("enemies")

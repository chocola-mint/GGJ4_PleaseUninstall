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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_area_shape_entered(area_id, _area, area_shape, _local_shape):
	if not Bullets.is_bullet_existing(area_id, area_shape):
		# The colliding area is not a bullet, returning.
		return
	# Get a BulletID from the area_shape passed in by the engine.
	var bullet_id = Bullets.get_bullet_from_shape(area_id, area_shape)
	# Get bullet properties, transform, velocity, lifetime etc.
#	var bullet_transform : Transform2D = Bullets.get_bullet_property(bullet_id, "transform")
	# custom data: damage
	var bullet_damage : float = Bullets.get_bullet_property(bullet_id, "data").damage
	# You can also retrieve the BulletKit that generated the bullet and get/set its properties.
#	var kit_collision_shape = Bullets.get_kit_from_bullet(bullet_id).collision_shape
	# Remove the bullet, call_deferred is necessary because the Physics2DServer is in its flushing state during callbacks.
	Bullets.call_deferred("release_bullet", bullet_id)
	handle_hurt(bullet_damage)

var hurt_invul_active = false
func handle_hurt(damage : float):
	if hurt_invul_active: return
	GameManager.score += 10
	hurt_invul_active = true
	stats.inflict_damage(damage)
	yield(SpriteUtils.flash(self, 1), "completed")
	hurt_invul_active = false


func _on_zero_health():
	GameManager.score += score_yield
	death_particles.restart()
	hitbox_shape.queue_free()
	hurtbox_shape.queue_free()
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "modulate", Color(modulate.r, modulate.g, modulate.b, 0), 0.7)
	var tree = get_tree()
	while death_particles.emitting or hurt_invul_active:
		yield(tree, "idle_frame")
	queue_free()

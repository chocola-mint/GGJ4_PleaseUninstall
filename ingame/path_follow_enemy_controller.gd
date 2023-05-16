extends PathFollow2D

class_name PathFollowEnemyController

export(float, 1, 1000) var move_speed = 50.0
export(PackedScene) var enemy_scene
export(float, 1, 1000) var bullet_speed = 150.0
export(int, 0, 2) var bullet_id
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var enemy : Enemy
var is_started = false
var enabled = true
func start():
	if is_started: return
	is_started = true
	enemy = enemy_scene.instance()
	add_child(enemy)
	var _err = enemy.stats.connect("on_zero_health", self, "disable")
	assert(not _err)
	exec_script()
func disable(): enabled = false
func exec_script():
	var tween = enemy.create_tween()
	tween.set_loops()
	tween.tween_callback(self, "_shoot").set_delay(1.5)
func _shoot():
	var main_anchor = enemy.get_main_anchor()
	[BulletEnemyRedLemonA, BulletEnemyBlueLemonA][bullet_id].spawn(
		main_anchor.global_position,
		(GameManager.player.body.global_position - main_anchor.global_position).normalized(),
		bullet_speed
	).set_meta(Meta.damage, 1)
func _pass():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_started and enabled:
		offset += delta * move_speed
		if is_equal_approx(unit_offset, 1.0):
			queue_free()

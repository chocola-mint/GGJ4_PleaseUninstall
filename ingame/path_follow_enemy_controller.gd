extends PathFollow2D
export(float, 1, 1000) var move_speed = 50.0
export(PackedScene) var enemy_scene
export(Resource) var bullet_kit
export(float, 1, 1000) var bullet_speed = 100.0
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
	enemy.bullet_spawner.bullet_kit = bullet_kit
	enemy.bullet_spawner.bullets_speed = bullet_speed
	enemy.bullet_spawner.enabled = true
	exec_script()
func disable(): enabled = false
func exec_script():
	var tween = get_tree().create_tween().bind_node(enemy).set_loops()
	tween.tween_callback(self, "_shoot").set_delay(1.0)
func _shoot():
	enemy.bullet_spawner.shoot(0.1)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_started and enabled:
		offset += delta * move_speed
		if is_equal_approx(unit_offset, 1.0):
			queue_free()

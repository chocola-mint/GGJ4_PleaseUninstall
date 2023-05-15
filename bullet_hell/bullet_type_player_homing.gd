extends BulletType

# Bullets will be killed after this amount of time.
export(float) var bullet_lifetime : float = 10.0

# [Pooled, per-bullet properties]
# (Remember to resize them in resize_pool)
var pool_start_time = PoolRealArray()
var pool_vel = PoolVector2Array()
func _resize_pooled_props(new_size : int):
	pool_start_time.resize(new_size)
	pool_vel.resize(new_size)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var target : Node2D = Node2D.new()
var uniform_speed : float = 100
var uniform_steer : float = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().root.call_deferred("add_child", target)
	pass # Replace with function body.

# <Virtual>
func spawn(
	spawn_pos : Vector2,
	shoot_direction : Vector2
	) -> PooledBullet:
	var bullet = _get_from_pool()
	var idx = bullet.get_index()
	bullet.visible = true
	bullet.is_alive = true
	bullet.global_position = spawn_pos
	pool_vel[idx] = shoot_direction * uniform_speed
	bullet.look_at(spawn_pos + shoot_direction)
	pool_start_time[idx] = time
	return bullet

# <Virtual>
func _process_bullets(delta : float):
	var i = 0
	var pool_size = get_child_count()
	while i < pool_size:
		# Optimization note: This is a hot path.
		var bullet : PooledBullet = get_child(i)
		# Skip dying/dead bullets.
		if bullet.is_alive: 
			# [Rect culling]
			if not culling_rect.has_point(bullet.global_position):
				bullet.cull()
			# [Lifetime killing]
			elif time - pool_start_time[i]  >= bullet_lifetime:
				bullet.kill()
			# [Alive script]
			else:
				var desired_vel = (target.global_position 
				- bullet.global_position).normalized() * uniform_speed
				var towards_desired_vel = (desired_vel - pool_vel[i]).normalized()
				pool_vel[i] += towards_desired_vel * delta * uniform_steer
				pool_vel[i] = pool_vel[i].normalized() * uniform_speed
				bullet.global_position += pool_vel[i] * delta
				bullet.global_rotation = pool_vel[i].angle()
		i += 1
	time += delta


func _physics_process(_delta):
	if is_instance_valid(GameManager.player):
		update_nearest_enemy()

func update_nearest_enemy():
	var closest_pos : Vector2 = Vector2(1000, 0)
	var closest_dist = INF
	for node in get_tree().get_nodes_in_group("enemies"):
		var enemy : Enemy = node
		if enemy.stats.is_zero_health(): continue
		var dist = enemy.global_position.distance_squared_to(GameManager.player.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest_pos = enemy.global_position
	target.position = closest_pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

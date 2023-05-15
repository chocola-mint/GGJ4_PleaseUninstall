extends BulletType

# Bullets will be killed after this amount of time.
export(float) var bullet_lifetime : float = 10.0
# [Pooled, per-bullet properties]
# (Remember to resize them in resize_pool)
var pool_start_time = PoolRealArray()
var pool_vel = PoolVector2Array()
func _resize_pooled_props(new_size : int):
	pool_vel.resize(new_size)
	pool_start_time.resize(new_size)

# <Virtual>
func spawn(
	spawn_pos : Vector2,
	shoot_direction : Vector2,
	speed : float
	) -> PooledBullet:
	var bullet = _get_from_pool()
	var idx = bullet.get_index()
	bullet.visible = true
	bullet.is_alive = true
	bullet.global_position = spawn_pos
	bullet.look_at(spawn_pos + shoot_direction)
	pool_start_time[idx] = time
	pool_vel[idx] = shoot_direction * speed
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
				bullet.global_position += pool_vel[i] * delta
		i += 1
	time += delta

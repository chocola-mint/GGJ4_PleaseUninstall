extends Node2D

class_name BulletType
# [Pool]
# The scene used for each bullet.
export(PackedScene) var bullet_template : PackedScene
# Bullets outside this rect will be culled.
export(Rect2) var culling_rect : Rect2 = Rect2(-160.0, -90.0, 640.0, 360.0)
# Set the initial size of the 
export(int) var initial_pool_size : int = 10
var POOL_EXPAND_FACTOR : float = 2.0
# [Pooled, per-bullet properties]
# (Remember to resize them in the method below)
# <Virtual>
# warning-ignore:unused_argument
func _resize_pooled_props(new_size : int):
	pass
# [Shared properties]
# Tick time (e.g., Unity's Time.time)
var time : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Apply initial pool size.
	resize_pool(initial_pool_size)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float):
	_process_bullets(delta)
func resize_pool(new_size : int):
	# Expand
	var i = get_child_count()
	while i < new_size:
		var instance = bullet_template.instance()
		add_child(instance)
		i += 1
	# Shrink
	while i > new_size:
		get_child(i).queue_free()
		i -= 1
	_resize_pooled_props(new_size)
# Uses cyclic scan (C-SCAN) algorithm to discover inactive nodes.
var _pool_ptr = 0
func _get_from_pool() -> PooledBullet:
	# Won't execute if pool is empty
	var i = 0
	var pool_size = get_child_count()
	while i < pool_size:
		var bullet : PooledBullet = get_child(_pool_ptr)
		_pool_ptr = (_pool_ptr + 1) % pool_size
		if not bullet.is_active(): return bullet
		i += 1
	# [Expand pool]
	# Move pool ptr to 1+end of the pool because we can guarantee
	# that it is inactive (new node)
	_pool_ptr = pool_size
	if pool_size == 0:
		resize_pool(1)
	else: resize_pool(int(pool_size * POOL_EXPAND_FACTOR))
	return get_child(_pool_ptr) as PooledBullet
# <Virtual>
# warning-ignore:unused_argument
func _process_bullets(delta : float):
	pass
func kill_all():
	var i = 0
	var pool_size = get_child_count()
	while i < pool_size:
		var bullet : PooledBullet = get_child(i)
		bullet.kill()
		i += 1
func kill_all_in_circle(center : Vector2, radius : float):
	var i = 0
	var pool_size = get_child_count()
	var r2 = radius * radius
	while i < pool_size:
		var bullet : PooledBullet = get_child(i)
		if bullet.global_position.distance_squared_to(center) < r2:
			bullet.kill()
		i += 1

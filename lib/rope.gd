extends Path2D
export(float, 0, 10) var rope_width = 5.0
export var antialiased = false
export var ignore_last_point = true
export(Vector2) var amplitude = Vector2(4, 2)
export(Vector2) var frequency = Vector2(2.5, 2.5)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var t = 0.0
onready var salt = randi()
var base_points : Array;
onready var follow_node = $"%WeaponHead"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_last_point_position(follow_node.position)
	base_points = Array()
	for i in range(0, curve.get_point_count()):
		base_points.append(curve.get_point_position(i))
	#curve = curve.duplicate()

func _draw():
	draw_polyline(curve.get_baked_points(), Color.white, rope_width, antialiased)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_last_point_position(follow_node.position)
	var range_end = base_points.size()
	if ignore_last_point: range_end -= 1
	var random = RandomNumberGenerator.new()
	for i in range(1, range_end):
		random.seed = salt + i + round(base_points[i].x + base_points[i].y * 12)
		var x_rand_offset = random.randf_range(0.0, 0.5)
		var y_rand_offset = random.randf_range(0.0, 0.5)
		var x_offset = amplitude.x * cos(x_rand_offset + t * frequency.x)
		var y_offset = amplitude.y * cos(y_rand_offset + t * frequency.y)
		if i % 2 != 0: curve.set_point_position(i, base_points[i] + x_offset * Vector2.LEFT)
		else: curve.set_point_position(i, base_points[i] + x_offset * Vector2.RIGHT)
		if i % 2 != 0: curve.set_point_position(i, base_points[i] + y_offset * Vector2.UP)
		else: curve.set_point_position(i, base_points[i] + y_offset * Vector2.DOWN)
	update()
	t += delta

func last_point_idx(): return curve.get_point_count() - 1
#func get_last_point_position(): curve.get_point_position(last_point_idx())
func set_last_point_position(position : Vector2): curve.set_point_position(last_point_idx(), position)

func _on_tree_exiting():
	for i in range(0, curve.get_point_count()):
		curve.set_point_position(i, base_points[i])

extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var score = 0
var player : Player
onready var target : Node2D = Node2D.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().root.call_deferred("add_child", target)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(_delta):
	if is_instance_valid(player):
		update_nearest_enemy()

func update_nearest_enemy():
	var closest_pos : Vector2 = Vector2.RIGHT * 1000
	var closest_dist = INF
	for node in get_tree().get_nodes_in_group("enemies"):
		var enemy : Enemy = node
		if enemy.stats.is_zero_health(): continue
		var dist = enemy.global_position.distance_squared_to(player.global_position)
		if dist < closest_dist:
			closest_dist = dist
			closest_pos = enemy.global_position
	target.position = closest_pos

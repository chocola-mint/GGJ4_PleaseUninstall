extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var score = 0
var player : Player
var difficulty_multiplier = 1.0
onready var target : Node2D = Node2D.new()
onready var bullet_dust : PackedScene = preload("res://bullet_hell/BulletDust.tscn")
onready var not_first_play = false
onready var audio_stream_player : AudioStreamPlayer = AudioStreamPlayer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().root.call_deferred("add_child", target)
	add_child(audio_stream_player)

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

func wipe_enemy_bullets():
	# TODO: Register enemy bullet types
	for bullet_type in [BulletEnemyBlueLemonA, BulletEnemyRedLemonA]:
		(bullet_type as BulletType).kill_all()
	pass
#func _on_area_shape_entered(area_id, _area : Area2D, area_shape, _local_shape):
#	if not Bullets.is_bullet_existing(area_id, area_shape):
#		# The colliding area is not a bullet, returning.
#		return
#	var bullet_id = Bullets.get_bullet_from_shape(area_id, area_shape)
#	add_bullet_dust(bullet_dust, bullet_id)
#	Bullets.call_deferred("release_bullet", bullet_id)

func is_game_over(): return player.stats.is_zero_health()

#func add_bullet_dust(dust_scene : PackedScene, bullet_id):
#	var dust : CPUParticles2D = dust_scene.instance()
#	var trans : Transform2D = Bullets.get_bullet_property(bullet_id, "transform")
#	add_child(dust)
#	dust.transform = trans
#	dust.restart()

func play_music(stream : AudioStream):
	audio_stream_player.stream = stream
	audio_stream_player.volume_db = 0
	audio_stream_player.play()

func fade_music(duration : float = 1.0) -> SceneTreeTween:
	var tween = audio_stream_player.create_tween()
	tween.tween_property(audio_stream_player, "volume_db", -40, duration)
	return tween

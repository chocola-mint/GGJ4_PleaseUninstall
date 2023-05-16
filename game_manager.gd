extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var score = 0
var player : Player
var difficulty_multiplier = 1.0
onready var bullet_dust : PackedScene = preload("res://bullet_hell/BulletDust.tscn")
onready var not_first_play = false
onready var audio_stream_player : AudioStreamPlayer = AudioStreamPlayer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(audio_stream_player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func wipe_enemy_bullets():
	# TODO: Register enemy bullet types
	for bullet_type in [BulletEnemyBlueLemonA, BulletEnemyRedLemonA]:
		(bullet_type as BulletType).kill_all()

func is_game_over(): return player.stats.is_zero_health()

func play_music(stream : AudioStream):
	audio_stream_player.stream = stream
	audio_stream_player.volume_db = 0
	audio_stream_player.play()

func fade_music(duration : float = 1.0) -> SceneTreeTween:
	var tween = audio_stream_player.create_tween()
	tween.tween_property(audio_stream_player, "volume_db", -40, duration)
	return tween

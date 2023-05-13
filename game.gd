extends Node

class_name Game

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player : Player = $"%Player"
onready var level_list = [
	preload("res://ingame/Level1.tscn")
]
var current_level : Level

signal start_over

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.score = 0
	GameManager.player = player
#	var tween = get_tree().create_tween().bind_node(self).set_loops()
#	tween.tween_callback(self, "_add_weapon", [weapon_list_t0]).set_delay(5.0)
	var err = player.connect("game_over", self, "_load_game_over_overlay")
	assert(not err)
	_start_level(0)
		
func _start_level(idx : int):
	current_level = level_list[idx].instance()
	add_child(current_level)
	current_level.start_level()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _load_game_over_overlay():
	var goo : GameOverOverlay = preload("res://game_over/GameOverOverlay.tscn").instance()
	add_child(goo)
	goo.connect("restart", self, "restart")

func restart():
	GameManager.not_first_play = true
	emit_signal("start_over")

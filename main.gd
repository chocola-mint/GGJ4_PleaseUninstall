extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	load_title()

#	add_child(preload("res://Game.tscn").instance())


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func load_title():
	var title : Title = preload("res://Title.tscn").instance()
	add_child(title)
	var err = title.connect("load_game", self, "load_game")
	assert(not err)
	
func load_game():
	var inst = preload("res://Game.tscn").instance()
	$"%Transition".exit()
	yield(get_tree().create_timer(1.7),"timeout")
	(get_child(1) as Node).queue_free()
	$"%Transition".enter()
	add_child(inst)
	var game : Game = inst
	var err = game.connect("start_over", self, "load_game")
	assert(not err)

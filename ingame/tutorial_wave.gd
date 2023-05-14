extends Wave


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal next
signal focus_pressed
signal shoot_pressed
signal moved
signal low_power
signal not_low_power
signal no_weapons
onready var hint : Label = $"%Hint"
onready var arrow : TextureRect = $"%Arrow"
onready var arrow_label : Label = $"%ArrowLabel"
onready var dummy : Node2D = $"Dummy"
onready var positive_sfx : AudioStream = preload("res://sound/positive.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	hint.visible = false

func start_wave():
	# Intro
	arrow_label.text = "Use Arrow Keys or WASD to move."
	arrow.self_modulate.a = 0
	arrow.set_global_position(Vector2(120, 60))
	hint.visible = false
	yield(self, "moved")
	hint.visible = true
	yield(self, "next")
	_sfx_positive()
	arrow_label.text = "Hold down shift to focus. This lets you move more precisely."
	hint.visible = false
	yield(self, "focus_pressed")
	hint.visible = true
	yield(self, "next")
	_sfx_positive()
	
	# Power
	GameManager.player.add_weapon(preload("res://player/PincerShooter.tscn"))
	arrow_label.text = "Here's a weapon! Press Z to shoot."
	hint.visible = false
	yield(self, "shoot_pressed")
	hint.visible = true
	yield(self, "next")
	_sfx_positive()
	GameManager.player.add_weapon(preload("res://player/PincerShooter_Var2.tscn"))
	arrow.self_modulate.a = 1
	arrow.flip_v = true
	arrow.set_global_position(Vector2(105, 90))
	arrow_label.text = "The more weapons you have, the more power you consume when you shoot."
	yield(self, "next")
	_sfx_positive()
	GameManager.player.add_weapon(preload("res://player/PincerShooter_Var1.tscn"))
	GameManager.player.add_weapon(preload("res://player/PincerShooter_Var3.tscn"))
	arrow_label.text = "Keep shooting!"
	hint.visible = false
	yield(self, "low_power")
	hint.visible = true
	arrow.self_modulate.a = 0
	arrow.set_global_position(Vector2(105, 80))
	arrow_label.text = "When you're low on power, your weapons will start shooting duds."
	yield(self, "next")
	_sfx_positive()
	arrow_label.text = "Stop firing to let power regenerate."
	hint.visible = false
	yield(self, "not_low_power")
	hint.visible = true
	yield(self, "next")
	_sfx_positive()
	arrow_label.text = "You can uninstall weapons by letting them hit an enemy's body."
	yield(self, "next")
	_sfx_positive()
	arrow.set_global_position(Vector2(85, 10))
	arrow_label.text = "Try letting all of your weapons collide with this UFO."
	dummy.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD).tween_property(dummy, "global_position:y", 0, 1.0)
	hint.visible = false
	yield(self, "no_weapons")
	hint.visible = true
	arrow.set_global_position(Vector2(105, 80))
	dummy.create_tween().tween_property(dummy, "global_position:y", -135, 0.5)
	arrow_label.text = "Sometimes, less is more."
	yield(self, "next")
	_sfx_positive()
	arrow_label.text = "You'll be forced to install one random weapon at the end of every wave."
	yield(self, "next")
	_sfx_positive()
	
	# Health
	arrow.self_modulate.a = 1
	arrow.flip_v = false
	arrow_label.text = "If you get hit, you'll lose a heart."
	arrow.set_global_position(Vector2(70, 34))
	hint.visible = true
	yield(self, "next")
	_sfx_positive()
	arrow_label.text = "It's game over if you lose all of your hearts."
	yield(self, "next")
	_sfx_positive()
	arrow_label.text = "Your heart will regenerate if you survive a wave with two weapons or less left."
	yield(self, "next")
	_sfx_positive()
	
	arrow_label.text = "That's the end of the tutorial. Good luck!"
	yield(self, "next")
	_sfx_positive()
	
	end_wave()
	queue_free()
	pass

func _sfx_positive():
	AudioUtils.play_one_shot_1d(positive_sfx)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("next")
	if Input.is_action_pressed("focus") and (Input.is_action_pressed("down") 
	or Input.is_action_pressed("up") 
	or Input.is_action_pressed("left")
	or Input.is_action_pressed("right")):
		emit_signal("focus_pressed")
	if (Input.is_action_pressed("down") 
	or Input.is_action_pressed("up") 
	or Input.is_action_pressed("left")
	or Input.is_action_pressed("right")):
		emit_signal("moved")
	if Input.is_action_pressed("shoot"):
		emit_signal("shoot_pressed")
	if GameManager.player.stats.power < 0.4:
		emit_signal("low_power")
	if GameManager.player.stats.power > 0.6:
		emit_signal("not_low_power")
	if GameManager.player.weapons.get_child_count() == 0:
		emit_signal("no_weapons")

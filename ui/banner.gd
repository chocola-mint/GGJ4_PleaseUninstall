extends CanvasLayer

class_name Banner

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var title : Label = $"%Title"
onready var subtitle : Label = $"%Subtitle"
onready var banner_rect : ColorRect = $"%BannerRect"
var show_direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	banner_rect.rect_scale.y = 0
	show_direction = -1
	pass # Replace with function body.
	
var active_tween : SceneTreeTween = null
func show(duration: float = 3.0):
	if active_tween and active_tween.is_running():
		active_tween.stop()
	active_tween = create_tween()
	show_direction = 1
	active_tween.tween_callback(self, "_set_show_direction", [-1]).set_delay(duration)

func _set_show_direction(dir : int):
	show_direction = dir

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	banner_rect.rect_scale.y = clamp(banner_rect.rect_scale.y + show_direction * delta * 4, 0, 1)

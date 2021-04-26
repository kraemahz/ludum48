extends Control

export (String, FILE) var first_scene
onready var audio = get_node("/root/MusicSoundTrack")

# Called when the node enters the scene tree for the first time.
func _ready():
	$StartButton.connect("pressed", self, "button_pressed", ["start"])
	$QuitButton.connect("pressed", self, "button_pressed", ["quit"])
	var viewport = get_viewport()
	var transform = viewport.get_canvas_transform()
	transform.origin.x = 0.0
	transform.origin.y = 0.0
	viewport.set_canvas_transform(transform)
	
	$Tween.interpolate_property(audio,
		"volume_db",
		-120, -20, 3,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT)
	audio.volume_db = -120.0
	$Tween.start()

func button_pressed(button_name):
	if button_name == "start":
		get_node("/root/Globals").load_new_scene(first_scene)
	else:
		get_tree().quit()

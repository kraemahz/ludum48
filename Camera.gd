extends Node2D

var viewport
var texture_size
var viewport_size
var player

const parallax_scale = 10
export (String, FILE) var menu
export (String, FILE) var next_level
onready var audio = get_node("/root/MusicSoundTrack")

# Called when the node enters the scene tree for the first time.
func _ready():
	viewport = get_viewport()
	texture_size = $ParallaxBackground/ParallaxLayer/Background.texture.get_size()
	viewport_size = OS.get_window_size()
	player = $Player
	audio.volume_db = -20.0

func _process(delta):
	var max_move = texture_size - viewport_size;
	var transform_origin = Vector2(viewport_size.x / 2, viewport_size.y / 2)
	var player_pos = transform_origin - player.transform.origin
	
	var parallax = $ParallaxBackground
	
	var transform = viewport.get_canvas_transform()
	transform.origin.x = clamp(player_pos.x, -max_move.x * parallax_scale, 0)
	transform.origin.y = clamp(player_pos.y, 0, max_move.y * parallax_scale)
	parallax.scroll_offset = Vector2(
		transform.origin.x / parallax_scale,
		transform.origin.y / parallax_scale
	)
	
	viewport.set_canvas_transform(transform);

func _fade_background():
	var tween = $Tween
	var canvas = $ParallaxBackground/ParallaxLayer/CanvasModulate
	var current_color = canvas.color
	tween.interpolate_property(canvas,
		"color",
		current_color,
		Color(), 3,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(audio,
		"volume_db",
		-20.0, -120.0, 3,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween.start()
	$GameEndTimer.start()

func _on_GameEndTimer_timeout():
		get_node("/root/Globals").load_new_scene(menu)

func _on_portal_entered(body):
	get_node("/root/Globals").load_new_scene(next_level)

func _on_Melas_boss_killed():
	_fade_background()
	$GameEndTimer.wait_time = 10.0
	$GameEndTimer.start()

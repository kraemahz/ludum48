extends Node2D

# Extra amount above or below starting position to fly at
export var altitude = 0
export var fly_direction = Vector2(-1, 0)
var fly_speed = 1.0
var flying = false
var start_time
var simple_audio_player = preload("res://SimpleAudioPlayer.tscn")
onready var starting_position = self.position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if flying:
		var now = OS.get_ticks_msec()
		var lerp_amount = min((now - start_time) / 1000.0, 1.0)
		position += fly_direction * fly_speed
		position.y = lerp(starting_position.y, starting_position.y + altitude, lerp_amount)

func create_sound(sound_name):
		var audio_clone = simple_audio_player.instance()
		add_child(audio_clone)
		audio_clone.play_sound(sound_name)
		return audio_clone

func _on_DetectionRadius_entered(body):
	if body.name == "Player" and not flying:
		create_sound("flap")
		$AnimatedSprite.animation = "fly"
		$AnimatedSprite.play()
		start_time = OS.get_ticks_msec()
		flying = true

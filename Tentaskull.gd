extends Node2D

var simple_audio_player = preload("res://SimpleAudioPlayer.tscn")
var hitting = false
var animation_done = false
const HIT_FRAME = 2
const LAST_FRAME = 6

onready var sprite = $AnimatedSprite
onready var player = get_node("../../Player")

func create_sound(sound_name):
		var audio_clone = simple_audio_player.instance()
		add_child(audio_clone)
		audio_clone.play_sound(sound_name)
		return audio_clone

func enable(schedule):
	$Timer.wait_time = schedule
	$Timer.one_shot = true
	$Timer.start()

func reset():
	animation_done = true
	sprite.animation = "reverse"
	sprite.frame = 0
	sprite.play()


func _on_AnimatedSprite_frame_changed():
	var frame = sprite.frame
	var animation = sprite.animation

	if frame >= LAST_FRAME and animation == "default":
		reset()
	elif frame > HIT_FRAME and animation == "default":
		hitting = true
	else:
		hitting = false

func _on_Area2D_body_entered(body):
	if body.name == "Player" and hitting:
		player.take_hit()

func _on_Timer_timeout():
	create_sound("tentacle")
	animation_done = false
	sprite.frame = 0
	sprite.animation = "default"
	sprite.play()

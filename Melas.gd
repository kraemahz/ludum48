extends Node2D

signal boss_killed
signal boss_hit

const HITS_TO_KILL = 3
var hits_taken = 0
var sides = [Vector2(3072.52, -423.355),
			 Vector2(2412.823, -428.192)]
var side = 0
var simple_audio_player = preload("res://SimpleAudioPlayer.tscn")

func create_sound(sound_name):
		var audio_clone = simple_audio_player.instance()
		add_child(audio_clone)
		audio_clone.play_sound(sound_name)
		return audio_clone

func emerge():
	print("Melas is emerging!")
	if side == 0:
		side = 1
	else:
		side = 0
	
	position = sides[side]
	$AnimatedSprite.flip_h = bool(side)
	visible = true
	print("Melas position = ", position)

func _on_Area2D_body_entered(body):
	if body.name != "Player":
		return

	print("BOSS HIT")
	if not visible:
		return

	hits_taken += 1
	emit_signal("boss_hit")
	if hits_taken >= HITS_TO_KILL:
		emit_signal("boss_killed")
	create_sound("boss")
	visible = false

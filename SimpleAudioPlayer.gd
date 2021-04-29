extends Node

var audio_hit = preload("res://assets/hurt.wav")
var audio_jump = preload("res://assets/jump.wav")
var audio_lose = preload("res://assets/lose_static.wav")  
var audio_dash = preload("res://assets/dash.wav")
var audio_heal = preload("res://assets/heal.wav")
var audio_flap = preload("res://assets/flap.wav")
var audio_boss = preload("res://assets/boss.wav")
var audio_tentacle = preload("res://assets/tentacle.wav")

var audio_node = null                                                                                     
  
func _ready():                                                                                            
	audio_node = $AudioStreamPlayer                                                                 
	audio_node.connect("finished", self, "destroy_self")                                              

func play_sound(sound_name):
	if sound_name == "hit":
		audio_node.stream = audio_hit
	elif sound_name == "jump":
		audio_node.stream = audio_jump
	elif sound_name == "lose":
		audio_node.stream = audio_lose
	elif sound_name == "dash":
		audio_node.stream = audio_dash
	elif sound_name == "flap":
		audio_node.stream = audio_flap
		audio_node.volume_db = -30.0
	elif sound_name == "boss":
		audio_node.stream = audio_boss
	elif sound_name == "tentacle":
		audio_node.stream = audio_tentacle
		audio_node.volume_db = -20.0
	elif sound_name == "heal":
		audio_node.stream = audio_heal
		audio_node.volume_db = -20.0
	else:
		print("Tried to play unknown sound: ", sound_name)
		destroy_self()
	audio_node.play()

func destroy_self():
	audio_node.stop()
	queue_free()

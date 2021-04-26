extends KinematicBody2D

signal hit

var vel = Vector2()
var dir = Vector2()
var is_dashing = false
var controls_enabled = true
var last_ground = Vector2()
var safe = true
var dash_available = true
var ghosts = 0
const MAX_GHOSTS = 6

const ACCEL = 9.0
const DEACCEL = 18
const GRAVITY = 250
const MAX_VEL = 3000

const MAX_SPRINT_SPEED = 240
const MAX_SLOPE_ANGLE = 60
const SPRINT_ACCEL = 18
const MAX_SPEED = 160
const JUMP_SPEED = -200

var screen_size;
var simple_audio_player = preload("res://SimpleAudioPlayer.tscn")
var ghost_node = preload("res://Ghost.tscn")

func _ready():
	screen_size = get_viewport_rect().size
	$SpriteAnimation.play()

func _process(delta):
	var on_floor = is_on_floor()
	if on_floor and safe:
		last_ground = position
		dash_available = true

	process_input(on_floor)
	
func process_input(on_floor):
	dir = Vector2()
	if not controls_enabled:
		return
	if Input.is_action_pressed("movement_right"):
		dir.x += 1
	if Input.is_action_pressed("movement_left"):
		dir.x -= 1

	if Input.is_action_just_pressed("movement_jump") and on_floor:
		vel.y = JUMP_SPEED
		create_sound("jump")
		
	if Input.is_action_just_pressed("movement_sprint") and dash_available:
		var dir = 1.0
		if $SpriteAnimation.flip_h:
			dir = -1.0
		vel.x += -5.0 * JUMP_SPEED * dir
		dash_available = false
		create_sound("dash")
		_on_ghost_timeout()
		$GhostTimer.start()

	if dir.x != 0 and on_floor:
		$SpriteAnimation.animation = "walk"
		$SpriteAnimation.flip_h = dir.x < 0
	elif not on_floor:
		$SpriteAnimation.animation = "land"
	else:
		$SpriteAnimation.animation = "idle"

func _physics_process(delta):
	process_movement(delta)

func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()
	vel.y += delta * GRAVITY
	vel.y = min(vel.y, MAX_VEL)
	
	var hvel = vel
	hvel.y = 0

	var target = dir
	target *= MAX_SPEED
	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL
	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel = move_and_slide(vel, Vector2(0, -1), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

func create_sound(sound_name):
		var audio_clone = simple_audio_player.instance()
		var scene_root = get_tree().root.get_children()[0]
		scene_root.add_child(audio_clone)
		audio_clone.play_sound(sound_name)
		return audio_clone

func move_to_last_ground():
	position = last_ground
	vel = Vector2()

func _on_map_bottom_entered(body):
	if body.name == "Player":
		move_to_last_ground()
		take_hit()

func take_hit():
	emit_signal("hit")
	create_sound("hit")
	var tween = get_node("../Tween")
	var current_color = $SpriteAnimation.modulate
	tween.interpolate_property($SpriteAnimation,
		"modulate",
		modulate, Color(1.0, 0.0, 0.0), 0.25,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween.start()
	tween.connect("tween_completed", self, "_on_flash_complete")

	
func _on_flash_complete(object, key):
	var tween = get_node("../Tween")
	var current_color = $SpriteAnimation.modulate
	tween.interpolate_property($SpriteAnimation,
		"modulate",
		modulate, Color(1.0, 1.0, 1.0), 0.5,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	tween.start()

func _on_spike_hit(body):
	if body.name == "Player":
		take_hit()
		safe = false

func _on_spike_leave(body):
	if body.name == "Player":
		safe = true

func _no_lives():
	create_sound("lose")
	controls_enabled = false

func _enemy_body_entered(body):
	if body.name == "Player":
		take_hit()

func _on_ghost_timeout():
	ghosts += 1
	if ghosts >= MAX_GHOSTS:
		$GhostTimer.stop()
		ghosts = 0
	var ghost = ghost_node.instance()
	get_parent().add_child(ghost);
	ghost.position = position;
	var sprite = $SpriteAnimation
	ghost.texture = sprite.frames.get_frame(sprite.animation, sprite.frame)
	ghost.flip_h = sprite.flip_h

func _on_healed():
	create_sound("heal")

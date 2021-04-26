extends RigidBody2D


onready var raycast = $RayCast2D
onready var sprite = $AnimatedSprite

var velocity = Vector2.ZERO
const move_speed = 1.0
var raycasting_disabled = false
var frame_count = 0

export var raycasting = false
export var turn_around_time = 0.0
export var current_direction = Vector2(-1, 0)

func _ready():
	if turn_around_time > 0.0:
		$TurnAroundTimer.wait_time = turn_around_time
		$TurnAroundTimer.start()

func _process(delta):
	if raycasting:
		check_ground_forward()
	move_forward(delta)

# Raycast in front of us to check if there is ground. If not, change direction
func check_ground_forward():
	if raycast.get_collider() == null:
		if not raycasting_disabled:
			turn_around()
			raycasting_disabled = true
	else:
		raycasting_disabled = false

func turn_around():
	current_direction *= Vector2(-1, -1)
	raycast.cast_to *= Vector2(-1, 1)

func move_forward(delta):
	position += current_direction * move_speed
	frame_count += 1
	if frame_count % 10 == 0:
		advance_frame(current_direction)

func advance_frame(direction):
	var frame = sprite.frame
	if direction.x < 0:
		frame += 1
	else:
		frame -= 1
	var frame_num = sprite.frames.get_frame_count("default")
	if frame < 0:
		frame = frame_num - 1
	if frame >= frame_num:
		frame = 0
	sprite.frame = frame

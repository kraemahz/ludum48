extends HBoxContainer

signal no_lives
signal healed
signal max_increased

const MAX_HITS = 3
var hits_taken = 0
var hearts = []

func _ready():
	hearts.append($AnimatedSprite)
	hearts.append($AnimatedSprite2)
	hearts.append($AnimatedSprite3)

func take_hit():
	if hits_taken == MAX_HITS:
		return
		
	var hurt_heart = hearts[hits_taken]
	hurt_heart.visible = false
	hits_taken += 1
	
	if hits_taken == MAX_HITS - 1:
		hearts[hits_taken].play()
	
	if hits_taken >= MAX_HITS:
		emit_signal("no_lives")

func restore(body):
	hits_taken = 0
	for heart in hearts:
		heart.visible = true
		heart.stop()
		heart.frame = 0
	emit_signal("healed")

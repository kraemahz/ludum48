extends Sprite


# Called when the node enters the scene tree for the first time.
func _ready():
	$Tween.interpolate_property(self,
		"modulate",
		Color(1, 1, 1, 1), Color(0, 0, 0, 0), 0.6,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT
	)
	$Tween.start()

func _on_Tween_tween_completed(object, key):
	queue_free();

extends CanvasLayer

export var opening_dialog = 'timeline-1619300716.json'
export var first_dialog = 'timeline-1619314046.json'
export var second_dialog = 'timeline-1619358154.json'
export var victory_dialog = "victory"
export var arena_dialog = "boss_talk"

var played1 = false
var played2 = false
var arena = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var new_dialog = Dialogic.start(opening_dialog)
	add_child(new_dialog)

func _dialogTrigger1():
	if not played1:
		var new_dialog = Dialogic.start(first_dialog)
		add_child(new_dialog)
		played1 = true

func _dialogTrigger2():
	if not played2:
		var new_dialog = Dialogic.start(second_dialog)
		add_child(new_dialog)
		played2 = true

func _on_Melas_boss_killed():
	var new_dialog = Dialogic.start(victory_dialog)
	add_child(new_dialog)
	$Label.visible = true

func _on_enter_arena():
	if not arena:
		var new_dialog = Dialogic.start(arena_dialog)
		add_child(new_dialog)
		arena = true

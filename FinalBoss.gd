extends Node2D


onready var tentaskulls = [
	$Tentaskull,
	$Tentaskull2,
	$Tentaskull3,
	$Tentaskull4,
	$Tentaskull5,
	$Tentaskull6,
	$Tentaskull7,
	$Tentaskull8,
	$Tentaskull9,
	$Tentaskull10,
	$Tentaskull11,
	$Tentaskull12
]
onready var melas = $Melas
var started = false
var boss_hidden = 0

var pattern0 = [[0, 1], [2, 3], [4, 5], [6, 7], [8, 9], [10, 11]]
var pattern1 = [[10, 11], [8, 9], [6, 7], [4, 5], [2, 3], [0, 1]]
var pattern2 = [[0, 1, 2, 3, 4, 5],
				[5, 6, 7, 8, 9, 10, 11],
				[0, 1, 2, 3, 4, 5],
				[5, 6, 7, 8, 9, 10, 11],]
var pattern3 = [[5, 6], [4, 7], [3, 8], [2, 9], [1, 10], [0, 11]]

var patterns = [pattern0, pattern1, pattern2, pattern3]

func execute_pattern(pattern):
	var delay = 0
	for entry in pattern:
		delay += 1
		for tentaskull in entry:
			print("Setting tentaskull ", tentaskull, " to ", delay)
			tentaskulls[tentaskull].enable(delay)

func start_encounter():
	$BossTimer.start()
	started = true
	execute_pattern(pattern0)

func _on_Melas_boss_hit():
	boss_hidden = 1

func _on_screen_entered():
	var _timer = Timer.new()
	add_child(_timer)
	_timer.one_shot = true
	_timer.wait_time = 1.0
	_timer.connect("timeout", self, "start_encounter")
	_timer.start()

func _on_BossTimer_timeout():
	if not started:
		return
	var random_pattern = patterns[randi() % patterns.size()]
	execute_pattern(random_pattern)
	if boss_hidden > 0:
		print("Boss hidden for ", boss_hidden, " more turns")
		boss_hidden -= 1
		if boss_hidden == 0:
			melas.emerge()

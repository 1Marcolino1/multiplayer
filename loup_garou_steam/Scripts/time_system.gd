extends Node

var countdown_started = false

var sec = 0

var current_min
var current_sec
var starting_time_minutes = 20
var starting_time_seconds = 0

@onready var ui = get_tree().get_root().get_node("Game/UI")

func _ready() -> void:
	if !multiplayer.is_server() :
		set_process(false)
	else :
		current_min = starting_time_minutes
		current_sec = starting_time_seconds
		ui.start_game_button.pressed.connect(start_timer)

func _process(delta: float) -> void:
	if !countdown_started :
		return
	sec += delta
	if sec >= 1 :
		current_sec = current_sec - 1
		if current_sec < 0 :
			current_sec = 59
			current_min -= 1
		ui.clock_time.text = str(current_min) + ":" + str(current_sec)
		synchronize_timer.rpc(current_min,current_sec) 
		sec = 0

@rpc("authority","call_remote","reliable")
func synchronize_timer(_min,_sec) :
	ui.clock_time.text = str(_min) + ":" + str(_sec)

func start_timer() :
	countdown_started = true
	ui.start_game_button.visible = false

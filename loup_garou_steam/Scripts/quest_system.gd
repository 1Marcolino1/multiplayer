extends Node

var quest_count = 5

var kills = {}

var current_quests = []
var global_quests = []

@onready var ui = get_tree().get_root().get_node("Game/UI")

func _ready() -> void:
	ui.start_game_button.pressed.connect(initialize_quests)

func _process(delta: float) -> void: 
	pass

func add_to_kills(entity) :
	update_kill_quests(entity)
	if kills.has(entity) :
		kills[entity] += 1
	else:
		kills[entity] = 1


func update_kill_quests(entity) :
	var changed_quests = {}
	if multiplayer.is_server() :
		var quest_updated = false
		for i in current_quests.size() :
			var quest = current_quests[i]
			if quest.entity_type == entity :
				quest.current_count += 1
				changed_quests[i] = quest.current_count 
				quest_updated = true
		if quest_updated :
			ui.quest_board.update_quests_on_panel()
			update_kill_quests_on_peers.rpc(changed_quests)
		


func generate_quest() :
	var quest =  load("res://Data/Quests/kill_entities.tres").duplicate()
	current_quests.push_back(quest)
	return "res://Data/Quests/kill_entities.tres"

func initialize_quests() :
	var quest_paths = []
	if multiplayer.is_server() :
		for i in quest_count :
			var quest = generate_quest()
			quest_paths.push_back(quest)
		for quest in current_quests :
			ui.quest_board.add_quest_to_panel(quest)
		set_quests_on_peers.rpc(quest_paths)
		


@rpc("authority","call_remote","reliable")
func set_quests_on_peers(quest_paths) :
	for quest_path in quest_paths :
		current_quests.push_back(load(quest_path))
	for quest in current_quests :
		ui.quest_board.add_quest_to_panel(quest)

@rpc("authority","call_remote","reliable")
func update_kill_quests_on_peers(changed_quests) :
	for i in current_quests.size() :
		if changed_quests.has(i) :
			current_quests[i].current_count = changed_quests[i]
	ui.quest_board.update_quests_on_panel()

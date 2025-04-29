extends Panel

var quests = []


func add_quest_to_panel(quest) :
	var new_quest_ui = preload("res://Scenes/UI/quest_item_ui.tscn").instantiate()
	$VBoxContainer/ScrollContainer/VBoxContainer.add_child(new_quest_ui)
	quests.push_back(new_quest_ui)
	new_quest_ui.get_node("Label").text = quest.title + " " + quest.entity_type.name + " : " + str(quest.current_count) + "/" + str(quest.needed_count)


func update_quests_on_panel() :
		var current_quests = get_tree().get_root().get_node("Game/Systems/quest_system").current_quests
		for i in  current_quests.size() :
			quests[i].get_node("Label").text = current_quests[i].title + " " + current_quests[i].entity_type.name + " : " + str(current_quests[i].current_count) + "/" + str(current_quests[i].needed_count)

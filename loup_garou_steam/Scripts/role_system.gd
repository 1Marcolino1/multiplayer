extends Node

@export var available_roles:Dictionary[Role,int]


@onready var ui = get_tree().get_root().get_node("Game/UI")

func _ready() -> void:
	if multiplayer.is_server() :
		ui.start_game_button.pressed.connect(assign_roles)
		

func assign_roles() :
	var peers = multiplayer.get_peers()
	peers.append(1)
	for peer in peers :
		var role = available_roles.keys()[randi_range(0,available_roles.size() - 1)]
		available_roles[role] -= 1
		if available_roles[role] <= 0 :
			available_roles.erase(role)
		assign_role(role,peer) 
	announce_roles()
	print("i assigned roles")

func assign_role(role,id) :
	$"../../Players".get_node(str(id)).role = role

@rpc("any_peer","call_local","reliable")
func announce_role(role_name) :
	ui.role_announcement_label.text = "Your role is " + role_name
	await get_tree().create_timer(2).timeout
	var tween = create_tween()
	tween.tween_property(ui.role_announcement_label, "modulate:a", 0, 1)

func announce_roles() :
	var peers = multiplayer.get_peers()
	peers.append(1)
	for peer in peers :
		announce_role.rpc_id(peer,$"../../Players".get_node(str(peer)).role.name)

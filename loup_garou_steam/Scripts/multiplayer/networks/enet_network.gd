extends Node

const SERVER_PORT = 8080
const SERVER_IP = "192.168.1.144"

var multiplayer_scene = preload("res://Scenes/Multiplayer/multiplayer_player.tscn")
var multiplayer_peer:ENetMultiplayerPeer = ENetMultiplayerPeer.new()

var _players_spawn_node



func become_host() :
	print("Starting Host")
	
	

	multiplayer_peer.create_server(SERVER_PORT)
	
	multiplayer.multiplayer_peer = multiplayer_peer
	
	
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_del_player)
	
	_add_player_to_game(1)
	
	get_tree().get_root().get_node("Game").get_node("UI").start_game_button.visible = true

func join_as_client(lobby_id) :
	print("Joining Game")
	multiplayer_peer.create_client(get_tree().get_root().get_node("Game/Multiplayer_HUD/ip_address_input").text,SERVER_PORT)
	multiplayer.multiplayer_peer = multiplayer_peer

func _add_player_to_game(id:int) :
	print("Player %s joined game !" % id)
	var player_to_add = multiplayer_scene.instantiate()
	player_to_add.player_id = id
	player_to_add.name = str(id)
	_players_spawn_node.add_child(player_to_add,true)

func _del_player(id:int):
	print("Player %s left game !" % id)
	if not _players_spawn_node.has_node(str(id)) :
		return
	_players_spawn_node.get_node(str(id)).queue_free()

extends Node


var multiplayer_scene = preload("res://Scenes/Multiplayer/multiplayer_player.tscn")
var multiplayer_peer:SteamMultiplayerPeer = SteamMultiplayerPeer.new()

var _players_spawn_node
var _hosted_lobby_id

const LOBBY_NAME = "BAD"
const LOBBY_MODE = "COOP"


func _ready() -> void:
	multiplayer_peer.lobby_created.connect(_on_lobby_created)

func become_host() :
	print("Starting Host")
	
	

	multiplayer_peer.create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC,SteamManager.lobby_max_members)
	
	multiplayer.multiplayer_peer = multiplayer_peer
	
	
	multiplayer.peer_connected.connect(_add_player_to_game)
	multiplayer.peer_disconnected.connect(_del_player)
	
	_add_player_to_game(1)
	
	get_tree().get_root().get_node("Game").get_node("UI").start_game_button.visible = true

func join_as_client(lobby_id) :
	print("Joining Lobby")
	multiplayer_peer.connect_lobby(lobby_id)
	multiplayer.multiplayer_peer = multiplayer_peer

func _on_lobby_created(_connect:int,lobby_id) :
	print("On lobby created")
	if _connect == 1 :
		_hosted_lobby_id = lobby_id
		print("Created lobby : %s" % _hosted_lobby_id)
		
		Steam.setLobbyJoinable(_hosted_lobby_id,true)
		
		Steam.setLobbyData(_hosted_lobby_id,"name",LOBBY_NAME)
		Steam.setLobbyData(_hosted_lobby_id,"mode",LOBBY_MODE)
	

func list_lobbies():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_DEFAULT)
	Steam.requestLobbyList()

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

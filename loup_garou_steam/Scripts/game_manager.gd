extends Node


func become_host() :
	print("Become host pressed")
	%"Multiplayer_HUD".hide()
	%SteamHUD.hide()
	%NetworkManager.become_host()

func join_as_client() :
	join_lobby()


func _on_host_button_pressed() -> void:
	become_host()





func _on_join_button_pressed() -> void:
	join_as_client() 

func use_steam():
	print("Using steam !")
	%Multiplayer_HUD.hide()
	%SteamHUD.show()
	SteamManager.initialize_steam()
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	%NetworkManager.active_network_type = %NetworkManager.MULTIPLAYER_NETWORK_TYPE.STEAM

func list_steam_lobbies():
	print("List steam lobbies")
	%NetworkManager.list_lobbies()

func join_lobby(lobby_id=0):
	print("Join as Player")
	%"Multiplayer_HUD".hide()
	%SteamHUD.hide()
	%NetworkManager.join_as_client(lobby_id)
	

func _on_use_steam_pressed() -> void:
	use_steam()

func _on_lobby_match_list(lobbies:Array):
	print("On lobby match list")
	for lobby_child in $"../SteamHUD/Panel/Lobbies/VBoxContainer".get_children() :
		lobby_child.queue_free()
	for lobby in lobbies:
		var lobby_name  = Steam.getLobbyData(lobby,"name")
		if lobby_name != ""  :
			var lobby_mode  = Steam.getLobbyData(lobby,"mode")
			var lobby_button = Button.new()
			lobby_button.set_text(lobby_name + " | " + lobby_mode)
			lobby_button.set_size(Vector2(100,30))
			
			lobby_button.set_name("lobby_%s" % lobby)
			lobby_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
			lobby_button.connect("pressed",Callable(self,"join_lobby").bind(lobby))
			
			$"../SteamHUD/Panel/Lobbies/VBoxContainer".add_child(lobby_button)

func _on_list_lobbies_pressed() -> void:
	list_steam_lobbies()


func _on_host_p_2p_game_pressed() -> void:
	become_host()

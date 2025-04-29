extends Node

var is_owned:bool = false
var steam_app_id: int = 480
var steam_id:int = 0
var steam_username:String = ""

var lobby_id = 0
var lobby_max_members = 4


func _init() -> void:
	OS.set_environment("SteamAppId",str(steam_app_id))
	OS.set_environment("SteamGameId",str(steam_app_id))

func _process(delta: float) -> void:
	Steam.run_callbacks()

func initialize_steam():
	var initialize_response: Dictionary = Steam.steamInitEx()
	print("Did Steam Initialize?: %s" % initialize_response)
	
	if initialize_response['status'] > 0 :
		print("Failed Init Steam")
		get_tree().quit()
	
	is_owned = Steam.isSubscribed()
	steam_id = Steam.getSteamID()
	steam_username = Steam.getPersonaName()
	
	print("steam_id %s" % steam_id)
	
	if is_owned == false :
		print("User does not the game")
		get_tree().quit()

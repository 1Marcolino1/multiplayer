extends Node


func _on_idle_state_state_entered() -> void:
	#Le serveur
	if multiplayer.is_server() :
		print("Server copy is idle " + str($"../..".player_id))
		%state_chart.set_anim_parameter("is_stopped",true)
		%state_chart.set_anim_param_on_peers.rpc("is_stopped",true)
	#Tous les peers qui ne sont ni le serveur ni le joueur concerné
	elif $"../..".player_id != multiplayer.get_unique_id() :
		$"../../StateChart".send_event("is_network_copy")
	#Le joueur concerné
	else :
		%state_chart.set_anim_parameter("is_stopped",true)

func _on_idle_state_state_processing(delta: float) -> void:
		if %state_chart.direction != Vector3.ZERO :
			$"../../StateChart".send_event("player_moved")


func _on_idle_state_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.


func _on_idle_state_state_exited() -> void:
	
	%state_chart.set_anim_parameter("is_stopped",false)
	if  multiplayer.is_server() :
		%state_chart.set_anim_param_on_peers.rpc("is_stopped",false)

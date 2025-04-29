extends Node


func _on_idle_state_state_entered() -> void:
	if !multiplayer.is_server() :
		$"../../StateChart".send_event("is_network_copy")
	%state_chart.set_anim_parameter("is_stopped",true)
	%state_chart.set_anim_param_on_peers.rpc("is_stopped",true)


func _on_idle_state_state_processing(delta: float) -> void:
	if !multiplayer.is_server() :
		return
	
	if not %state_chart.target == null :
		%state_chart.set_anim_parameter("is_stopped",false)
		%state_chart.set_anim_param_on_peers.rpc("is_stopped",false)
		$"../../StateChart".send_event("target_found")


func _on_idle_state_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.


func _on_idle_state_state_exited() -> void:
	pass # Replace with function body.

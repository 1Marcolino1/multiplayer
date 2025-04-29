extends Node



func _on_dead_state_state_entered() -> void:
	%state_chart.set_anim_parameter("is_dead",true)
	if multiplayer.is_server() :
		%state_chart.set_anim_param_on_peers.rpc("is_dead",true)
	await %state_chart.model.get_node("AnimationTree").animation_finished
	if multiplayer.is_server() :
		get_tree().get_root().get_node("Game/Systems/quest_system").add_to_kills($"../..".entity_type)
		$"../..".queue_free()
		%state_chart.remove_entity_on_peers.rpc() 

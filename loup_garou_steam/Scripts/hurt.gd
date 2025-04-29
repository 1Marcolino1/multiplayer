extends Node


func _on_hurt_state_state_entered() -> void:	
	%state_chart.set_anim_parameter("is_hurt",true)
	%state_chart.play_sound($"../..".hurt_sounds) 
	if multiplayer.is_server() :
		%state_chart.play_sound_on_peers.rpc($"../..".hurt_sounds) 
		%state_chart.set_anim_param_on_peers.rpc("is_hurt",true)
	await %state_chart.model.get_node("AnimationTree").animation_finished
	$"../../StateChart".send_event("hurt_finished")

func _on_hurt_state_state_processing(delta: float) -> void:
	pass # Replace with function body.


func _on_hurt_state_state_exited() -> void:
	%state_chart.set_anim_parameter("is_hurt",false)
	if multiplayer.is_server() :
		%state_chart.set_anim_param_on_peers.rpc("is_hurt",false)

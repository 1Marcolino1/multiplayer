extends Node


func _on_attack_state_state_entered() -> void:
	%state_chart.set_anim_parameter("is_attacking",true)
	%state_chart.set_anim_param_on_peers.rpc("is_attacking",true)
	await %state_chart.model.get_node("AnimationTree").animation_finished
	$"../../StateChart".send_event("attack_finished")


func _on_attack_state_state_processing(delta: float) -> void:
	pass # Replace with function body.


func _on_attack_state_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.


func _on_attack_state_state_exited() -> void:
	%state_chart.set_anim_parameter("is_attacking",false)
	%state_chart.set_anim_param_on_peers.rpc("is_attacking",false)

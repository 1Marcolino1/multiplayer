extends Node



func _on_attack_state_state_entered() -> void:
	%state_chart.model.get_node("AnimationTree").animation_finished.connect(on_anim_finished)
	print("entered attack")
	%state_chart.set_anim_parameter("is_attacking",true)
	if multiplayer.is_server() :
		%state_chart.set_anim_param_on_peers.rpc("is_attacking",true)
	await  get_tree().create_timer(0.5).timeout
	if multiplayer.is_server() :
		%state_chart.play_sound($"../..".attack_sounds)
		%state_chart.play_sound_on_peers.rpc($"../..".attack_sounds)


func _on_attack_state_state_processing(delta: float) -> void:
	pass # Replace with function body.


func _on_attack_state_state_physics_processing(delta: float) -> void:
	pass # Replace with function body.


func _on_attack_state_state_exited() -> void:
	%state_chart.model.get_node("AnimationTree").animation_finished.disconnect(on_anim_finished)
	%state_chart.set_anim_parameter("is_attacking",false)
	if multiplayer.is_server() :
		%state_chart.set_anim_param_on_peers.rpc("is_attacking",false)
	%state_chart.attack_input = false

func on_anim_finished(anim_name) :
	print(anim_name)
	if anim_name == "barbarian_anims/1H_Melee_Attack_Chop" :
		$"../../StateChart".send_event("attack_finished")

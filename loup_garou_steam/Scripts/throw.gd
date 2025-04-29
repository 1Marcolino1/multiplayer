extends Node

func _ready() -> void:
	%state_chart.model.get_node("AnimationTree").animation_finished.connect(on_anim_finished)

func _on_throw_state_state_entered() -> void:
	%state_chart.set_anim_parameter("is_throwing",true)
	if multiplayer.is_server() :
		%state_chart.set_anim_param_on_peers.rpc("is_throwing",true)
	await get_tree().create_timer(0.6).timeout
	if multiplayer.is_server() :
		%projectile_system.create_projectile(100,-$"../..".transform.basis.z.normalized())
	

func _on_throw_state_state_exited() -> void:
	%state_chart.set_anim_parameter("is_throwing",false)
	if multiplayer.is_server() :
		%state_chart.set_anim_param_on_peers.rpc("is_throwing",false)
	%state_chart.hold_input = false

func on_anim_finished(anim_name) :
	print(anim_name)
	if anim_name == "barbarian_anims/Throw" :
		$"../../StateChart".send_event("attack_finished")
		

extends Node



func _on_chasing_state_state_entered() -> void:
	%state_chart.set_anim_parameter("is_moving",true)
	%state_chart.set_anim_param_on_peers.rpc("is_moving",true)
	print("entred chase")


func _on_chasing_state_state_physics_processing(delta: float) -> void:
	print( %state_chart.target)
	$"../../NavigationAgent3D".target_position = %state_chart.target.global_position
	var next_path_position = $"../../NavigationAgent3D".get_next_path_position()
	var new_velocity  = $"../..".global_position.direction_to(next_path_position) * delta * 100
	$"../..".velocity = new_velocity
	
	if  %state_chart.target == null :
		$"../../StateChart".send_event("no_target")
	
	if %state_chart.in_range_distance >= $"../..".global_position.distance_to(%state_chart.target.global_position) :
		$"../../StateChart".send_event("target_in_range")

func _on_chasing_state_state_processing(delta: float) -> void:
	$"../..".look_at(%state_chart.target.global_position)
	
	$"../..".global_rotation = Vector3(0,$"../..".global_rotation.y,0)


func _on_chasing_state_state_exited() -> void:
	$"../..".velocity = Vector3.ZERO
	%state_chart.set_anim_parameter("is_moving",false)
	%state_chart.set_anim_param_on_peers.rpc("is_moving",false)

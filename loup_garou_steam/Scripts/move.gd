extends Node

var SPEED = 400


func _on_move_state_state_entered() -> void:
	print("Server copy has moved " + str($"../..".player_id))
	%state_chart.set_anim_parameter("is_moving",true)
	if multiplayer.is_server() :
		$"../../AudioStreamPlayer3D".finished.connect(on_audio_stream_player_3d_finished)
		%state_chart.play_sound($"../..".footsteps_sounds)
		%state_chart.play_sound_on_peers.rpc($"../..".footsteps_sounds)
		%state_chart.set_anim_param_on_peers.rpc("is_moving",true)

func _on_move_state_state_processing(delta: float) -> void:
	
	$"../..".velocity.x = %state_chart.direction.x*delta*SPEED
	$"../..".velocity.z = %state_chart.direction.z*delta*SPEED
	
	if %state_chart.direction == Vector3.ZERO :
		$"../../StateChart".send_event("player_stopped")
	

func _on_move_state_state_exited() -> void:
	%state_chart.set_anim_parameter("is_moving",false)
	if multiplayer.is_server() :
		$"../../AudioStreamPlayer3D".finished.disconnect(on_audio_stream_player_3d_finished)
		%state_chart.set_anim_param_on_peers.rpc("is_moving",false)


func on_audio_stream_player_3d_finished() -> void:
	%state_chart.play_sound($"../..".footsteps_sounds)
	if multiplayer.is_server() :
		%state_chart.play_sound_on_peers.rpc($"../..".footsteps_sounds)

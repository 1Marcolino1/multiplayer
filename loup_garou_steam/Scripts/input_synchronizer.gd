extends MultiplayerSynchronizer


var mouse_sensitivity= 20

func _ready() -> void:
	if get_multiplayer_authority() != multiplayer.get_unique_id() :
		set_process(false)
		set_physics_process(false)
		set_process_input(false)
	else :
		%Camera3D.current = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("escape") :
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	var direction = determine_direction()
	send_dir_to_serv.rpc_id(1,direction)
	if Input.is_action_just_pressed("attack") && !%state_chart.attack_input :
		send_attack_input_to_serv.rpc_id(1,true)
		%state_chart.attack_input = true
	if Input.is_action_just_pressed("hold_attack") && !%state_chart.hold_input :
		send_attack_hold_input_to_serv.rpc_id(1,true)
		%state_chart.hold_input = true
	
func _input(event):
	if event is InputEventMouseMotion :
		var rot = -event.relative * mouse_sensitivity
		send_camera_rot_to_peers.rpc_id(1,rot)
	


func determine_direction() :
	var direction = Vector3.ZERO
	if Input.is_action_pressed("ui_left") :
		direction.x -= 1
	if Input.is_action_pressed("ui_right") :
		direction.x += 1
	if Input.is_action_pressed("ui_up") :
		direction.z -= 1

	if Input.is_action_pressed("ui_down") :
		direction.z += 1
	return  direction
	
@rpc("any_peer","call_local","unreliable")
func send_dir_to_serv(dir) :
	%state_chart.direction = $"..".transform.basis*dir.normalized()
	dir = Vector2(clampf(dir.x,-1,1),clampf(-dir.z,-1,1))
	%state_chart.set_anim_blend_parameter("HurtBlend/Movement/blend_position",dir)
	%state_chart.set_anim_blend_parameter("Movement/blend_position",dir)
	%state_chart.set_anim_blend_parameter("AttackBlend/BlendSpace2D/blend_position",dir)
	%state_chart.set_anim_blend_parameter("parameters/ThrowBlend/BlendSpace2D/blend_position",dir)
	%state_chart.set_anim_param_blend_on_peers.rpc("HurtBlend/Movement/blend_position",dir)
	%state_chart.set_anim_param_blend_on_peers.rpc("Movement/blend_position",dir)
	%state_chart.set_anim_param_blend_on_peers.rpc("AttackBlend/BlendSpace2D/blend_position",dir)
	%state_chart.set_anim_param_blend_on_peers.rpc("parameters/ThrowBlend/BlendSpace2D/blend_position",dir)
	
	
@rpc("authority","call_local","unreliable")
func send_camera_rot_to_peers(rot) :
	%state_chart.camera_rot_y = rot.x
	%state_chart.camera_rot_x = rot.y

@rpc("authority","call_local","unreliable")
func send_attack_input_to_serv(value) :
	%state_chart.attack_input = value

@rpc("authority","call_local","unreliable")
func send_attack_hold_input_to_serv(value) :
	%state_chart.hold_input = value

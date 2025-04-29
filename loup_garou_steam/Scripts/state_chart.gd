extends Node

var direction = Vector3.ZERO
var camera_rot_y = 0
var camera_rot_x = 0
var last_rot_y = -1
var last_rot_x = -1
var attack_input = false
var hold_input = false 
var last_pos = Vector3.ZERO

var sub_suffix = "Dom/conditions/"
var dom_suffix =  "Sub/conditions/"

@export var model:Node3D

func _ready() -> void:
	if multiplayer.get_unique_id() == $"..".player_id :
		model.head.visible = false
		model.body.visible = false
		model.hat.visible = false
		
	if multiplayer.is_server() :
		model.axe_hit_box.body_entered.connect(%health_component.take_damage_on_serv_peers)




func _physics_process(delta: float) -> void:
	if $"..".player_id == multiplayer.get_unique_id() && !multiplayer.is_server() :
		$"..".move_and_slide()
	if multiplayer.is_server() :
		$"..".move_and_slide()
		if last_pos != $"..".global_position :
			last_pos = $"..".global_position
			sync_pos_on_peers.rpc($"..".global_position)
	

func _process(delta: float) -> void:
	if get_multiplayer_authority() == multiplayer.get_unique_id()   :
		if last_rot_y != camera_rot_y :
			last_rot_y = camera_rot_y
			var current_rot_y = $"..".rotation.y
			$"..".rotation.y = lerp_angle($"..".rotation.y,current_rot_y + camera_rot_y*delta,delta*10)
		
		if last_rot_x != camera_rot_x :
			last_rot_x = camera_rot_x
			var current_rot_x = %Camera3D.rotation.x
			%Camera3D.rotation.x = lerp_angle(%Camera3D.rotation.x,clamp(current_rot_x + camera_rot_x*delta,deg_to_rad(-20),deg_to_rad(30)),delta*10) 
		send_camera_rot_to_peers.rpc(Vector2(%Camera3D.rotation.x ,$"..".rotation.y))
		
func set_anim_parameter(parameter,value) :
	model.get_node("AnimationTree").set("parameters/conditions/" + parameter,value)

func set_anim_blend_parameter(parameter,value) :
	model.get_node("AnimationTree").set("parameters/" + parameter,value)

func play_anim(anim_name) :
	model.get_node("AnimationPlayer").play(anim_name)


@rpc("call_remote","authority","unreliable")
func sync_pos_on_peers(pos) :
	$"..".global_position = pos

@rpc("call_remote","authority","unreliable")
func send_rot_to_peers(rot) :
	$"..".rotation = rot

@rpc("call_remote","authority","unreliable")
func send_camera_rot_to_peers(rot) :
	$"..".rotation.y = rot.y
	%Camera3D.rotation.x = rot.x

@rpc("call_remote","authority","unreliable")
func set_anim_param_on_peers(param,value) :
	if multiplayer.get_unique_id() ==  $"..".player_id :
		return
	set_anim_parameter(param,value)

@rpc("call_remote","authority","unreliable")
func set_anim_param_blend_on_peers(param,value) :
	set_anim_blend_parameter(param,value)

@rpc("call_remote","authority","unreliable")
func send_anim_to_peers(anim_name) :
	play_anim(anim_name)

@rpc("call_remote","authority","reliable")
func remove_entity_on_peers() :
	$"..".queue_free()

func stop_sound() :
	$"../AudioStreamPlayer3D".stop()

func play_sound(sounds) :
	var stream = AudioStreamRandomizer.new()
	for i in range(sounds.size()) :
		stream.add_stream(i,sounds[i])
	$"../AudioStreamPlayer3D".stream = stream
	$"../AudioStreamPlayer3D".play()

@rpc("authority","call_remote","unreliable")
func play_sound_on_peers(sounds) :
	play_sound(sounds)

@rpc("authority","call_remote","unreliable")
func stop_sound_on_peers() :
	stop_sound()

@rpc("any_peer","call_local","reliable")
func ask_initial_params(asker_id) :
	sync_initial_parameters.rpc_id(asker_id,$"..".rotation,$"..".global_position)

@rpc("authority","call_local","reliable")
func sync_initial_parameters(rot,pos) :
	$"..".rotation = rot
	$"..".global_position = pos

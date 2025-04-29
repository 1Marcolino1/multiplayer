extends Node

@export var model:Node3D
var last_pos = Vector3.ZERO
var last_rot = Vector3(-1,-1,-1)

var target

var in_range_distance = 1.5

func _ready() -> void:
	var _model = $"..".entity_type.model.instantiate()
	$"..".add_child.call_deferred(_model)
	model = _model
	if multiplayer.is_server() :
		model.get_node("HitBoxArea3D").body_entered.connect(%health_component.take_damage_on_serv_peers)

func _physics_process(delta: float) -> void:
	if multiplayer.is_server() :
		$"..".move_and_slide()
		if last_pos != $"..".global_position :
			last_pos =  $"..".global_position
			sync_pos_on_peers.rpc($"..".global_position)
		if last_rot != $"..".rotation :
			last_rot = $"..".rotation
			send_rot_to_peers.rpc($"..".rotation)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if target == null && body != get_parent() && body is CharacterBody3D :
		target = body

func _on_area_3d_body_exited(body: Node3D) -> void:
	if target ==  body  :
		target = null
		$"../StateChart".send_event("no_target")

@rpc("authority","call_remote","unreliable")
func sync_pos_on_peers(pos) :
	$"..".global_position = pos

func set_anim_parameter(parameter,value) :
	model.get_node("AnimationTree").set("parameters/conditions/" + parameter,value)

@rpc("call_remote","authority","unreliable")
func set_anim_param_on_peers(param,value) :
	if multiplayer.get_unique_id() == $"..".player_id :
		return
	set_anim_parameter(param,value)

@rpc("call_remote","authority","reliable")
func send_rot_to_peers(rot) :
	$"..".rotation = rot

@rpc("call_remote","authority","reliable")
func remove_entity_on_peers() :
	$"..".queue_free()


func play_sound(sounds) :
	var stream = AudioStreamRandomizer.new()
	for i in range(sounds.size()) :
		stream.add_stream(i,sounds[i])
	$"../AudioStreamPlayer3D".stream = stream
	$"../AudioStreamPlayer3D".play()

@rpc("authority","call_remote","unreliable")
func play_sound_on_peers(sounds) :
	play_sound(sounds)

extends CharacterBody3D

@export var entity_type:Entity
@export var attack_sounds:Array[AudioStream]
@export var hurt_sounds:Array[AudioStream]
@export var footsteps_sounds:Array[AudioStream]

var player_id := 1:
	set(id) :
		player_id = id
		%InputSynchronizer.set_multiplayer_authority(id)

var role

func _ready() -> void:
	if multiplayer.get_unique_id() != $".".player_id :
		%state_chart.ask_initial_params.rpc_id(1,multiplayer.get_unique_id())

extends RigidBody3D

var init_pos
var launcher
var force
var direction
var forward_direction

var initial_height

@export var hitbox:Area3D



func _ready() -> void:
	if multiplayer.is_server() :
		hitbox.body_entered.connect(destroy)
		look_at(direction)
		linear_velocity = Vector3(0,initial_height,0)
		apply_impulse(direction*10)

		

func _physics_process(delta: float) -> void:
	if multiplayer.is_server() :
		sync_on_peer.rpc(global_position,global_rotation)
		apply_torque(-transform.basis.x*100*delta)

@rpc("authority","call_remote","unreliable")
func sync_on_peer(pos,rot) :
	$".".global_position = pos
	$".".global_rotation = rot

func destroy(body) :
	if body != launcher :
		queue_free()
		destroy_on_peers.rpc()
	
@rpc("authority","call_remote","reliable")
func destroy_on_peers() :
	queue_free()


func _on_timer_timeout() -> void:
	if multiplayer.is_server() :
		destroy(null) 

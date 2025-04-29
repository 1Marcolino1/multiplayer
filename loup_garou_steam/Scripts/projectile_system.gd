extends Node

@export var projectile_scene:PackedScene

func create_projectile(force,direction) :
	if multiplayer.is_server() :
		print("the dir is " + str(direction))
		var proj = projectile_scene.instantiate()
		
		proj.initial_height = (%Camera3D.rotation.x + 2)*3
		print("init height is " + str( (%Camera3D.rotation.x + 2)*10) )
		proj.force = force
		proj.direction = direction
		proj.launcher = $".."
		get_tree().get_root().get_node("Game").get_node("Projectiles").add_child(proj,true)
		proj.global_position = $Marker3D.global_position
		proj.hitbox.body_entered.connect(%health_component.take_damage_on_serv_peers)
		proj.sync_on_peer(proj.global_position,proj.global_rotation)
		play_sound_on_peers() 
		play_sound_on_peers.rpc()


@rpc("authority","call_remote","unreliable")
func play_sound_on_peers() :
	$AudioStreamPlayer3D.play()

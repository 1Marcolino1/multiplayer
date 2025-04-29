extends Node

var health =100
var max_health = 100

func take_damage(amount) :
	health = clamp(health - amount,0,max_health)
	print("health " + str(health) + " player ")
	if multiplayer.is_server() :
		if health > 0 :
			$"../StateChart".send_event("is_hurt")
		else :
			$"../StateChart".send_event("is_dead")


func take_damage_on_serv_peers(body) :
	if body != $".." && body is CharacterBody3D :
		body.get_node("health_component").take_damage(10)
		body.get_node("health_component").update_health_on_peers.rpc(body.get_node("health_component").health)
		if body.get_node("health_component").health == 0 :
			get_tree().get_root().get_node("Game/Systems/quest_system").kills[$"..".entity_type] = 1

@rpc("authority","call_remote","reliable")
func update_health_on_peers(curr_health) :
	health = curr_health

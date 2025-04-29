extends Node

var floor_contact = 0
var gravity = 60

func _physics_process(delta: float) -> void:
	if multiplayer.is_server() :
		if floor_contact <= 0 :
			$"..".velocity.y += -gravity*delta 
		else :
			$"..".velocity.y = 0


func _on_floor_detector_area_entered(area: Area3D) -> void:
	floor_contact += 1


func _on_floor_detector_area_exited(area: Area3D) -> void:
	floor_contact -= 1

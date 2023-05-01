extends GoapAction

class_name BuildFireAction

func get_clazz(): return "BuildFirepitAction"

const Firepit = preload("res://scenes/firepit.tscn")

func perform(actor, delta):
	var closest = WorldState.get_closest_element("firepit_spot", actor)
	if closest.position.distance_to(actor.position) < 1:
		#make a firepit and place it
		var firepit = Firepit.instantiate()
		actor.get_parent().add_child(firepit)
		firepit.position = closest.position
		WorldState.set_state("has_wood", false)
		return true
	else:
		#too far away, need to go to location first
		#actor.move_to(actor.position.direction_to(closest.position), delta) #doesn't work
		var moveDirection = closest.position - actor.position
		actor.move_to(moveDirection, delta)
		return false

func get_preconditions():
	return {"has_wood": true}
func get_effects() -> Dictionary:
	#return {"has_firepit":true}
	return {"has_firepit": true, "has_wood": false} 

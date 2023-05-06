#action for searching and collecting mushroom 

extends GoapAction

class_name CollectMushroomAction

var _target_mushroom

func get_clazz():
	return "CollectMushroomAction"

#collecting mushrooms should only be available, if mushrooms exist on map
func is_valid() -> bool:
	if WorldState.get_elements("food"):
		return true
	else:
		return false

func get_cost(_blackboard) -> int:
	#What cost does looking for and collecting a mushroom need?
	return 5

#only collect mushroom when no mushroom in inventory
func get_preconditions() -> Dictionary:
	return {"has_mushroom": false}

func get_effects() -> Dictionary:
	return {"has_mushroom": true}

func perform(_actor, delta):

	#get position of nearest mushroom
	var nearest_mushroom = WorldState.get_closest_visible_element("food", _actor)

	if nearest_mushroom != null:
		var moveDirection = nearest_mushroom.position - _actor.position

		#if npc isnt arrived at mushroom yet: move to it
		if _actor.position.distance_to(nearest_mushroom.position) > 1:
			_actor.move_to(moveDirection, delta) #move to nearest mushroom, then collect it
			return false
		
		#if npc is arrived at mushroom: collect it and start regrow process
		nearest_mushroom.regrow()
		WorldState.set_state("has_mushroom", true)
		return true
	# Shouldn't happen, but it's better for the action to be "finished" if it is impossible
	return true
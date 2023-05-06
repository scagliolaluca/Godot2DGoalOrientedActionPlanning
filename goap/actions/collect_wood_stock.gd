#action for searching and collecting wood from a wood stock 

extends GoapAction

class_name CollectWoodStockAction

var _target_wood

func get_clazz():
	return "CollectWoodStockAction"

#collecting a wood stock should only be available, if a wood stock exists on map
func is_valid() -> bool:
	if WorldState.get_elements("wood_stock"):
		return true
	else:
		return false

func get_cost(_blackboard) -> int:
	# Lower cost than cutting a tree; only distance to walk relevant
	var wood = WorldState.get_closest_element("wood_stock", _blackboard) #reference in function has to be the player
	if wood:
		return wood.position.distance_to(_blackboard.position)
	else:
		return 1000 # Failsafe, shouldn't happen

#only collect wood when no wood in inventory
func get_preconditions() -> Dictionary:
	return {"has_wood": false}

func get_effects() -> Dictionary:
	return {"has_wood": true}

func perform(_actor, delta):
	#get position of nearest wood
	var nearest_wood = WorldState.get_closest_visible_element("wood_stock", _actor)

	if nearest_wood != null:
		var moveDirection = nearest_wood.position - _actor.position

		#if npc isnt arrived at wood yet: move to it
		if _actor.position.distance_to(nearest_wood.position) > 1:
			_actor.move_to(moveDirection, delta) #move to nearest wood stock, then collect it
			return false
		
		#if npc is arrived at wood: collect it
		nearest_wood.queue_free()
		WorldState.set_state("has_wood", true)
		return true
	# Shouldn't happen, but it's better for the action to be "finished" if it is impossible
	return true

extends GoapAction

class_name DrinkAction

func get_clazz(): return "DrinkAction"

func get_preconditions():
	return {}

func get_effects():
	return {"has_drunk":true}

func is_valid():
	return true

func get_cost(_blackboard) -> int:
    #if we had a player object here, we could calculate the distance and make it the cost.
	return 12

func perform(actor,delta):
	var water = WorldState.get_closest_element("water_spot", actor)
	if water:
		if water.position.distance_to(actor.position) < 2: #just like in firepit
            #is instant for now. better would be like tree.
            WorldState.set_state("has_drunk",true)
			return true
		else:#has to move
			var moveDirection = water.position - actor.position
			actor.move_to(moveDirection, delta)
	return false

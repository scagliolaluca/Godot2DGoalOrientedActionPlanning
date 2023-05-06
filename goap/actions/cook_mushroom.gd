#Action-file for cooking mushrooms

extends GoapAction

class_name CookAction

func get_clazz():
	return "CookAction"

#Valid when Npc has mushroom but no cooked mushroom
func is_valid() -> bool:
	if WorldState.get_state("has_mushroom", false) and not WorldState.get_state("has_food", false) and WorldState.get_state("has_firepit", false):
		return true
	else:
		return false

#Eating is basic need, so no cost for that
func get_cost(_blackboard) -> int:
	return 5

#Check preconditions for eating-action
func get_preconditions() -> Dictionary:
	return {"has_food": false, "has_mushroom": true, "has_firepit": true}

#Cooking mushroom adds food, and takes away raw mushrooms
func get_effects() -> Dictionary:
	return {"has_food": true, "has_mushroom": false}

#return true, if food is cooked
func perform(_actor, _delta):

	var closestFirepit = WorldState.get_closest_element("firepit_spot", _actor)
	if closestFirepit.position.distance_to(_actor.position) < 1:

		#if arrived at Firepit
		
		WorldState.set_state("has_food", true)
		WorldState.set_state("has_mushroom", false)
		return true
	else:
		var moveDirection = closestFirepit.position - _actor.position
		_actor.move_to(moveDirection, _delta)
		return false


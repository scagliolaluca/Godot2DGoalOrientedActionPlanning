extends GoapAction

class_name DrinkAction

const Water = preload("res://scenes/water.tscn")

func get_clazz(): return "DrinkAction"

func get_preconditions():
	return {}

func get_effects():
	return {"has_drunk":true}

func get_cost(_blackboard) -> int:
	return 12

func perform(actor,delta):
	var nearestwater = WorldState.get_closest_element("water_spot", actor)
	if nearestwater:
		if nearestwater.position.distance_to(actor.position) < 2: #just like in firepit
			var water = Water.instantiate()
			actor.get_parent().add_child(water)
			WorldState.set_state("has_drunk",true)
			return true
		else:#has to move
			var moveDirection = nearestwater.position - actor.position
			actor.move_to(moveDirection, delta)
	return false

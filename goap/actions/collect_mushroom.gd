extends GoapAction

class_name CollectMushroomAction

var _target_mushroom

func get_clazz():
	return "CollectMushroomAction"

#probably collecting mushrooms should always be available???
func is_valid() -> bool:
	return true

func get_cost(_blackboard) -> int:
	#What cost does looking for and collecting a mushroom need?
	return 5

#probably no preconditions needed??
func get_preconditions() -> Dictionary:
	return {}

func get_effects() -> Dictionary:
	return {"has_food": 1}

func perform(_actor, delta):

    #get position of nearest mushroom
	var mushrooms = get_tree().get_nodese_in_group("mushroom")
	var nearest_mushroom = null
	var nearest_distance = 9999999
	for mushroom in mushrooms:
		var distance = _actor.get_position().distance_to(mushroom.get_postition())
		if distance < nearest_distance:
			nearest_mushroom = mushroom
			nearest_distance = distance

	if nearest_mushroom != null:
		_target_mushroom = nearest_mushroom

    #move to nearest mushroom and collect it
		#Does this actually work??
		_actor.move_to(_target_mushroom, delta) #move to nearest mushroom, then collect it
	
		#update has_food WorldState
		var food_state = WorldState.get_state("has_food")
		food_state = food_state + 1
		WorldState.set_state("has_food", food_state)

		return true

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
	
	#use this for food_state = int
	#var food_state = WorldState.get_state("has_food")
	#food_state = food_state + 1
	#return {"has_food": food_state}

	#use this for food_state = bool
	return {"has_food": true}

func perform(_actor, delta):

	#get position of nearest mushroom
	var nearest_mushroom = WorldState.get_closest_element("food", _actor)

	if nearest_mushroom != null:
		var moveDirection = nearest_mushroom.position - _actor.position

		#move to nearest mushroom and collect it
		if _actor.position.distance_to(nearest_mushroom.position) > 1:
			_actor.move_to(moveDirection, delta) #move to nearest mushroom, then collect it
			return false
		
		#delete mushroom from scenen after NPC consumed
		nearest_mushroom.queue_free()
		
		#use this for food_state = int
		#update has_food WorldState when NPC is arrived
		#var food_state = WorldState.get_state("has_food")
		#if food_state:
		#	food_state = food_state + 1
		#	WorldState.set_state("has_food", food_state)
		#else:
		#	WorldState.set_state("has_food", 1)

		#return true

		#use this for food_state = bool
		WorldState.set_state("has_food", 1)
		return true

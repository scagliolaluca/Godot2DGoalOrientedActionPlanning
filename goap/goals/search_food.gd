extends GoapGoal

class_name SearchFoodGoal

func get_clazz(): return "SearchFoodGoal"

#always valid
func is_valid() -> bool:
	return true

#set prioritys for searchFood, depending on how much food the NPC has already collected
func priority() -> int:
	var food_state = WorldState.get_state("has_food")
	
	#use this later for has_food = int:
	#if not food_state: #same as: if food == 0 or food == none: #couldn't recover any food if needed
	#	return 100
	#elif food_state == 1: #already could recover 20 food
	#	return 60
	#elif food_state == 2: #already could recover 60 food
	#	return 20
	#else: # food_state > 2
	#	return 0

	#use this for has_food = bool:
	if food_state: #if food available
		return 0
	else: #if no food available
		return 5

func get_desired_state() -> Dictionary:
	var food_state = WorldState.get_state("has_food")
	if food_state == null:
		food_state = 0
		# for food_state = int: WorldState.set_state("has_food", food_state)

		#for food_state = bool:
		WorldState.set_state("has_food", false)

	#food_state = food_state + 1 #for food_state = int
	return{"has_food": true} # for food_state = int: return{"has_food": food_state}

#Goal for cooking mushrooms to get food

extends GoapGoal

class_name CookGoal

func get_clazz(): return "CookGoal"

#mushrooms can be cooked, if npc carrys no other cooked mushroom with him and if he has a mushroom to cook
func is_valid() -> bool:
	if WorldState.get_state("has_mushroom", false) and not WorldState.get_state("has_food", false) and WorldState.get_state("has_firepit", false):
		return true
	else:
		return false

#set prioritys for eating, depending on how hungry the NPC is (its hunger is its priority)
func priority() -> int:
	#var _hunger = WorldState.get_state("hunger", 0)
	#return _hunger
	var food_state = WorldState.get_state("has_food", 0)
	if food_state: #if food available
		return 0
	else: #if no food available
		return 5


func get_desired_state() -> Dictionary:
	return {"has_food": true}

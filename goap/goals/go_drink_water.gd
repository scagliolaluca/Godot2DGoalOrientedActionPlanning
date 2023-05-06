#search_food goal. This script allows the npc to collect food, even if he isn't hungry at the moment
#if he has nothing to do with higher priority, he will collect food to be able to eat when hungry, 
#and relax only if he has food stored

extends GoapGoal

class_name DrinkGoal

func get_clazz(): return "DrinkGoal"

#always valid
func is_valid() -> bool:
	if WorldState.get_state("has_drunk") == null:
		WorldState.set_state("has_drunk", false)
	return not WorldState.get_state("has_drunk")

#set prioritys for searchFood, depending on how much food the NPC has already collected
func priority() -> int:
	return 6

func get_desired_state() -> Dictionary:
	if WorldState.get_state("has_drunk") == null:
		WorldState.set_state("has_drunk", false)
	return{"has_drunk": true}

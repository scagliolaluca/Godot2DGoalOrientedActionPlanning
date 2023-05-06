#search_food goal. This script allows the npc to collect food, even if he isn't hungry at the moment
#if he has nothing to do with higher priority, he will collect food to be able to eat when hungry, 
#and relax only if he has food stored

extends GoapGoal

class_name SearchFoodGoal

func get_clazz(): return "SearchFoodGoal"

#always valid
func is_valid() -> bool:
	return true

#set prioritys for searchFood, depending on how much food the NPC has already collected
func priority() -> int:
	var food_state = WorldState.get_state("has_mushroom", 0)
	if food_state: #if food available
		return 0
	else: #if no food available
		return 5

func get_desired_state() -> Dictionary:
	var food_state = WorldState.get_state("has_mushroom") #if has_food doesn't exist (in the begining), set it to false
	if food_state == null:
		food_state = 0
		WorldState.set_state("has_mushroom", false)
	return{"has_mushroom": true}

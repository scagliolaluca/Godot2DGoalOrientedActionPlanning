extends Node

class_name SearchFoodGoal

func get_clazz(): return "SearchFoodGoal"

#always valid
func is_valid() -> bool:
    return true

#set prioritys for searchFood, depending on how much food the NPC has already collected
func priority() -> int:
    var food_state = WorldState.get_state("has_food")
    if food_state == 0: #couldn't recover any food if needed
        return 100
    if food_state == 1: #already could recover 20 food
        return 60
    if food_state == 2: #already could recover 60 food
        return 20
    if food_state > 2: 
        return 5
extends GoapAction

class_name EatAction

#var mushroom_instance = null #??? needed? How to acces Mushroom.nutrition in this file?

#func init():
#    mushroom_instance = Mushroom.new()

func get_clazz():
	return "EatAction"

#Check if NPC is near Mushroom/has Mushroom in its hands
func is_valid() -> bool:
	return WorldState.get_state("has_food")

#Eating is basic need, so no cost for that
func get_cost(_blackboard) -> int:
	return 0

#Check preconditions for eating-action
func get_preconditions() -> Dictionary:
	return {"has_food": WorldState.get_state("has_food")}

#Eating food restores hunger, and consumes food
func get_effects() -> Dictionary:
	return {"has_food": -1, "hunger": -30}

#return true, if food is eaten, and hunger is restored
func perform(_actor, _delta):

	#update hunger WorldState
	var hunger_state = WorldState.get_state("hunger")
	var mushroom_script = load("res://scenes//Mushroom.gd")
	var mushroom_instance = mushroom_script.new()
	hunger_state = hunger_state - mushroom_instance.nutrition #somhow need to get the nutrition lvl of the mushroom
	WorldState.set_state("hunger", hunger_state)

	#update has_food WorldState
	var food_state = WorldState.get_state("has_food")
	food_state = food_state - 1
	WorldState.set_state("has_food", food_state)

	return true



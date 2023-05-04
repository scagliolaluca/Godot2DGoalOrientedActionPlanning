#Action-file for eating mushrooms

extends GoapAction

class_name EatAction

func get_clazz():
	return "EatAction"

#Check if NPC is near Mushroom/has Mushroom in its hands
func is_valid() -> bool:
	var food_state = WorldState.get_state("has_food")

	if not food_state: # same as: food_state == null or food_state == 0:
		WorldState.set_state("has_food", false)
		return false

	return true

#Eating is basic need, so no cost for that
func get_cost(_blackboard) -> int:
	return 0

#Check preconditions for eating-action
func get_preconditions() -> Dictionary:
	return {"has_food": true}

#Eating food restores hunger, and consumes food
func get_effects() -> Dictionary:
	return {"has_food": false, "is_hungry": false}

#return true, if food is eaten, and hunger is restored
func perform(_actor, _delta):

	#update hunger WorldState
	var hunger_state = WorldState.get_state("hunger")

	var mushroom = WorldState.get_elements("food")
	
	hunger_state = hunger_state - mushroom[0].nutrition #acces the nutrition of the mushroom and update hunger_state
	if hunger_state <= 0:
		hunger_state = 0

	WorldState.set_state("hunger", hunger_state)
	WorldState.set_state("has_food", false)

	return true



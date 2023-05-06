#Goal for being not-hungry (full)

extends GoapGoal

class_name FullGoal

func get_clazz(): return "FullGoal"

#only valid when NPC is hungry and already has collected food
#if has_food isn't checked, the possibility of selecting that goal without having food exists,
#which ends in infinit loop for looking up action that satisfies full goal (eat action isnt valid because no food)
func is_valid() -> bool:
	if WorldState.get_state("hunger", 0) > 30 and WorldState.get_state("has_food", false):
		return true
	else:
		return false

#set prioritys for eating, depending on how hungry the NPC is (its hunger is its priority)
func priority() -> int:
	var _hunger = WorldState.get_state("hunger", 0)
	return _hunger


func get_desired_state() -> Dictionary:
	return {"is_hungry": false}

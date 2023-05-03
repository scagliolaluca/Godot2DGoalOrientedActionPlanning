extends GoapGoal

class_name FullGoal

func get_clazz(): return "FullGoal"

#only valid when NPC is hungry
func is_valid() -> bool:
	if WorldState.get_state("hunger", 0) > 30:
		return true
	else:
		return false

#set prioritys for eating, depending on how hungry the NPC is
func priority() -> int:
	var _hunger = WorldState.get_state("hunger", 0)
	return _hunger
	#if _hunger <= 30:
	#	return 0
	#elif _hunger <= 60:
	#	return 10
	#elif _hunger > 80:
	#	return 100
	#else:
	#	return 20

func get_desired_state() -> Dictionary:
	return {"is_hungry": false}

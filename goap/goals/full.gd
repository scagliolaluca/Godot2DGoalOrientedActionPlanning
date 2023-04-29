extends GoapGoal

class_name FullGoal

func get_clazz(): return "FullGoal"

#only valid when NPC is hungry
func is_valid() -> bool:
	if WorldState.get_state("hunger"):
		return true
	else:
		return false

func priority() -> int:
	var _hunger = WorldState.get_state("hunger", 0)
	if _hunger <= 30:
		return 1
	elif _hunger <= 60:
		return 5
	elif _hunger > 80:
		return 100
	else:
		return 20

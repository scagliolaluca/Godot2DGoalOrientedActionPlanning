extends GoapGoal

class_name HasLitFireGoal

func get_clazz(): return "HasLitFireGoal"

func get_desired_state():
	return {"has_firepit": true}

#valid goal if firepit number less than a certain number
func is_valid() -> bool:
	return WorldState.get_elements("firepit").size() < 1

func priority():
	return 70

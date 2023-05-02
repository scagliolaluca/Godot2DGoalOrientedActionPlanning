extends GoapGoal

class_name CalmDownGoal

func get_clazz(): return "CalmDownGoal"

func is_valid() -> bool:
	return WorldState.get_state("is_frightened", false)

func priority() -> int:
	# Should be higher than relax, but lower than eating (when very hungry)
	return 1

func get_desired_state() -> Dictionary:
	return {"is_frightened": false}

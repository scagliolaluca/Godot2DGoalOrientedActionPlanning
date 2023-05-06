extends GoapGoal

class_name CalmDownGoal

func get_clazz(): return "CalmDownGoal"

# Calm down is available, if the Satyr is frightened
func is_valid() -> bool:
	return WorldState.get_state("is_frightened", false)
	
# The priority should be higher than relax (do nothing), but lower than eating (at least when very hungry)
# (priority scaling is based on hunger level)
func priority() -> int:
	return 60

# The goal is to stop being frightened
func get_desired_state() -> Dictionary:
	return {"is_frightened": false}

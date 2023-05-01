extends GoapAction

class_name FindCoverAction

func get_clazz(): return "FindCoverAction"

#
# This indicates if the action should be considered or not.
#
# This method is used during planning, but it could
# also be used during execution to abort the plan in case the world state
# does not allow this action anymore.
#
func is_valid() -> bool:
	return not WorldState.get_elements("cover").is_empty()


#
# Action Cost. This function helps handling situational costs, if the world
# state is considered when calculating the cost.
#
func get_cost(_blackboard) -> int:
	# TODO: make dynamic? distance to cover? distance to troll?
	return 1000

#
# Action requirements.
# Example:
# {
#   "has_wood": true
# }
#
func get_preconditions() -> Dictionary:
	return {}


#
# What conditions this action satisfies
#
# Example:
# {
#   "has_wood": true
# }
func get_effects() -> Dictionary:
	return {"is_frightened": false}


#
# Action implementation called on every loop.
# "actor" is the NPC using the AI.
# "delta" is the time in seconds since last loop.
#
# Returns true when the task is complete.
#
# Check "./actions/chop_tree.gd" for example.
#
func perform(_actor, _delta) -> bool:
	var closestCover = WorldState.get_closest_element("cover", _actor)

#	if closestCover.distance_to(_actor.position) < 1:
	if _actor.position.distance_to(closestCover.position) < 1:

		return _actor.calm_down()
	
	var moveDirection = closestCover.position - _actor.position
	_actor.move_to(moveDirection, _delta)

	return false

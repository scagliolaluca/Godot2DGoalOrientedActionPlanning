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
	# Find cover requires a "cover" object to be present (should always be available)
	return not WorldState.get_elements("cover").is_empty()


#
# Action Cost. This function helps handling situational costs, if the world
# state is considered when calculating the cost.
#
func get_cost(_blackboard) -> int:
	# Cost is currently irrelevant since there are no alternative actions, to stop being frightened
	return 1

#
# Action requirements.
# Going to a cover doesn't require any ressources
#
func get_preconditions() -> Dictionary:
	return {}


#
# What conditions this action satisfies
# Going into cover stopps the Satyr from being frightened
#
func get_effects() -> Dictionary:
	return {"is_frightened": false}


#
# Action implementation called on every loop.
# "actor" is the NPC using the AI.
# "delta" is the time in seconds since last loop.
#
# Moves towards the closest cover and starts the calm down timer after arrival.
#
# Returns true when the calm down timer is expired.
#
func perform(_actor, _delta) -> bool:
	# Find the closest cover
	var closestCover = WorldState.get_closest_element("cover", _actor)

	# Do the calm down action if close to a cover
	if _actor.position.distance_to(closestCover.position) < 1:
		return _actor.calm_down()
	
	# Alternatively: Move towards the closest cover
	var moveDirection = closestCover.position - _actor.position
	_actor.move_to(moveDirection, _delta)

	return false

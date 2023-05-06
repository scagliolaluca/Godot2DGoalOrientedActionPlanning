extends GoapAction

class_name ChopTreeAction

func get_clazz(): return "ChopTreeAction"

func get_preconditions():
	var _has_wood = WorldState.get_state("has_wood")
	if _has_wood == null:
		_has_wood = false
		WorldState.set_state("has_wood", _has_wood)

	return {"has_wood":false}

func get_effects():
	return {"has_wood":true}

func is_valid():
	return WorldState.get_elements("tree").size()>0

func get_cost(_blackboard) -> int:
	# Cost consists of chopping the tree (fixed) + distance to walk
	var someTree = WorldState.get_closest_element("tree", _blackboard) #reference in function has to be the player
	if someTree:
		return someTree.position.distance_to(_blackboard.position) + 100
	else:
		return 1000 # Failsafe, shouldn't happen

func perform(actor,delta):
	var someTree = WorldState.get_closest_visible_element("tree", actor)
	if someTree:
		if someTree.position.distance_to(actor.position) < 2: #just like in firepit
			if actor.chop_tree(someTree):
				#set wood state!
				WorldState.set_state("has_wood",true)
				return true
		else:#has to move
			var moveDirection = someTree.position - actor.position
			actor.move_to(moveDirection, delta)
	return false

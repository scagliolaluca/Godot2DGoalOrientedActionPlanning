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
	#What cost does looking for and chopping a tree have?
	#return 6
	#how about the distance to it, capped at a certain point
	#var someTree = WorldState.get_closest_element("tree", player) #we dont have a player here
	#if someTree:
	#	return max(someTree.position.distance_to(player.position),10)
	#else:
	return 10 #idk no tree then?

func perform(actor,delta):
	var someTree = WorldState.get_closest_element("tree", actor)
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

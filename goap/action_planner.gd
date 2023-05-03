
# The Planner. GOAP's heart.
#
extends Node

class_name GoapActionPlanner

var _actions: Array

#
# class to store plans
#
class Plan:
	var actions
	var cost
	
	func _init(_actions, _cost):
		actions = _actions
		cost = _cost
#
# Set actions available for planning.
# This can be changed in runtime for more dynamic options.
#
func set_actions(actions: Array):
	_actions = actions


#
# Receives a goal and an optional blackboard.
# Returns a list of actions to be executed.
#
func get_plan(goal: GoapGoal, blackboard = {}) -> Array:
	print("Goal: %s" % goal.get_clazz())
	WorldState.console_message("Goal: %s" % goal.get_clazz())
	#get the desired goal and find the best plan to achieve it
	var desired_state = goal.get_desired_state().duplicate()
	#If there is no desired state we can't find a plan to achieve it so retun empty array
	if desired_state.is_empty():
		return []
	return _find_best_plan(goal, desired_state, blackboard)


#
# Uses private methods _build_plans, _transform_tree_into_array,
# _get_cheapest_plan to calculate the best overall plan.
#
func _find_best_plan(goal, desired_state, blackboard):
	#dictionary can be changed in function (like a pointer), so you can only return bool in _build_plans

	var tree = {
			"children": [],
			"desired_states": desired_state,
		}
	if _build_plans(tree, blackboard):
		
		return _get_cheapest_plan(_transform_tree_into_array(tree, blackboard))
	else:
		WorldState.console_message({"Warning": "No plan found"})
		return []



#
# Compares plans' costs.
# Returns actions included in the cheapest plan.
#
func _get_cheapest_plan(plans):
	#cycle through all plans and compare costs
	var cheapest_plan = plans[0]
	_print_plan(plans[0])
	for i in range(1, plans.size()):
		_print_plan(plans[i])
		if plans[i].cost < cheapest_plan.cost:
			cheapest_plan = plans[i]
	return cheapest_plan.actions



#
# Builds graph with actions. Only includes valid plans
# (plans that achieve the goal).
#
# Returns true if the path has a solution.
#
# This function should use recursion to build the graph. This is
# necessary because any new action included in the graph may
# add pre-conditions to the desired state that can be satisfied
# by previously considered actions, meaning, on every step we
# need to iterate from the beginning to find all solutions.
#
# Be aware that for simplicity, the current implementation is not protected from
# circular dependencies. This is easy to implement though.
#
func _build_plans(step, blackboard):
	#indicates if a valid plan exist
	var valid_plan = false
	for action in _actions:
		if action.is_valid():
			var effects = action.get_effects()
			for effect in effects:
				for desired_state in step.desired_states:
					if {effect: effects[effect]} == {desired_state: step.desired_states[desired_state]}:
						#neccessary for multible preconditions
						var conditions = step.desired_states.duplicate()
						conditions.erase(effect)
						conditions.merge(action.get_preconditions())
						if conditions != {}:
							
							#var next_step ={
							#	"action": action,
							#	"children": [],
							#	"desired_states": conditions
							#	}
							#valid_plan = true
							#step.children.append(_build_plans(next_step, blackboard))
					
							#LucaTEST:
							for condition in conditions:
								if WorldState.get_state(condition) == conditions[condition]:
									var final_step ={
									"action": action,
									"children": [],
									"desired_states": {}
									}
									
									#valid_plan = true
									step.children.append(final_step)
									valid_plan = true
								else:
									var next_step ={
										"action": action,
										"children": [],
										"desired_states": conditions
										}
									valid_plan = true
									if _build_plans(next_step, blackboard):
										step.children.append(next_step)
					
					
						else:
							var final_step ={
									"action": action,
									"children": [],
									"desired_states": {}
								}
							step.children.append(final_step)
							valid_plan = true
	
	return valid_plan	
	#if valid_plan == true:
	#	return step
	
#	var valid_plan = false
#	#go through all actions and check if they have the d esired effect
#	for desired_state in step.desired_states:
#		for action in _actions:
#			for effect in action.get_effects():
#				if desired_state == effect:
#					#for actions that have the desired effect repeat
#					var preconditions = action.get_preconditions()
#					if preconditions:
#						for precondition in action.get_preconditions():
#							var next_step ={
#								"action": action,
#								"children": [],
#								"desired_states": action.get_preconditions()
#							}
#							step.children.add(_build_plans(next_step, blackboard))
#					# if there are not preconditions it is the end of the plan
#					else:
#						valid_plan = true
#	return valid_plan


#
# Transforms graph with actions into list of actions and calculates
# the cost by summing actions' cost
#
# Returns list of plans.
#
func _transform_tree_into_array(p, blackboard):
	if p.children == []:
		# If the node is a leaf, return a list containing an empty path with zero cost
		return [Plan.new([p.action], p.action.get_cost(blackboard))]
	
	var plans = []
	for child in p.children:
		# recursively get the paans of each child node
		var child_plans = _transform_tree_into_array(child, blackboard)
		# Combine the plans of the child nodes with the action and cost of the current node
		for child_plan in child_plans:
			if "action" in p:
				child_plan.actions.append(p.action)
				child_plan.cost += p.action.get_cost(blackboard)
			plans.append(child_plan)
	return plans


#
# Prints plan. Used for Debugging only.
#
func _print_plan(plan):
	var actions = []
	for a in plan.actions:
		actions.push_back(a.get_clazz())
	print({"cost": plan.cost, "actions": actions})
	WorldState.console_message({"cost": plan.cost, "actions": actions})


# The Planner. GOAP's heart.
#
extends Node

class_name GoapActionPlanner

var _actions: Array

#
# The Plan class is used to store plans
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
	var plan = _find_best_plan(goal, desired_state, blackboard)
	return plan


#
# Uses private methods _build_plans, _transform_tree_into_array,
# _get_cheapest_plan to calculate the best overall plan.
#
func _find_best_plan(goal, desired_state, blackboard):
	# Dictionary can be changed in the function, _build_plans return boolean,
	# but the result is still accessable.

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
	# iterate over all plans and compare costs
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
	# initialize variable to keep track of whether a valid plan exists
	var valid_plan = false
	# iterate over all desired effects and checks if there is a valid action with the desired effect
	for desired_state in step.desired_states:
		for action in _actions:
			if action.is_valid():
				var effects = action.get_effects()
				for effect in effects:
						if {effect: effects[effect]} == {desired_state: step.desired_states[desired_state]}:
							# When an action has a desired effect:
							# Copy desired_states, because we are iterating over them.
							# Erase the actions effect from the conditions and add the preconditions.
							var conditions = step.desired_states.duplicate()
							conditions.erase(effect)
							conditions.merge(action.get_preconditions())
							
							# Then erase all conditions that have allready been met
							# After that conditions are all the desired states that have not been adress after the current action.
							var keys_to_delete_from_dictionary = []
							for condition in conditions:
								if WorldState.get_state(condition) == conditions[condition]:
									keys_to_delete_from_dictionary.append(condition)
							for key in keys_to_delete_from_dictionary:
								conditions.erase(key)
							
							if conditions != {}:
#								# when conditions is not empty, the plan is not finished, so we add a child in which we recursively call this function
										var next_step ={
											"action": action,
											"children": [],
											"desired_states": conditions
											}
										valid_plan = _build_plans(next_step, blackboard)
										if valid_plan:
											step.children.append(next_step)

							else:
								# when conditions is empty, the plan is finnished. so we add a child with the current action and
								# set valid_plan to true, because we found a valid plan
								var final_step ={
										"action": action,
										"children": [],
										"desired_states": {}
									}
								step.children.append(final_step)
								valid_plan = true

	return valid_plan


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

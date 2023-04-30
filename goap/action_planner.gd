#
# The Planner. GOAP's heart.
#
extends Node

class_name GoapActionPlanner

var _actions: Array


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
	# TODO: fill with logic
	return [_actions[2], _actions[2], _actions[2], _actions[1], _actions[2], _actions[2], _actions[1]]



#
# Uses private methods _build_plans, _transform_tree_into_array,
# _get_cheapest_plan to calculate the best overall plan.
#
func _find_best_plan(goal, desired_state, blackboard):
	# TODO: fill with logic
	return []



#
# Compares plans' costs.
# Returns actions included in the cheapest plan.
#
func _get_cheapest_plan(plans):
	# TODO: fill with logic
	return []



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
	# TODO: fill with logic
	return false


#
# Transforms graph with actions into list of actions and calculates
# the cost by summing actions' cost
#
# Returns list of plans.
#
func _transform_tree_into_array(p, blackboard):
	# TODO: fill with logic
	return []



#
# Prints plan. Used for Debugging only.
#
func _print_plan(plan):
	var actions = []
	for a in plan.actions:
		actions.push_back(a.get_clazz())
	print({"cost": plan.cost, "actions": actions})
	WorldState.console_message({"cost": plan.cost, "actions": actions})

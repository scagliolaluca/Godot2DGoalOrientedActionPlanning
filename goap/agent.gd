#
# This script integrates the actor (NPC) with goap.
# In your implementation you could have this logic
# inside your NPC script.
#
# As good practice, I suggest leaving it isolated like
# this, so it makes re-use easy and it doesn't get tied
# to unrelated implementation details (movement, collisions, etc)
extends Node

class_name GoapAgent

var _goals
var _current_goal
var _current_plan
var _current_plan_step = 0

var _actor

#
# On every loop this script checks if the current goal is still
# the highest priority. If it's not, it requests the action planner a new plan
# for the new high priority goal. Otherwise it follows the current plan.
#
# Remeber: You can set in the blackboard any relevant information you want to use
# when calculating action costs and status (e.g. the actor's position).
#
func _process(delta):
	# TODO: fill with logic
	#return

	var blackboard = {} # TODO: Fill with information

	var bestGoal = _get_best_goal()
	if bestGoal != _current_goal:
		_current_plan = Goap.get_action_planner().get_plan(bestGoal, blackboard)
		_current_plan_step = 0
		_current_goal = bestGoal

	_follow_plan(_current_plan, delta)

	return



func init(actor, goals: Array):
	_actor = actor
	_goals = goals


#
# Returns the highest priority goal available.
#
func _get_best_goal():
	# TODO: fill with logic
	#return

	var bestGoal = null
	for goal in _goals:
		if goal.is_valid and (bestGoal == null or bestGoal.priority() < goal.priority()):
			bestGoal = goal

	return bestGoal



#
# Executes plan. This function is called on every game loop.
# "plan" is the current list of actions, and delta is the time since last loop.
#
# If the current plan is empty it does not do anything, otherwise it performs
# the current step of the plan and checks whether it can move to the next
# plan step.
#
# Every action exposes a function called perform, which will return true when
# the job is complete, so the agent can jump to the next action in the list.
#
func _follow_plan(plan, delta):
	# TODO: fill with logic
	#return

	if plan.is_empty() or plan.size() <= _current_plan_step:
		return

	var current_action = plan[_current_plan_step]

	# if a step of the plan is invalid, trigger a re-computation of the plan
	if not current_action.is_valid():
		_current_goal = null
		return
		
	var finished = current_action.perform(_actor, delta)

	if finished:
		_current_plan_step += 1

	return


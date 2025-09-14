class_name BTNInvert extends DecoratorNodeBase

func _on_tick(blackboard: BlackBoardBase, child_result: BehaviorResult) -> BehaviorResult:
	if _child == null:
		return BehaviorResult.Fail

	# Get the tick result
	var result: BehaviorResult = child_result
	if child_result == BehaviorResult.NONE:
		result = _child.tick(BehaviorResult.NONE, blackboard)

	# Return success on child fail
	if result == BehaviorResult.Fail:
		reset_node()
		return BehaviorResult.Success

	# Return fail on child success
	if result == BehaviorResult.Success:
		reset_node()
		return BehaviorResult.Fail

	# Child returned running, so return running
	if result == BehaviorResult.Running:
		return BehaviorResult.Running

	# No valid outcome, fail
	return BehaviorResult.Fail

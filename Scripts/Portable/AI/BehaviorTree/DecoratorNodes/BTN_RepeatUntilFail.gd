class_name BTNRepeatUntilFail extends DecoratorNodeBase

func _on_tick(blackboard: BlackBoardBase, child_result: BehaviorResult) -> BehaviorResult:
	if child_result == BehaviorResult.Fail:
		return BehaviorResult.Success

	if child_result == BehaviorResult.Running:
		return BehaviorResult.Running

	var result: BehaviorResult = _child.tick(BehaviorResult.NONE, blackboard)

	if result == BehaviorResult.Fail:
		return BehaviorResult.Success

	return BehaviorResult.Running

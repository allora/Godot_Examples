class_name BTNAlwaysFail extends DecoratorNodeBase

func _on_tick(blackboard: BlackBoardBase, child_result: BehaviorResult) -> BehaviorResult:
	if _child == null:
		return BehaviorResult.Fail

	var result: BehaviorResult = child_result
	if child_result == BehaviorResult.NONE:
		result = _child.tick(BehaviorResult.NONE, blackboard)

	if result == BehaviorResult.Running:
		return BehaviorResult.Running

	return BehaviorResult.Fail

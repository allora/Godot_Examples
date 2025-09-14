@icon("res://Scripts/Portable/AI/BehaviorTree/icon/selector.svg")

class_name BTNSelector extends CompositeNodeBase

func _on_tick(blackboard: BlackBoardBase, child_result: BehaviorResult) -> BehaviorResult:
	if _children.size() == 0:
		reset_node()
		return BehaviorResult.Fail

	# Fail and reset if the child node calling us reset
	if child_result == BehaviorResult.Success:
		reset_node()
		return BehaviorResult.Success

		# Child returned running, so return running
	if child_result == BehaviorResult.Running:
		return child_result

	var result: BehaviorResult = BehaviorResult.Fail
	while result == BehaviorResult.Fail:
		# First try to exit out if we're out of children
		if _current_index >= _children.size():
			break

		var child_node: BehaviorNodeBase = _children[_current_index]
		_current_index += 1

		result = child_node.tick(BehaviorResult.NONE, blackboard)

	# Child returned running, so return running
	if result == BehaviorResult.Running:
		return result

	# Reset node since all remaining results are end points
	reset_node()

	# if the child failed, fail the whole node
	if result == BehaviorResult.Success:
		return BehaviorResult.Success

	return BehaviorResult.Fail

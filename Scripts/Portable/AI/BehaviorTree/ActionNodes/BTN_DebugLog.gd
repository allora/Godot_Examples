class_name BTNDebugLog extends BehaviorNodeBase

@export
var _msg: String

@export
var _result: BehaviorResult = BehaviorResult.Success

func _on_tick(blackboard: BlackBoardBase, child_result: BehaviorResult) -> BehaviorResult:
	print(_msg)
	return _result

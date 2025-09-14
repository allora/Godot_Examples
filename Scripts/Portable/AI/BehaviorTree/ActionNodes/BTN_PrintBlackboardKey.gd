class_name BTNPrintBlackboardKey extends BehaviorNodeBase

@export
var key: StringName

func _on_tick(blackboard: BlackBoardBase, child_result: BehaviorResult) -> BehaviorResult:
	print("Blackboard Key: ", key, " = ", blackboard.get_by_key(key))
	return BehaviorResult.Success

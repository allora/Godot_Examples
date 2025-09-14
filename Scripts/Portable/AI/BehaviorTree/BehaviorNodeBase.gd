@icon("res://Scripts/Portable/AI/BehaviorTree/icon/behavior_node.svg")

class_name BehaviorNodeBase extends Node

enum BehaviorResult {
	NONE = 1,
	Running = 2,
	Success = 3,
	Fail = 4
}

var _tree: BehaviorTree
var _is_running: bool
var _is_scene_root: bool

func _ready() -> void:
	_is_scene_root = get_parent() == get_tree().root

func init_node(tree: BehaviorTree) -> void:
	_is_running = false
	_tree = tree

func tick(child_result: BehaviorResult, blackboard: BlackBoardBase) -> BehaviorResult:
	var result: BehaviorResult = BehaviorResult.NONE
	_start()

	result = _on_tick(blackboard, child_result)

	if (result > BehaviorResult.Running):
		_stop(blackboard, result, child_result)

	return result

func _start() -> void:
	if !_is_running:
		_tree.push_to_running_stack(self)
		_is_running = true

func _stop(blackboard: BlackBoardBase, result: BehaviorResult, child_result: BehaviorResult) -> void:
	_tree.pop_running_stack()
	_is_running = false

	if _tree.has_running_stack() && child_result > BehaviorResult.NONE:
		var next_stack: BehaviorNodeBase = _tree.peek_running_stack()
		if next_stack != null:
			next_stack.tick(result, blackboard)

func _on_tick(blackboard: BlackBoardBase, child_result: BehaviorResult) -> BehaviorResult:
	return BehaviorResult.Fail

func reset_node() -> void:
	pass

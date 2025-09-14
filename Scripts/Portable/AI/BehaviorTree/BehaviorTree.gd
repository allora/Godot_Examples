@icon("res://Scripts/Portable/AI/BehaviorTree/icon/tree.svg")

class_name BehaviorTree extends Node

@export
var _blackboard: BlackBoardBase
@export
var _root: BehaviorNodeBase

var _running_stack: Array[BehaviorNodeBase]
var _is_initialized: bool = false

func _ready() -> void:
	var parent: Node = get_parent()
	if parent == get_tree().root:
		call_deferred("init_tree")

func init_tree() -> void:
	# init blackboard
	_blackboard.init()

	# init tree
	_root.init_node(self)

	_is_initialized = true

func _process(delta: float) -> void:
	if _is_initialized:
		update_tree()

func update_tree() -> void:
	var node: BehaviorNodeBase
	if has_running_stack():
		node = _running_stack.back()
	else:
		node = _root

	if node != null:
		node.tick(BehaviorNodeBase.BehaviorResult.NONE, _blackboard)

func has_running_stack() -> bool:
	return _running_stack.size() > 0

func push_to_running_stack(node: BehaviorNodeBase) -> void:
	_running_stack.push_back(node)

func pop_running_stack() -> BehaviorNodeBase:
	return _running_stack.pop_back()

func peek_running_stack() -> BehaviorNodeBase:
	return _running_stack.back()

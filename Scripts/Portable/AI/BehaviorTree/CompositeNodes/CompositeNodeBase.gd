class_name CompositeNodeBase extends BehaviorNodeBase

var _current_index: int
var _children: Array[BehaviorNodeBase]

func _ready() -> void:
	_current_index = 0
	_children.clear()

func init_node(tree: BehaviorTree) -> void:
	super.init_node(tree)

	# traverse down tree
	for node in get_children():
		var behavior_node: BehaviorNodeBase = node as BehaviorNodeBase
		if behavior_node != null:
			behavior_node.init_node(tree)
			_children.append(behavior_node)

func reset_node() -> void:
	_current_index = 0
	for node in _children:
		node.reset_node()

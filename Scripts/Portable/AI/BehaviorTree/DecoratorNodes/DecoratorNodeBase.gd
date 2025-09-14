class_name DecoratorNodeBase extends BehaviorNodeBase

var _child: BehaviorNodeBase

func init_node(tree: BehaviorTree) -> void:
	super.init_node(tree)

	var child_nodes: Array[Node] = get_children()
	if child_nodes.size() > 1 || child_nodes.size() == 0:
		return

	for node in child_nodes:
		var behavior_node: BehaviorNodeBase = node as BehaviorNodeBase
		if behavior_node != null:
			behavior_node.init_node(tree)
			_child = behavior_node

func reset_node() -> void:
	if _child != null:
		_child.reset_node()

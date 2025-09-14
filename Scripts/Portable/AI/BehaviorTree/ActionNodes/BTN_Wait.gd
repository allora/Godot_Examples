@icon("res://Scripts/Portable/AI/BehaviorTree/icon/wait.svg")

class_name BTNWait extends BehaviorNodeBase

@export
var wait_time: float

var _timer: Timer

var _timer_complete: bool

func init_node(tree: BehaviorTree) -> void:
	super.init_node(tree)

	_timer_complete = false
	_timer = Timer.new()
	_timer.stop()
	_timer.timeout.connect(_on_timer_complete)

	self.add_child(_timer)

func reset_node() -> void:
	super.reset_node()
	_timer_complete = false
	_timer.stop()

func _on_tick(blackboard: BlackBoardBase, child_result: BehaviorResult) -> BehaviorResult:
	if _timer.is_stopped():
		_timer.start(wait_time)

	if _timer_complete:
		reset_node()
		return BehaviorResult.Success
	else:
		return BehaviorResult.Running

func _on_timer_complete() -> void:
	_timer_complete = true
	_timer.stop()

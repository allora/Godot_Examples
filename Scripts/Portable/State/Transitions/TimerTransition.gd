class_name TimerTransition extends TransitionBase

@export
var wait_time: float

var _timer: Timer
var _last_print_time: float

func _ready() -> void:
	_timer = Timer.new()
	add_child(_timer)
	_timer.stop()
	_last_print_time = wait_time

func _on_tick(_delta: float) -> void:
	if not _timer.is_stopped():
		if ceil(_timer.time_left) > floor(_timer.time_left) && _last_print_time > floor(_timer.time_left):
			print(floor(_timer.time_left))
			_last_print_time = floor(_timer.time_left)

func _on_activated() -> void:
	_timer.start(wait_time)
	_timer.timeout.connect(_on_timer_complete)

func _on_deactivated() -> void:
	_timer.timeout.disconnect(_on_timer_complete)
	_timer.stop()

func _on_timer_complete() -> void:
	transition_complete.emit(_destination_state)

class_name ActionBase extends StateBehaviorBase

var _is_valid_state_parent: bool
var _parent_state: State

func _ready() -> void:
	_is_active = false
	_is_valid_state_parent = false
	_parent_state = get_parent() as State

	if _parent_state != null:
		_is_valid_state_parent = true
		if _has_on_enter():
			_parent_state.on_state_enter.connect(_on_enter)
		if _has_on_exit():
			_parent_state.on_state_enter.connect(_on_exit)

func _on_enter() -> void:
	pass
func _on_exit() -> void:
	pass

func _has_on_enter() -> bool:
	return false
func _has_on_exit() -> bool:
	return false

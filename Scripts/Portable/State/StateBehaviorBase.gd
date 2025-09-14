class_name StateBehaviorBase extends Node

@export
var _has_tick: bool = false

var _id: int
var _is_active: bool

func set_id(id:int) -> void:
	_id = id

func activate() -> void:
	_is_active = true
	_on_activated()

func _on_activated() -> void:
	pass

func deactivate() -> void:
	_is_active = false
	_on_deactivated()

func _on_deactivated() -> void:
	pass

func _ready() -> void:
	_is_active = false

## Tick that is ultimately called by the root node
func _process(delta: float) -> void:
	if not _is_active || not _has_tick:
		return

	_on_tick(delta)

## Derived tick event
func _on_tick(_delta: float) -> void:
	pass

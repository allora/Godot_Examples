@icon ("res://Scripts/Portable/AI/BehaviorTree/icon/blackboard.svg")

class_name BlackBoardBase extends Node

var _blackboard: Dictionary[StringName, BlackBoardEntry]

func init() -> void:
	for child in get_children():
		var entry: BlackBoardEntry = child as BlackBoardEntry
		if entry != null:
			if _blackboard.has(entry.name):
				push_error("Blackboard error! Duplicate entries!")
				return

			_blackboard[entry.name] = entry

	# Reset the data
	reset()

func reset() -> void:
	for entry in _blackboard.values():
		entry.reset()

func get_by_key(key: StringName) -> Variant:
	if _blackboard == null:
		push_error("BehaviorTree: Error missing blackboard")

	if _blackboard.has(key):
		return _blackboard[key].get_value()

	push_error("Blackboard: Invalid blackboard key")
	return null

func set_value(key: StringName, value: Variant) -> bool:
	if _blackboard == null:
		push_error("BehaviorTree: Error missing blackboard")

	if !_blackboard.has(key):
		push_error("Blackboard: Invalid blackboard key")
		return false

	var success: bool = false
	if _blackboard.has(key):
		success = _blackboard[key].set_value(value)

	return success

func is_entry_of_type(key: StringName, type: BlackBoardEntry.EntryType) -> bool:
	if _blackboard.has(key):
		return _blackboard[key].type == type

	return false

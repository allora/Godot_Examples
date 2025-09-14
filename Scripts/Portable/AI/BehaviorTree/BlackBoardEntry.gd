@icon ("res://Scripts/Portable/AI/BehaviorTree/icon/blackboard_entry.svg")

@tool
class_name BlackBoardEntry
extends Node

enum EntryType {Int, Float, Bool, Vector, Actor}

@export var type: BlackBoardEntry.EntryType = BlackBoardEntry.EntryType.Int:
	set(entry_type):
		type = entry_type
		notify_property_list_changed()

var int_value: int
var float_value: float
var bool_value: bool
var vector_value: Vector2
var actor_value: Node

var _default_int_value: int
var _default_float_value: float
var _default_bool_value: bool
var _default_vector_value: Vector2
var _default_actor_value: Node

func _get(property: StringName) -> Variant:
	if property.begins_with("Value"):
		match type:
			BlackBoardEntry.EntryType.Int:
				return _default_int_value
			BlackBoardEntry.EntryType.Float:
				return _default_float_value
			BlackBoardEntry.EntryType.Bool:
				return _default_bool_value
			BlackBoardEntry.EntryType.Vector:
				return _default_vector_value
			BlackBoardEntry.EntryType.Actor:
				return _default_actor_value

	return null

func _set(property: StringName, value: Variant) -> bool:
	var result: bool = false

	if property.begins_with("Value"):
		match type:
			BlackBoardEntry.EntryType.Int:
				_default_int_value = value
				result = true
			BlackBoardEntry.EntryType.Float:
				_default_float_value = value
				result = true
			BlackBoardEntry.EntryType.Bool:
				_default_bool_value = value
				result = true
			BlackBoardEntry.EntryType.Vector:
				_default_vector_value = value
				result = true
			BlackBoardEntry.EntryType.Actor:
				_default_actor_value = value
				result = true

	if result:
		notify_property_list_changed()

	return result

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary]

	match type:
		BlackBoardEntry.EntryType.Int:
			properties.append({
				"name": "Value",
				"type": TYPE_INT,
				"usage": PROPERTY_USAGE_DEFAULT
			})
		BlackBoardEntry.EntryType.Float:
			properties.append({
				"name": "Value",
				"type": TYPE_FLOAT,
				"usage": PROPERTY_USAGE_DEFAULT
			})
		BlackBoardEntry.EntryType.Bool:
			properties.append({
				"name": "Value",
				"type": TYPE_BOOL,
				"usage": PROPERTY_USAGE_DEFAULT
			})
		BlackBoardEntry.EntryType.Vector:
			properties.append({
				"name": "Value",
				"type": TYPE_VECTOR2,
				"usage": PROPERTY_USAGE_DEFAULT
			})
		BlackBoardEntry.EntryType.Actor:
			properties.append({
				"name": "Value",
				"type": TYPE_NODE_PATH,
				"usage": PROPERTY_USAGE_DEFAULT
			})

	return properties

func reset():
	match type:
		EntryType.Int:
			int_value = _default_int_value
		EntryType.Float:
			float_value = _default_float_value
		EntryType.Bool:
			bool_value = _default_bool_value
		EntryType.Vector:
			vector_value = _default_vector_value
		EntryType.Actor:
			actor_value = _default_actor_value
		_:
			push_error("Blackboard entry has invalid type")

func set_value(value) -> bool:
	var success: bool = false
	match type:
		EntryType.Int:
			if value is int:
				int_value = value
				success = true
		EntryType.Float:
			if value is float:
				float_value = value
				success = true
		EntryType.Bool:
			if value is bool:
				bool_value = value
				success = true
		EntryType.Vector:
			if value is Vector2:
				vector_value = value
				success = true
		EntryType.Actor:
			if value is Node:
				actor_value = value
				success = true

	if !success:
		push_error("Blackboard entry has invalid type")

	return success

func get_value() -> Variant:
	match type:
		EntryType.Int:
			return int_value
		EntryType.Float:
			return float_value
		EntryType.Bool:
			return bool_value
		EntryType.Vector:
			return vector_value
		EntryType.Actor:
			return actor_value
		_:
			push_error("Blackboard entry has invalid type")

	return false

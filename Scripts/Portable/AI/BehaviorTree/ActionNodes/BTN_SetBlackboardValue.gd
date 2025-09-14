@tool
class_name BTNSetBlackboardValue
extends BehaviorNodeBase

@export
var key: StringName

@export var type: BlackBoardEntry.EntryType = BlackBoardEntry.EntryType.Int:
	set(entry_type):
		type = entry_type
		notify_property_list_changed()

var _int_value: int
var _float_value: float
var _bool_value: bool
var _vector_value: Vector2
var _actor_value: Node

var _toggle: bool

func _get(property: StringName) -> Variant:
	if property.begins_with("Value"):
		match type:
			BlackBoardEntry.EntryType.Int:
				return _int_value
			BlackBoardEntry.EntryType.Float:
				return _float_value
			BlackBoardEntry.EntryType.Bool:
				return _bool_value
			BlackBoardEntry.EntryType.Vector:
				return _vector_value
			BlackBoardEntry.EntryType.Actor:
				return _actor_value
			_:
				return null

	if property.begins_with("Toggle"):
		return _toggle

	return null

func _set(property: StringName, value: Variant) -> bool:
	var result: bool = false
	if property.begins_with("Value"):
		match type:
			BlackBoardEntry.EntryType.Int:
				_int_value = value
				result = true
			BlackBoardEntry.EntryType.Float:
				_float_value = value
				result = true
			BlackBoardEntry.EntryType.Bool:
				if _toggle:
					_bool_value = false
				else:
					_bool_value = value
				result = true
			BlackBoardEntry.EntryType.Vector:
				_vector_value = value
				result = true
			BlackBoardEntry.EntryType.Actor:
				_actor_value = value
				result = true

	if property.begins_with("Toggle"):
		_toggle = value
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
				"name": "Toggle",
				"type": TYPE_BOOL,
				"usage": PROPERTY_USAGE_DEFAULT
			})
			if !_toggle:
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

func _on_tick(blackboard: BlackBoardBase, child_result: BehaviorResult) -> BehaviorResult:
	if !blackboard.is_entry_of_type(key, type):
		push_error("BTN_SetBlackboardValue: Error type mismatch")
		return BehaviorResult.Fail

	var value
	match type:
		BlackBoardEntry.EntryType.Int:
			value = _int_value
		BlackBoardEntry.EntryType.Float:
			value = _float_value
		BlackBoardEntry.EntryType.Bool:
			if _toggle:
				value = !(blackboard.get_by_key(key) as bool)
			else:
				value = _bool_value

		BlackBoardEntry.EntryType.Vector:
			value = _vector_value
		BlackBoardEntry.EntryType.Actor:
			value = _actor_value
		_:
			push_error("BTN_SetBlackboardValue failed to decipher type")
			return BehaviorResult.Fail

	if blackboard.set_value(key, value):
		return BehaviorResult.Success
	else:
		push_error("BTN_SetBlackboardValue: Failed to set value")
		return BehaviorResult.Fail

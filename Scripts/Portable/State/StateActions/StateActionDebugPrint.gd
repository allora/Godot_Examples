class_name ActionDebugPrint extends ActionBase

@export
var msg: String

func _on_enter() -> void:
	print(msg)

func _has_on_enter() -> bool:
	return true

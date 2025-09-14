class_name TransitionBase extends StateBehaviorBase

signal transition_complete(state:State)

@export
var _destination_state: State

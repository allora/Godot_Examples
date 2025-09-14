class_name State extends Node

signal on_state_enter
signal on_state_exit

@export
var _initial_state: State

var _transitions : Array[TransitionBase] = []
var _state_actions : Array[ActionBase] = []
var _sub_states : Array[State] = []

var _active_sub_state: State
var _parent: State
var _root: State

var _depth: int

var _is_transitioning: bool
var _is_entered: bool

func _to_string() -> String:
	return name

func _ready() -> void:
	_is_transitioning = false
	_is_entered = false

	_active_sub_state = null

	_parent = get_parent() as State

	# Setup transitions and sub states
	var transition_count: int = 0
	var nodes = get_children()
	for node in nodes:
		if node is TransitionBase:
			var transition: TransitionBase = node as TransitionBase
			transition.set_id(transition_count)
			transition.transition_complete.connect(_on_transition_complete)
			transition_count += 1
			_transitions.append(transition)

		if node is ActionBase:
			var state_action: ActionBase = node as ActionBase
			_state_actions.append(state_action)

		if node is State:
			var state: State = node as State
			_sub_states.append(state)

	call_deferred("_deferred_state_init")

func _deferred_state_init() -> void:
		# Apply root node to the tree
	if _parent == null:
		_depth = 0
		for state in _sub_states:
			state.set_root(self, _depth + 1)

	if _parent == null && _initial_state != null:
		_change_state(_initial_state)

## When a transition completes, this function triggers a change state to the
## passed in target state
func _on_transition_complete(state:State) -> void:
	_change_state(state)

## Changes the current state to the target state
func _change_state(state:State) -> void:
	if state == null:
		push_error("target state is null!")
		return

	# we're already transitioning, so early out
	if _is_transitioning:
		return

	# Start the transition
	_is_transitioning = true

	# exit state if we are in the entered state and our target isnt a sub state
	if _is_entered && !has_sub_state(state, true):
		# exit self
		state_exit()
		# since we are exiting this state, traverse the tree upward to the common parent
		exit_parents(state)

	state.state_enter()
	_is_transitioning = false
	print("State Changed! ", state)

## Set this state's root state to the new given root
func set_root(root:State, depth: int) -> void:
	_root = root

	_depth = depth

	for state in _sub_states:
		state.set_root(root, depth + 1)

## Called by _change_state() when entering the new state
func state_enter() -> void:
	# We reached a state that is already entered, so we can stop crawling up the
	# graph
	if _is_entered:
		return

	_is_entered = true
	if _parent != null:
		_parent.state_enter()
		_parent.set_active_sub_state(self)

	for transition in _transitions:
		transition.activate()

	for state_action in _state_actions:
		state_action.activate()

	print("Entering state ", self)
	on_state_enter.emit()

## Called by _change_state() when exiting the current state
func state_exit() -> void:
	# trigger any state actions on exit
	on_state_exit.emit()
	_is_entered = false

	# Deactivate the transitions for this state
	for transition in _transitions:
		transition.deactivate()

	# Deactivate the state actions for this state
	for state_action in _state_actions:
		state_action.deactivate()

	print("Exiting state ", self)

## Exits parent states until we find a state with our target state
func exit_parents(target_state: State) -> void:
	if target_state == null:
		return

	if _parent != null:
		if _parent.has_sub_state(target_state, true, self):
			return
		else:
			_parent.state_exit()
			_parent.exit_parents(target_state)

## Returns true when _sub_states contains the given state
func has_sub_state(state: State, has_recursion: bool = false, ignore_state: State = null) -> bool:
	if _sub_states.has(state):
		return true

	if has_recursion:
		for sub_state in _sub_states:
			# skip the ignored state
			if sub_state == ignore_state:
				continue

			if sub_state.has_sub_state(state, has_recursion, ignore_state):
				return true

	return false

func set_active_sub_state(state: State) -> void:
	_active_sub_state = state

extends Node2D

@export var player: Player
@export var camera: Camera2D
@export var rooms: Array[Room]
@export var starting_room: Room

var _current_room: Room = null

func _ready() -> void:
	for room in rooms:
		room.player_entered.connect(_on_player_entered_room)

#region class api

func setup(state: GameState) -> void:
	player.display(state.tavern_manager)
	player.global_position = starting_room.spawn.global_position
	_enter_room(starting_room)
	camera.reset_smoothing()

#endregion

#region signal handlers

func _on_player_entered_room(room: Room) -> void:
	if room == _current_room:
		return
	_enter_room(room)

#endregion

#region internals

func _enter_room(room: Room) -> void:
	_current_room = room
	camera.global_position = room.camera_target()

#endregion

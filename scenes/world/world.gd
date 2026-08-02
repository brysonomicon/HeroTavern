extends Node2D

@export var player: Player
@export var spawn_point: Marker2D

#region class api

func setup(state: GameState) -> void:
	player.display(state.tavern_manager)
	player.global_position = spawn_point.global_position

#endregion

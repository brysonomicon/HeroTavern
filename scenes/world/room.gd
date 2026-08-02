class_name Room
extends Node2D

signal player_entered(room: Room)

@export var display_name: String = ""
@export var trigger: Area2D
@export var spawn: Marker2D

func _ready() -> void:
	trigger.body_entered.connect(_on_body_entered)


#region signal handlers

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_entered.emit(self)

#endregion

#region class api

func camera_target() -> Vector2:
	return global_position

#endregion

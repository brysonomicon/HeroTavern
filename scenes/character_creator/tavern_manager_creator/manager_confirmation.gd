extends Control

signal complete

@export var title: String = "The Manager"

@export var character_name: LineEdit
@export var preview: CharacterSprite

func _ready() -> void:
	character_name.text_changed.connect(_on_name_changed)

#region signal handlers

func _on_name_changed(text: String) -> void:
	complete.emit()

#endregion

#region class api

func review(character: Character) -> void:
	preview.display(character)

func is_complete() -> bool:
	return not character_name.text.strip_edges().is_empty()

func assign_property(character: Character) -> void:
	character.character_name = character_name.text.strip_edges().capitalize()

#endregion

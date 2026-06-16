extends Control

signal start_new_game
signal continue_game
signal open_settings


@export var characterCreatorScene: PackedScene

func _on_new_game_button_pressed() -> void:
	print("new game pressed")
	start_new_game.emit()
	
func _on_continue_button_pressed() -> void:
	print("continue pressed")
	continue_game.emit()
	
func _on_settings_button_pressed() -> void:
	SceneRouter.goto(SettingsScene)
	print("settings pressed")
	open_settings.emit()

func _on_quit_button_pressed() -> void:
	print("quit pressed")
	get_tree().quit()
	
func _on_character_editor_button_pressed() -> void:
	SceneRouter.goto(characterCreatorScene)
	print("To Coreys Character Creator!")
	

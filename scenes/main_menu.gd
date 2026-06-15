extends Control

@export var SettingsScene: PackedScene
@export var CharCreateScene: PackedScene
@export var characterCreatorScene: PackedScene

func _on_new_game_button_pressed() -> void:
	SceneRouter.goto(CharCreateScene)
	print("new game pressed")
	
func _on_continue_button_pressed() -> void:
	print("continue pressed")
	
func _on_settings_button_pressed() -> void:
	SceneRouter.goto(SettingsScene)
	print("settings pressed")

func _on_quit_button_pressed() -> void:
	print("quit pressed")
	get_tree().quit()
	
func _on_character_editor_button_pressed() -> void:
	SceneRouter.goto(characterCreatorScene)
	print("To Coreys Character Creator!")
	

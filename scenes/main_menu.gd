extends Control
@export var NewGameButton: Button
@export var ContinueButton: Button
@export var SettingsButton: Button
@export var QuitButton: Button
@export var SettingsScene: PackedScene
@export var characterCreatorScene: PackedScene

# register event listeners 
func _ready() -> void:
	NewGameButton.pressed.connect(_on_new_game_pressed)
	ContinueButton.pressed.connect(_on_continue_pressed)
	SettingsButton.pressed.connect(_on_settings_pressed)
	QuitButton.pressed.connect(_on_quit_pressed)

func _on_new_game_pressed() -> void:
	print("new game pressed")
	
func _on_continue_pressed() -> void:
	print("continue pressed")
	
func _on_settings_pressed() -> void:
	SceneRouter.goto(SettingsScene)
	print("settings pressed")

func _on_quit_pressed() -> void:
	get_tree().quit()
	
func on_character_creator_pressed() -> void:
	get_tree().change_scene_to_file(characterCreatorScene.resource_path)
	
